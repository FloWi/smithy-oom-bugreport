package smithy4sbugreport

import com.github.plokhotnyuk.jsoniter_scala.core.JsonCodec
import io.circe.{Decoder, Encoder}

import scala.util.Try

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
