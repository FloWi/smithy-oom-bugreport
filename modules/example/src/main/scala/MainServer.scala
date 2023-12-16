import cats.effect.{IO, IOApp, Ref}
import cats.implicits.{catsSyntaxParallelTraverse1, toTraverseOps}
import com.github.plokhotnyuk.jsoniter_scala.core.JsonCodec
import io.circe.syntax.EncoderOps
import io.circe.{Decoder, Encoder}
import spacetraders.{Waypoint, WaypointSymbol}

import java.nio.file.{Files, Paths}
import scala.concurrent.duration.DurationInt
import scala.language.postfixOps
import scala.util.{Random, Try}

object MainServer extends IOApp.Simple {

  import AStarWithFuelDebug._

  val exampleJsonString: String =
    Files.readString(Paths.get(getClass.getResource("/example-data.json").toURI))

  override def run: IO[Unit] = {

    for {
      waypointRef <- Ref.of[IO, Vector[Waypoint]](Vector.empty)
      counterRef  <- Ref.of[IO, Int](0)
      data         = io.circe.parser.decode[AStarWithFuelDebug](exampleJsonString).toOption.get
      _           <- stresstestJsonStuff(data, waypointRef, counterRef)
    } yield ()

  }

  def stresstestJsonStuff(data: AStarWithFuelDebug, waypointRef: Ref[IO, Vector[Waypoint]], counter: Ref[IO, Int]) = {

    1.to(1000000).toList.parTraverse { _ =>
      counter.updateAndGet(_ + 1).flatMap { i =>
        encodeAndDecode(data).flatMap { result =>
          if (i % 1000 == 0) {
            val waypointSymbolStrings   = result.map(_.symbol.value)
            val convertedBackToNewTypes = waypointSymbolStrings.map(str => WaypointSymbol(str))

            IO.println(s"$i: manipulating Ref and then waiting 10ms. Got ${convertedBackToNewTypes.distinct.size} waypointSymbols") *> waypointRef
              .set(Random.shuffle(result).take(25).toVector) *> IO.sleep(10.millis)
          } else IO.unit
        }
      }
    }
  }

  def encoded(aStarWithFuelDebug: AStarWithFuelDebug) = aStarWithFuelDebug.allWaypoints.asJson.noSpacesSortKeys

  def decoded(encodedJson: String) = io.circe.parser.decode[List[Waypoint]](encodedJson).toOption.get

  def encodeAndDecode(data: AStarWithFuelDebug) =
    IO {
      val encodedStr  = encoded(data)
      val decodedData = decoded(encodedStr)
      decodedData
    }

}

object CodecsHelper {

  // Ships can't be serialized to string by circe auto codecs, because some fields (like reactor) don't play nicely with it. (newtypes)
  def toJsonString[A: JsonCodec](
    a: A
  ): String = {
    com.github.plokhotnyuk.jsoniter_scala.core.writeToStringReentrant(a)
  }

  import cats.implicits._

  // Ships can't be serialized to string by circe auto codecs, because some fields (like reactor) don't play nicely with it. (newtypes)
  def fromJsonString[A: JsonCodec](
    str: String
  ): Either[Throwable, A] = {
    Either.fromTry(Try(com.github.plokhotnyuk.jsoniter_scala.core.readFromStringReentrant(str)))
  }

  def circeViaJsoniterEncoder[A: JsonCodec]: Encoder[A] = Encoder.encodeJson.contramap { e =>
    val str = toJsonString(e)
    io.circe.parser.parse(str).toOption.get
  }

  def circeViaJsoniterDecoder[A: JsonCodec]: Decoder[A] =
    Decoder.decodeJson.emap(json => fromJsonString[A](json.noSpaces).leftMap(_.getMessage))

}

case class AStarWithFuelDebug(
  startSymbol: WaypointSymbol,
  goalSymbol: WaypointSymbol,
  allWaypoints: List[Waypoint],
  shipSpeed: Int,
  fuel: Int,
  fuelCapacity: Int,
  refuelingStations: List[WaypointSymbol],
)

object AStarWithFuelDebug {

  import CodecsHelper._
  import smithy4s.json.Json.deriveJsonCodec

  implicit val encoderWaypoint: Encoder[Waypoint]                     = circeViaJsoniterEncoder
  implicit val decoderWaypoint: Decoder[Waypoint]                     = circeViaJsoniterDecoder
  implicit val encoderWaypointSymbol: Encoder[WaypointSymbol]         = circeViaJsoniterEncoder
  implicit val decoderWaypointSymbol: Decoder[WaypointSymbol]         = circeViaJsoniterDecoder
  implicit val encoderAStarWithFuelDebug: Encoder[AStarWithFuelDebug] = io.circe.generic.semiauto.deriveEncoder
  implicit val decoderAStarWithFuelDebug: Decoder[AStarWithFuelDebug] = io.circe.generic.semiauto.deriveDecoder
}
