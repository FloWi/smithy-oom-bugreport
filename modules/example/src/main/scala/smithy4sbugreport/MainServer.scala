package smithy4sbugreport

import cats.effect.{IO, IOApp, Ref}
import cats.implicits.catsSyntaxParallelTraverse1
import io.circe.syntax.EncoderOps
import spacetraders.{Waypoint, WaypointSymbol}

import scala.concurrent.duration.DurationInt
import scala.io.Source
import scala.language.postfixOps
import scala.util.Random

object MainServer extends IOApp.Simple {

  import AStarWithFuelDebug._

  val exampleJsonString: String =
    Source.fromResource("example-data.json").mkString

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
