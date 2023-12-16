package smithy4sbugreport

import io.circe.{Decoder, Encoder}
import spacetraders.{Waypoint, WaypointSymbol}

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
