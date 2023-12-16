$version: "2.0"

namespace spacetraders

use alloy#simpleRestJson
use alloy#dataExamples
use alloy.openapi#openapiExtensions
use smithytranslate#contentType

@auth([
    httpBearerAuth
])
@httpBearerAuth
@simpleRestJson
service OpenapiService {
    operations: [
        AcceptContract
        CreateChart
        CreateShipShipScan
        CreateShipSystemScan
        CreateShipWaypointScan
        CreateSurvey
        DeliverContract
        DockShip
        ExtractResources
        ExtractResourcesWithSurvey
        FulfillContract
        GetAgent
        GetAgents
        GetConstruction
        GetContract
        GetContracts
        GetFaction
        GetFactions
        GetJumpGate
        GetMarket
        GetMounts
        GetMyAgent
        GetMyShip
        GetMyShipCargo
        GetMyShips
        GetShipCooldown
        GetShipNav
        GetShipyard
        GetStatus
        GetSystem
        GetSystems
        GetSystemWaypoints
        GetWaypoint
        InstallMount
        Jettison
        JumpShip
        NavigateShip
        NegotiateContract
        OrbitShip
        PatchShipNav
        PurchaseCargo
        PurchaseShip
        RefuelShip
        Register
        RemoveMount
        SellCargo
        ShipRefine
        SiphonResources
        SupplyConstruction
        TransferCargo
        WarpShip
    ]
}

/// Accept a contract by ID.
///
/// You can only accept contracts that were offered to you, were not accepted yet, and whose deadlines has not passed yet.
@auth([
    httpBearerAuth
])
@http(
    method: "POST"
    uri: "/my/contracts/{contractId}/accept"
    code: 200
)
operation AcceptContract {
    input: AcceptContractInput
    output: AcceptContract200
}

/// Command a ship to chart the waypoint at its current location.
///
/// Most waypoints in the universe are uncharted by default. These waypoints have their traits hidden until they have been charted by a ship.
///
/// Charting a waypoint will record your agent as the one who created the chart, and all other agents would also be able to see the waypoint's traits.
@auth([
    httpBearerAuth
])
@http(
    method: "POST"
    uri: "/my/ships/{shipSymbol}/chart"
    code: 201
)
operation CreateChart {
    input: CreateChartInput
    output: CreateChart201
}

/// Scan for nearby ships, retrieving information for all ships in range.
///
/// Requires a ship to have the `Sensor Array` mount installed to use.
///
/// The ship will enter a cooldown after using this function, during which it cannot execute certain actions.
@auth([
    httpBearerAuth
])
@http(
    method: "POST"
    uri: "/my/ships/{shipSymbol}/scan/ships"
    code: 201
)
operation CreateShipShipScan {
    input: CreateShipShipScanInput
    output: CreateShipShipScan201
}

/// Scan for nearby systems, retrieving information on the systems' distance from the ship and their waypoints. Requires a ship to have the `Sensor Array` mount installed to use.
///
/// The ship will enter a cooldown after using this function, during which it cannot execute certain actions.
@auth([
    httpBearerAuth
])
@http(
    method: "POST"
    uri: "/my/ships/{shipSymbol}/scan/systems"
    code: 201
)
operation CreateShipSystemScan {
    input: CreateShipSystemScanInput
    output: CreateShipSystemScan201
}

/// Scan for nearby waypoints, retrieving detailed information on each waypoint in range. Scanning uncharted waypoints will allow you to ignore their uncharted state and will list the waypoints' traits.
///
/// Requires a ship to have the `Sensor Array` mount installed to use.
///
/// The ship will enter a cooldown after using this function, during which it cannot execute certain actions.
@auth([
    httpBearerAuth
])
@http(
    method: "POST"
    uri: "/my/ships/{shipSymbol}/scan/waypoints"
    code: 201
)
operation CreateShipWaypointScan {
    input: CreateShipWaypointScanInput
    output: CreateShipWaypointScan201
}

/// Create surveys on a waypoint that can be extracted such as asteroid fields. A survey focuses on specific types of deposits from the extracted location. When ships extract using this survey, they are guaranteed to procure a high amount of one of the goods in the survey.
///
/// In order to use a survey, send the entire survey details in the body of the extract request.
///
/// Each survey may have multiple deposits, and if a symbol shows up more than once, that indicates a higher chance of extracting that resource.
///
/// Your ship will enter a cooldown after surveying in which it is unable to perform certain actions. Surveys will eventually expire after a period of time or will be exhausted after being extracted several times based on the survey's size. Multiple ships can use the same survey for extraction.
///
/// A ship must have the `Surveyor` mount installed in order to use this function.
@auth([
    httpBearerAuth
])
@http(
    method: "POST"
    uri: "/my/ships/{shipSymbol}/survey"
    code: 201
)
operation CreateSurvey {
    input: CreateSurveyInput
    output: CreateSurvey201
}

/// Deliver cargo to a contract.
///
/// In order to use this API, a ship must be at the delivery location (denoted in the delivery terms as `destinationSymbol` of a contract) and must have a number of units of a good required by this contract in its cargo.
///
/// Cargo that was delivered will be removed from the ship's cargo.
@auth([
    httpBearerAuth
])
@http(
    method: "POST"
    uri: "/my/contracts/{contractId}/deliver"
    code: 200
)
operation DeliverContract {
    input: DeliverContractInput
    output: DeliverContract200
}

/// Attempt to dock your ship at its current location. Docking will only succeed if your ship is capable of docking at the time of the request.
///
/// Docked ships can access elements in their current location, such as the market or a shipyard, but cannot do actions that require the ship to be above surface such as navigating or extracting.
///
/// The endpoint is idempotent - successive calls will succeed even if the ship is already docked.
@auth([
    httpBearerAuth
])
@http(
    method: "POST"
    uri: "/my/ships/{shipSymbol}/dock"
    code: 200
)
operation DockShip {
    input: DockShipInput
    output: DockShip200
}

/// Extract resources from a waypoint that can be extracted, such as asteroid fields, into your ship. Send an optional survey as the payload to target specific yields.
///
/// The ship must be in orbit to be able to extract and must have mining equipments installed that can extract goods, such as the `Gas Siphon` mount for gas-based goods or `Mining Laser` mount for ore-based goods.
///
/// The survey property is now deprecated. See the `extract/survey` endpoint for more details.
@auth([
    httpBearerAuth
])
@http(
    method: "POST"
    uri: "/my/ships/{shipSymbol}/extract"
    code: 201
)
operation ExtractResources {
    input: ExtractResourcesInput
    output: ExtractResources201
}

/// Use a survey when extracting resources from a waypoint. This endpoint requires a survey as the payload, which allows your ship to extract specific yields.
///
/// Send the full survey object as the payload which will be validated according to the signature. If the signature is invalid, or any properties of the survey are changed, the request will fail.
@auth([
    httpBearerAuth
])
@http(
    method: "POST"
    uri: "/my/ships/{shipSymbol}/extract/survey"
    code: 201
)
operation ExtractResourcesWithSurvey {
    input: ExtractResourcesWithSurveyInput
    output: ExtractResourcesWithSurvey201
}

/// Fulfill a contract. Can only be used on contracts that have all of their delivery terms fulfilled.
@auth([
    httpBearerAuth
])
@http(
    method: "POST"
    uri: "/my/contracts/{contractId}/fulfill"
    code: 200
)
operation FulfillContract {
    input: FulfillContractInput
    output: FulfillContract200
}

/// Fetch agent details.
@auth([
    httpBearerAuth
])
@http(
    method: "GET"
    uri: "/agents/{agentSymbol}"
    code: 200
)
operation GetAgent {
    input: GetAgentInput
    output: GetAgent200
}

/// Fetch agents details.
@auth([
    httpBearerAuth
])
@http(
    method: "GET"
    uri: "/agents"
    code: 200
)
operation GetAgents {
    input: GetAgentsInput
    output: GetAgents200
}

/// Get construction details for a waypoint. Requires a waypoint with a property of `isUnderConstruction` to be true.
@auth([
    httpBearerAuth
])
@http(
    method: "GET"
    uri: "/systems/{systemSymbol}/waypoints/{waypointSymbol}/construction"
    code: 200
)
operation GetConstruction {
    input: GetConstructionInput
    output: GetConstruction200
}

/// Get the details of a contract by ID.
@auth([
    httpBearerAuth
])
@http(
    method: "GET"
    uri: "/my/contracts/{contractId}"
    code: 200
)
operation GetContract {
    input: GetContractInput
    output: GetContract200
}

/// Return a paginated list of all your contracts.
@auth([
    httpBearerAuth
])
@http(
    method: "GET"
    uri: "/my/contracts"
    code: 200
)
operation GetContracts {
    input: GetContractsInput
    output: GetContracts200
}

/// View the details of a faction.
@http(
    method: "GET"
    uri: "/factions/{factionSymbol}"
    code: 200
)
operation GetFaction {
    input: GetFactionInput
    output: GetFaction200
}

/// Return a paginated list of all the factions in the game.
@auth([
    httpBearerAuth
])
@http(
    method: "GET"
    uri: "/factions"
    code: 200
)
operation GetFactions {
    input: GetFactionsInput
    output: GetFactions200
}

/// Get jump gate details for a waypoint. Requires a waypoint of type `JUMP_GATE` to use.
///
/// Waypoints connected to this jump gate can be
@auth([
    httpBearerAuth
])
@http(
    method: "GET"
    uri: "/systems/{systemSymbol}/waypoints/{waypointSymbol}/jump-gate"
    code: 200
)
operation GetJumpGate {
    input: GetJumpGateInput
    output: GetJumpGate200
}

/// Retrieve imports, exports and exchange data from a marketplace. Requires a waypoint that has the `Marketplace` trait to use.
///
/// Send a ship to the waypoint to access trade good prices and recent transactions. Refer to the [Market Overview page](https://docs.spacetraders.io/game-concepts/markets) to gain better a understanding of the market in the game.
@auth([
    httpBearerAuth
])
@http(
    method: "GET"
    uri: "/systems/{systemSymbol}/waypoints/{waypointSymbol}/market"
    code: 200
)
operation GetMarket {
    input: GetMarketInput
    output: GetMarket200
}

/// Get the mounts installed on a ship.
@auth([
    httpBearerAuth
])
@http(
    method: "GET"
    uri: "/my/ships/{shipSymbol}/mounts"
    code: 200
)
operation GetMounts {
    input: GetMountsInput
    output: GetMounts200
}

/// Fetch your agent's details.
@auth([
    httpBearerAuth
])
@http(
    method: "GET"
    uri: "/my/agent"
    code: 200
)
operation GetMyAgent {
    input: Unit
    output: GetMyAgent200
}

/// Retrieve the details of a ship under your agent's ownership.
@auth([
    httpBearerAuth
])
@http(
    method: "GET"
    uri: "/my/ships/{shipSymbol}"
    code: 200
)
operation GetMyShip {
    input: GetMyShipInput
    output: GetMyShip200
}

/// Retrieve the cargo of a ship under your agent's ownership.
@auth([
    httpBearerAuth
])
@http(
    method: "GET"
    uri: "/my/ships/{shipSymbol}/cargo"
    code: 200
)
operation GetMyShipCargo {
    input: GetMyShipCargoInput
    output: GetMyShipCargo200
}

/// Return a paginated list of all of ships under your agent's ownership.
@auth([
    httpBearerAuth
])
@http(
    method: "GET"
    uri: "/my/ships"
    code: 200
)
operation GetMyShips {
    input: GetMyShipsInput
    output: GetMyShips200
}

/// Retrieve the details of your ship's reactor cooldown. Some actions such as activating your jump drive, scanning, or extracting resources taxes your reactor and results in a cooldown.
///
/// Your ship cannot perform additional actions until your cooldown has expired. The duration of your cooldown is relative to the power consumption of the related modules or mounts for the action taken.
///
/// Response returns a 204 status code (no-content) when the ship has no cooldown.
@auth([
    httpBearerAuth
])
@http(
    method: "GET"
    uri: "/my/ships/{shipSymbol}/cooldown"
    code: 200
)
operation GetShipCooldown {
    input: GetShipCooldownInput
    output: GetShipCooldown200
}

/// Get the current nav status of a ship.
@auth([
    httpBearerAuth
])
@http(
    method: "GET"
    uri: "/my/ships/{shipSymbol}/nav"
    code: 200
)
operation GetShipNav {
    input: GetShipNavInput
    output: GetShipNav200
}

/// Get the shipyard for a waypoint. Requires a waypoint that has the `Shipyard` trait to use. Send a ship to the waypoint to access data on ships that are currently available for purchase and recent transactions.
@auth([
    httpBearerAuth
])
@http(
    method: "GET"
    uri: "/systems/{systemSymbol}/waypoints/{waypointSymbol}/shipyard"
    code: 200
)
operation GetShipyard {
    input: GetShipyardInput
    output: GetShipyard200
}

/// Return the status of the game server.
/// This also includes a few global elements, such as announcements, server reset dates and leaderboards.
@auth([
    httpBearerAuth
])
@http(
    method: "GET"
    uri: "/"
    code: 200
)
operation GetStatus {
    input: Unit
    output: GetStatus200
}

/// Get the details of a system.
@auth([
    httpBearerAuth
])
@http(
    method: "GET"
    uri: "/systems/{systemSymbol}"
    code: 200
)
operation GetSystem {
    input: GetSystemInput
    output: GetSystem200
}

/// Return a paginated list of all systems.
@auth([
    httpBearerAuth
])
@http(
    method: "GET"
    uri: "/systems"
    code: 200
)
operation GetSystems {
    input: GetSystemsInput
    output: GetSystems200
}

/// Return a paginated list of all of the waypoints for a given system.
///
/// If a waypoint is uncharted, it will return the `Uncharted` trait instead of its actual traits.
@auth([
    httpBearerAuth
])
@http(
    method: "GET"
    uri: "/systems/{systemSymbol}/waypoints"
    code: 200
)
operation GetSystemWaypoints {
    input: GetSystemWaypointsInput
    output: GetSystemWaypoints200
}

/// View the details of a waypoint.
///
/// If the waypoint is uncharted, it will return the 'Uncharted' trait instead of its actual traits.
@auth([
    httpBearerAuth
])
@http(
    method: "GET"
    uri: "/systems/{systemSymbol}/waypoints/{waypointSymbol}"
    code: 200
)
operation GetWaypoint {
    input: GetWaypointInput
    output: GetWaypoint200
}

/// Install a mount on a ship.
///
/// In order to install a mount, the ship must be docked and located in a waypoint that has a `Shipyard` trait. The ship also must have the mount to install in its cargo hold.
///
/// An installation fee will be deduced by the Shipyard for installing the mount on the ship.
@auth([
    httpBearerAuth
])
@http(
    method: "POST"
    uri: "/my/ships/{shipSymbol}/mounts/install"
    code: 201
)
operation InstallMount {
    input: InstallMountInput
    output: InstallMount201
}

/// Jettison cargo from your ship's cargo hold.
@auth([
    httpBearerAuth
])
@http(
    method: "POST"
    uri: "/my/ships/{shipSymbol}/jettison"
    code: 200
)
operation Jettison {
    input: JettisonInput
    output: Jettison200
}

/// Jump your ship instantly to a target connected waypoint. The ship must be in orbit to execute a jump.
///
/// A unit of antimatter is purchased and consumed from the market when jumping. The price of antimatter is determined by the market and is subject to change. A ship can only jump to connected waypoints
@auth([
    httpBearerAuth
])
@http(
    method: "POST"
    uri: "/my/ships/{shipSymbol}/jump"
    code: 200
)
operation JumpShip {
    input: JumpShipInput
    output: JumpShip200
}

/// Navigate to a target destination. The ship must be in orbit to use this function. The destination waypoint must be within the same system as the ship's current location. Navigating will consume the necessary fuel from the ship's manifest based on the distance to the target waypoint.
///
/// The returned response will detail the route information including the expected time of arrival. Most ship actions are unavailable until the ship has arrived at it's destination.
///
/// To travel between systems, see the ship's Warp or Jump actions.
@auth([
    httpBearerAuth
])
@http(
    method: "POST"
    uri: "/my/ships/{shipSymbol}/navigate"
    code: 200
)
operation NavigateShip {
    input: NavigateShipInput
    output: NavigateShip200
}

/// Negotiate a new contract with the HQ.
///
/// In order to negotiate a new contract, an agent must not have ongoing or offered contracts over the allowed maximum amount. Currently the maximum contracts an agent can have at a time is 1.
///
/// Once a contract is negotiated, it is added to the list of contracts offered to the agent, which the agent can then accept.
///
/// The ship must be present at any waypoint with a faction present to negotiate a contract with that faction.
@auth([
    httpBearerAuth
])
@http(
    method: "POST"
    uri: "/my/ships/{shipSymbol}/negotiate/contract"
    code: 201
)
operation NegotiateContract {
    input: NegotiateContractInput
    output: NegotiateContract201
}

/// Attempt to move your ship into orbit at its current location. The request will only succeed if your ship is capable of moving into orbit at the time of the request.
///
/// Orbiting ships are able to do actions that require the ship to be above surface such as navigating or extracting, but cannot access elements in their current waypoint, such as the market or a shipyard.
///
/// The endpoint is idempotent - successive calls will succeed even if the ship is already in orbit.
@auth([
    httpBearerAuth
])
@http(
    method: "POST"
    uri: "/my/ships/{shipSymbol}/orbit"
    code: 200
)
operation OrbitShip {
    input: OrbitShipInput
    output: OrbitShip200
}

/// Update the nav configuration of a ship.
///
/// Currently only supports configuring the Flight Mode of the ship, which affects its speed and fuel consumption.
@auth([
    httpBearerAuth
])
@http(
    method: "PATCH"
    uri: "/my/ships/{shipSymbol}/nav"
    code: 200
)
operation PatchShipNav {
    input: PatchShipNavInput
    output: PatchShipNav200
}

/// Purchase cargo from a market.
///
/// The ship must be docked in a waypoint that has `Marketplace` trait, and the market must be selling a good to be able to purchase it.
///
/// The maximum amount of units of a good that can be purchased in each transaction are denoted by the `tradeVolume` value of the good, which can be viewed by using the Get Market action.
///
/// Purchased goods are added to the ship's cargo hold.
@auth([
    httpBearerAuth
])
@http(
    method: "POST"
    uri: "/my/ships/{shipSymbol}/purchase"
    code: 201
)
operation PurchaseCargo {
    input: PurchaseCargoInput
    output: PurchaseCargo201
}

/// Purchase a ship from a Shipyard. In order to use this function, a ship under your agent's ownership must be in a waypoint that has the `Shipyard` trait, and the Shipyard must sell the type of the desired ship.
///
/// Shipyards typically offer ship types, which are predefined templates of ships that have dedicated roles. A template comes with a preset of an engine, a reactor, and a frame. It may also include a few modules and mounts.
@auth([
    httpBearerAuth
])
@http(
    method: "POST"
    uri: "/my/ships"
    code: 201
)
operation PurchaseShip {
    input: PurchaseShipInput
    output: PurchaseShip201
}

/// Refuel your ship by buying fuel from the local market.
///
/// Requires the ship to be docked in a waypoint that has the `Marketplace` trait, and the market must be selling fuel in order to refuel.
///
/// Each fuel bought from the market replenishes 100 units in your ship's fuel.
///
/// Ships will always be refuel to their frame's maximum fuel capacity when using this action.
@auth([
    httpBearerAuth
])
@http(
    method: "POST"
    uri: "/my/ships/{shipSymbol}/refuel"
    code: 200
)
operation RefuelShip {
    input: RefuelShipInput
    output: RefuelShip200
}

/// Creates a new agent and ties it to an account.
/// The agent symbol must consist of a 3-14 character string, and will be used to represent your agent. This symbol will prefix the symbol of every ship you own. Agent symbols will be cast to all uppercase characters.
///
/// This new agent will be tied to a starting faction of your choice, which determines your starting location, and will be granted an authorization token, a contract with their starting faction, a command ship that can fly across space with advanced capabilities, a small probe ship that can be used for reconnaissance, and 150,000 credits.
///
/// > #### Keep your token safe and secure
/// >
/// > Save your token during the alpha phase. There is no way to regenerate this token without starting a new agent. In the future you will be able to generate and manage your tokens from the SpaceTraders website.
///
/// If you are new to SpaceTraders, It is recommended to register with the COSMIC faction, a faction that is well connected to the rest of the universe. After registering, you should try our interactive [quickstart guide](https://docs.spacetraders.io/quickstart/new-game) which will walk you through basic API requests in just a few minutes.
@http(
    method: "POST"
    uri: "/register"
    code: 201
)
operation Register {
    input: RegisterInput
    output: Register201
}

/// Remove a mount from a ship.
///
/// The ship must be docked in a waypoint that has the `Shipyard` trait, and must have the desired mount that it wish to remove installed.
///
/// A removal fee will be deduced from the agent by the Shipyard.
@auth([
    httpBearerAuth
])
@http(
    method: "POST"
    uri: "/my/ships/{shipSymbol}/mounts/remove"
    code: 201
)
operation RemoveMount {
    input: RemoveMountInput
    output: RemoveMount201
}

/// Sell cargo in your ship to a market that trades this cargo. The ship must be docked in a waypoint that has the `Marketplace` trait in order to use this function.
@auth([
    httpBearerAuth
])
@http(
    method: "POST"
    uri: "/my/ships/{shipSymbol}/sell"
    code: 201
)
operation SellCargo {
    input: SellCargoInput
    output: SellCargo201
}

/// Attempt to refine the raw materials on your ship. The request will only succeed if your ship is capable of refining at the time of the request. In order to be able to refine, a ship must have goods that can be refined and have installed a `Refinery` module that can refine it.
///
/// When refining, 30 basic goods will be converted into 10 processed goods.
@auth([
    httpBearerAuth
])
@http(
    method: "POST"
    uri: "/my/ships/{shipSymbol}/refine"
    code: 201
)
operation ShipRefine {
    input: ShipRefineInput
    output: ShipRefine201
}

/// Siphon gases, such as hydrocarbon, from gas giants.
///
/// The ship must be in orbit to be able to siphon and must have siphon mounts and a gas processor installed.
@auth([
    httpBearerAuth
])
@http(
    method: "POST"
    uri: "/my/ships/{shipSymbol}/siphon"
    code: 201
)
operation SiphonResources {
    input: SiphonResourcesInput
    output: SiphonResources201
}

/// Supply a construction site with the specified good. Requires a waypoint with a property of `isUnderConstruction` to be true.
///
/// The good must be in your ship's cargo. The good will be removed from your ship's cargo and added to the construction site's materials.
@auth([
    httpBearerAuth
])
@http(
    method: "POST"
    uri: "/systems/{systemSymbol}/waypoints/{waypointSymbol}/construction/supply"
    code: 201
)
operation SupplyConstruction {
    input: SupplyConstructionInput
    output: SupplyConstruction201
}

/// Transfer cargo between ships.
///
/// The receiving ship must be in the same waypoint as the transferring ship, and it must able to hold the additional cargo after the transfer is complete. Both ships also must be in the same state, either both are docked or both are orbiting.
///
/// The response body's cargo shows the cargo of the transferring ship after the transfer is complete.
@auth([
    httpBearerAuth
])
@http(
    method: "POST"
    uri: "/my/ships/{shipSymbol}/transfer"
    code: 200
)
operation TransferCargo {
    input: TransferCargoInput
    output: TransferCargo200
}

/// Warp your ship to a target destination in another system. The ship must be in orbit to use this function and must have the `Warp Drive` module installed. Warping will consume the necessary fuel from the ship's manifest.
///
/// The returned response will detail the route information including the expected time of arrival. Most ship actions are unavailable until the ship has arrived at its destination.
@auth([
    httpBearerAuth
])
@http(
    method: "POST"
    uri: "/my/ships/{shipSymbol}/warp"
    code: 200
)
operation WarpShip {
    input: WarpShipInput
    output: WarpShip200
}

structure AcceptContract200 {
    @httpPayload
    @required
    body: AcceptContract200Body
}

structure AcceptContract200Body {
    @required
    data: AcceptContract200BodyData
}

structure AcceptContract200BodyData {
    @required
    agent: Agent
    @required
    contract: Contract
}

structure AcceptContractInput {
    /// The contract ID to accept.
    @httpLabel
    @required
    contractId: String
}

/// Agent details.
structure Agent {
    /// Account ID that is tied to this agent. Only included on your own agent.
    @length(
        min: 1
    )
    accountId: String
    /// Symbol of the agent.
    @length(
        min: 3
        max: 14
    )
    @required
    symbol: String
    /// The headquarters of the agent.
    @length(
        min: 1
    )
    @required
    headquarters: String
    /// The number of credits the agent has available. Credits can be negative if funds have been overdrawn.
    @required
    credits: Long
    /// The faction the agent started with.
    @length(
        min: 1
    )
    @required
    startingFaction: String
    /// How many ships are owned by the agent.
    shipCount: Integer
}

/// The chart of a system or waypoint, which makes the location visible to other agents.
structure Chart {
    waypointSymbol: WaypointSymbol
    /// The agent that submitted the chart for this waypoint.
    submittedBy: String
    /// The time the chart for this waypoint was submitted.
    @timestampFormat("date-time")
    submittedOn: Timestamp
}

/// The construction details of a waypoint.
structure Construction {
    /// The symbol of the waypoint.
    @required
    symbol: String
    @required
    materials: Materials
    /// Whether the waypoint has been constructed.
    @required
    isComplete: Boolean
}

/// The details of the required construction materials for a given waypoint under construction.
structure ConstructionMaterial {
    @required
    tradeSymbol: TradeSymbol
    /// The number of units required.
    @required
    required: Integer
    /// The number of units fulfilled toward the required amount.
    @required
    fulfilled: Integer
}

/// Contract details.
structure Contract {
    /// ID of the contract.
    @length(
        min: 1
    )
    @required
    id: String
    /// The symbol of the faction that this contract is for.
    @length(
        min: 1
    )
    @required
    factionSymbol: String
    @required
    type: ContractType
    @required
    terms: ContractTerms
    /// Whether the contract has been accepted by the agent
    @required
    accepted: Boolean
    /// Whether the contract has been fulfilled
    @required
    fulfilled: Boolean
    /// Deprecated in favor of deadlineToAccept
    @required
    @timestampFormat("date-time")
    expiration: Timestamp
    /// The time at which the contract is no longer available to be accepted
    @timestampFormat("date-time")
    deadlineToAccept: Timestamp
}

/// The details of a delivery contract. Includes the type of good, units needed, and the destination.
structure ContractDeliverGood {
    /// The symbol of the trade good to deliver.
    @length(
        min: 1
    )
    @required
    tradeSymbol: String
    /// The destination where goods need to be delivered.
    @length(
        min: 1
    )
    @required
    destinationSymbol: String
    /// The number of units that need to be delivered on this contract.
    @required
    unitsRequired: Integer
    /// The number of units fulfilled on this contract.
    @required
    unitsFulfilled: Integer
}

/// Payments for the contract.
structure ContractPayment {
    /// The amount of credits received up front for accepting the contract.
    @required
    onAccepted: Integer
    /// The amount of credits received when the contract is fulfilled.
    @required
    onFulfilled: Integer
}

/// The terms to fulfill the contract.
structure ContractTerms {
    /// The deadline for the contract.
    @required
    @timestampFormat("date-time")
    deadline: Timestamp
    @required
    payment: ContractPayment
    deliver: Deliver
}

/// A cooldown is a period of time in which a ship cannot perform certain actions.
structure Cooldown {
    /// The symbol of the ship that is on cooldown
    @length(
        min: 1
    )
    @required
    shipSymbol: String
    /// The total duration of the cooldown in seconds
    @range(
        min: 0
    )
    @required
    totalSeconds: Integer
    /// The remaining duration of the cooldown in seconds
    @range(
        min: 0
    )
    @required
    remainingSeconds: Integer
    /// The date and time when the cooldown expires in ISO 8601 format
    @timestampFormat("date-time")
    expiration: Timestamp
}

structure CreateChart201 {
    @httpPayload
    @required
    body: CreateChart201Body
}

structure CreateChart201Body {
    @required
    data: CreateChart201BodyData
}

structure CreateChart201BodyData {
    @required
    chart: Chart
    @required
    waypoint: Waypoint
}

structure CreateChartInput {
    /// The symbol of the ship.
    @httpLabel
    @required
    shipSymbol: String
}

structure CreateShipShipScan201 {
    @httpPayload
    @required
    body: CreateShipShipScan201Body
}

structure CreateShipShipScan201Body {
    @required
    data: CreateShipShipScan201BodyData
}

structure CreateShipShipScan201BodyData {
    @required
    cooldown: Cooldown
    @required
    ships: CreateShipShipScan201BodyDataShips
}

structure CreateShipShipScanInput {
    /// The ship symbol.
    @httpLabel
    @required
    shipSymbol: String
}

structure CreateShipSystemScan201 {
    @httpPayload
    @required
    body: CreateShipSystemScan201Body
}

structure CreateShipSystemScan201Body {
    @required
    data: CreateShipSystemScan201BodyData
}

structure CreateShipSystemScan201BodyData {
    @required
    cooldown: Cooldown
    @required
    systems: Systems
}

structure CreateShipSystemScanInput {
    /// The ship symbol.
    @httpLabel
    @required
    shipSymbol: String
}

structure CreateShipWaypointScan201 {
    @httpPayload
    @required
    body: CreateShipWaypointScan201Body
}

structure CreateShipWaypointScan201Body {
    @required
    data: CreateShipWaypointScan201BodyData
}

structure CreateShipWaypointScan201BodyData {
    @required
    cooldown: Cooldown
    @required
    waypoints: CreateShipWaypointScan201BodyDataWaypoints
}

structure CreateShipWaypointScanInput {
    /// The ship symbol.
    @httpLabel
    @required
    shipSymbol: String
}

structure CreateSurvey201 {
    @httpPayload
    @required
    body: CreateSurvey201Body
}

structure CreateSurvey201Body {
    @required
    data: CreateSurvey201BodyData
}

structure CreateSurvey201BodyData {
    @required
    cooldown: Cooldown
    @required
    surveys: Surveys
}

structure CreateSurveyInput {
    /// The symbol of the ship.
    @httpLabel
    @required
    shipSymbol: String
}

structure Crew {
    @required
    required: Integer
    @required
    capacity: Integer
}

structure DeliverContract200 {
    @httpPayload
    @required
    body: DeliverContract200Body
}

///
structure DeliverContract200Body {
    @required
    data: DeliverContract200BodyData
}

structure DeliverContract200BodyData {
    @required
    contract: Contract
    @required
    cargo: ShipCargo
}

structure DeliverContractInput {
    /// The ID of the contract.
    @httpLabel
    @required
    contractId: String
    ///
    @httpPayload
    body: DeliverContractInputBody
}

structure DeliverContractInputBody {
    /// Symbol of a ship located in the destination to deliver a contract and that has a good to deliver in its cargo.
    @required
    shipSymbol: String
    /// The symbol of the good to deliver.
    @required
    tradeSymbol: String
    /// Amount of units to deliver.
    @required
    units: Integer
}

structure DockShip200 {
    @httpPayload
    @required
    body: DockShip200Body
}

///
structure DockShip200Body {
    @required
    data: DockShip200BodyData
}

structure DockShip200BodyData {
    @required
    nav: ShipNav
}

structure DockShipInput {
    /// The symbol of the ship.
    @httpLabel
    @required
    shipSymbol: String
}

/// The engine of the ship.
structure Engine {
    /// The symbol of the engine.
    @required
    symbol: String
}

/// Extraction details.
structure Extraction {
    /// Symbol of the ship that executed the extraction.
    @length(
        min: 1
    )
    @required
    shipSymbol: String
    @required
    yield: ExtractionYield
}

/// Yields from the extract operation.
structure ExtractionYield {
    @required
    symbol: TradeSymbol
    /// The number of units extracted that were placed into the ship's cargo hold.
    @required
    units: Integer
}

structure ExtractResources201 {
    @httpPayload
    @required
    body: ExtractResources201Body
}

///
structure ExtractResources201Body {
    @required
    data: ExtractResources201BodyData
}

structure ExtractResources201BodyData {
    @required
    cooldown: Cooldown
    @required
    extraction: Extraction
    @required
    cargo: ShipCargo
}

structure ExtractResourcesInput {
    /// The ship symbol.
    @httpLabel
    @required
    shipSymbol: String
    @httpPayload
    body: ExtractResourcesInputBody
}

structure ExtractResourcesInputBody {
    survey: Survey
}

structure ExtractResourcesWithSurvey201 {
    @httpPayload
    @required
    body: ExtractResourcesWithSurvey201Body
}

///
structure ExtractResourcesWithSurvey201Body {
    @required
    data: ExtractResourcesWithSurvey201BodyData
}

structure ExtractResourcesWithSurvey201BodyData {
    @required
    cooldown: Cooldown
    @required
    extraction: Extraction
    @required
    cargo: ShipCargo
}

structure ExtractResourcesWithSurveyInput {
    /// The ship symbol.
    @httpLabel
    @required
    shipSymbol: String
    @httpPayload
    body: Survey
}

/// Faction details.
structure Faction {
    @required
    symbol: FactionSymbol
    /// Name of the faction.
    @length(
        min: 1
    )
    @required
    name: String
    /// Description of the faction.
    @length(
        min: 1
    )
    @required
    description: String
    /// The waypoint in which the faction's HQ is located in.
    @length(
        min: 1
    )
    @required
    headquarters: String
    @required
    traits: FactionTraits
    /// Whether or not the faction is currently recruiting new agents.
    @required
    isRecruiting: Boolean
}

structure FactionTrait {
    @required
    symbol: FactionTraitSymbol
    /// The name of the trait.
    @required
    name: String
    /// A description of the trait.
    @required
    description: String
}

/// The frame of the ship.
structure Frame {
    /// The symbol of the frame.
    @required
    symbol: String
}

structure FulfillContract200 {
    @httpPayload
    @required
    body: FulfillContract200Body
}

///
structure FulfillContract200Body {
    @required
    data: FulfillContract200BodyData
}

structure FulfillContract200BodyData {
    @required
    agent: Agent
    @required
    contract: Contract
}

structure FulfillContractInput {
    /// The ID of the contract to fulfill.
    @httpLabel
    @required
    contractId: String
}

structure GetAgent200 {
    @httpPayload
    @required
    body: GetAgent200Body
}

structure GetAgent200Body {
    @required
    data: Agent
}

structure GetAgentInput {
    /// The agent symbol
    @httpLabel
    @required
    agentSymbol: String
}

structure GetAgents200 {
    @httpPayload
    @required
    body: GetAgents200Body
}

structure GetAgents200Body {
    @required
    data: GetAgents200BodyData
    @required
    meta: Meta
}

structure GetAgentsInput {
    /// What entry offset to request
    @httpQuery("page")
    @range(
        min: 1
    )
    page: Integer
    /// How many entries to return per page
    @httpQuery("limit")
    @range(
        min: 1
        max: 20
    )
    limit: Integer
}

structure GetConstruction200 {
    @httpPayload
    @required
    body: GetConstruction200Body
}

///
structure GetConstruction200Body {
    @required
    data: Construction
}

structure GetConstructionInput {
    /// The system symbol
    @httpLabel
    @required
    systemSymbol: String
    /// The waypoint symbol
    @httpLabel
    @required
    waypointSymbol: String
}

structure GetContract200 {
    @httpPayload
    @required
    body: GetContract200Body
}

structure GetContract200Body {
    @required
    data: Contract
}

structure GetContractInput {
    /// The contract ID
    @httpLabel
    @required
    contractId: String
}

structure GetContracts200 {
    @httpPayload
    @required
    body: GetContracts200Body
}

///
structure GetContracts200Body {
    @required
    data: GetContracts200BodyData
    @required
    meta: Meta
}

structure GetContractsInput {
    /// What entry offset to request
    @httpQuery("page")
    @range(
        min: 1
    )
    page: Integer
    /// How many entries to return per page
    @httpQuery("limit")
    @range(
        min: 1
        max: 20
    )
    limit: Integer
}

structure GetFaction200 {
    @httpPayload
    @required
    body: GetFaction200Body
}

structure GetFaction200Body {
    @required
    data: Faction
}

structure GetFactionInput {
    /// The faction symbol
    @dataExamples([
        {
            json: "COSMIC"
        }
    ])
    @httpLabel
    @required
    factionSymbol: String
}

structure GetFactions200 {
    @httpPayload
    @required
    body: GetFactions200Body
}

structure GetFactions200Body {
    @required
    data: GetFactions200BodyData
    @required
    meta: Meta
}

structure GetFactionsInput {
    /// What entry offset to request
    @httpQuery("page")
    @range(
        min: 1
    )
    page: Integer
    /// How many entries to return per page
    @httpQuery("limit")
    @range(
        min: 1
        max: 20
    )
    limit: Integer
}

structure GetJumpGate200 {
    @httpPayload
    @required
    body: GetJumpGate200Body
}

///
structure GetJumpGate200Body {
    @required
    data: JumpGate
}

structure GetJumpGateInput {
    /// The system symbol
    @httpLabel
    @required
    systemSymbol: String
    /// The waypoint symbol
    @httpLabel
    @required
    waypointSymbol: String
}

structure GetMarket200 {
    @httpPayload
    @required
    body: GetMarket200Body
}

structure GetMarket200Body {
    @required
    data: Market
}

structure GetMarketInput {
    /// The system symbol
    @httpLabel
    @required
    systemSymbol: String
    /// The waypoint symbol
    @httpLabel
    @required
    waypointSymbol: String
}

structure GetMounts200 {
    @httpPayload
    @required
    body: GetMounts200Body
}

///
structure GetMounts200Body {
    @required
    data: GetMounts200BodyData
}

structure GetMountsInput {
    /// The ship's symbol.
    @httpLabel
    @required
    shipSymbol: String
}

structure GetMyAgent200 {
    @httpPayload
    @required
    body: GetMyAgent200Body
}

structure GetMyAgent200Body {
    @required
    data: Agent
}

structure GetMyShip200 {
    @httpPayload
    @required
    body: GetMyShip200Body
}

///
structure GetMyShip200Body {
    @required
    data: Ship
}

structure GetMyShipCargo200 {
    @httpPayload
    @required
    body: GetMyShipCargo200Body
}

///
structure GetMyShipCargo200Body {
    @required
    data: ShipCargo
}

structure GetMyShipCargoInput {
    /// The symbol of the ship.
    @httpLabel
    @required
    shipSymbol: String
}

structure GetMyShipInput {
    /// The symbol of the ship.
    @httpLabel
    @required
    shipSymbol: String
}

structure GetMyShips200 {
    @httpPayload
    @required
    body: GetMyShips200Body
}

///
structure GetMyShips200Body {
    @required
    data: GetMyShips200BodyData
    @required
    meta: Meta
}

structure GetMyShipsInput {
    /// What entry offset to request
    @httpQuery("page")
    @range(
        min: 1
    )
    page: Integer
    /// How many entries to return per page
    @httpQuery("limit")
    @range(
        min: 1
        max: 20
    )
    limit: Integer
}

structure GetShipCooldown200 {
    @httpPayload
    @required
    body: GetShipCooldown200Body
}

///
structure GetShipCooldown200Body {
    @required
    data: Cooldown
}

structure GetShipCooldownInput {
    /// The symbol of the ship.
    @httpLabel
    @required
    shipSymbol: String
}

structure GetShipNav200 {
    @httpPayload
    @required
    body: GetShipNav200Body
}

///
structure GetShipNav200Body {
    @required
    data: ShipNav
}

structure GetShipNavInput {
    /// The ship symbol.
    @httpLabel
    @required
    shipSymbol: String
}

structure GetShipyard200 {
    @httpPayload
    @required
    body: GetShipyard200Body
}

///
structure GetShipyard200Body {
    @required
    data: Shipyard
}

structure GetShipyardInput {
    /// The system symbol
    @httpLabel
    @required
    systemSymbol: String
    /// The waypoint symbol
    @httpLabel
    @required
    waypointSymbol: String
}

structure GetStatus200 {
    @httpPayload
    @required
    body: GetStatus200Body
}

structure GetStatus200Body {
    /// The current status of the game server.
    @required
    status: String
    /// The current version of the API.
    @required
    version: String
    /// The date when the game server was last reset.
    @required
    resetDate: String
    @required
    description: String
    @required
    stats: Stats
    @required
    leaderboards: Leaderboards
    @required
    serverResets: ServerResets
    @required
    announcements: Announcements
    @required
    links: Links
}

structure GetStatus200BodyAnnouncementsItem {
    @required
    title: String
    @required
    body: String
}

structure GetStatus200BodyLeaderboardsMostCreditsItem {
    /// Symbol of the agent.
    @required
    agentSymbol: String
    /// Amount of credits.
    @required
    credits: Long
}

structure GetStatus200BodyLeaderboardsMostSubmittedChartsItem {
    /// Symbol of the agent.
    @required
    agentSymbol: String
    /// Amount of charts done by the agent.
    @required
    chartCount: Integer
}

structure GetStatus200BodyLinksItem {
    @required
    name: String
    @required
    url: String
}

structure GetSystem200 {
    @httpPayload
    @required
    body: GetSystem200Body
}

///
structure GetSystem200Body {
    @required
    data: System
}

structure GetSystemInput {
    /// The system symbol
    @httpLabel
    @required
    systemSymbol: String
}

structure GetSystems200 {
    @httpPayload
    @required
    body: GetSystems200Body
}

///
structure GetSystems200Body {
    @required
    data: GetSystems200BodyData
    @required
    meta: Meta
}

structure GetSystemsInput {
    /// What entry offset to request
    @httpQuery("page")
    @range(
        min: 1
    )
    page: Integer
    /// How many entries to return per page
    @httpQuery("limit")
    @range(
        min: 1
        max: 20
    )
    limit: Integer
}

structure GetSystemWaypoints200 {
    @httpPayload
    @required
    body: GetSystemWaypoints200Body
}

///
structure GetSystemWaypoints200Body {
    @required
    data: GetSystemWaypoints200BodyData
    @required
    meta: Meta
}

structure GetSystemWaypointsInput {
    /// The system symbol
    @httpLabel
    @required
    systemSymbol: String
    /// What entry offset to request
    @httpQuery("page")
    @range(
        min: 1
    )
    page: Integer
    /// How many entries to return per page
    @httpQuery("limit")
    @range(
        min: 1
        max: 20
    )
    limit: Integer
    /// Filter waypoints by type.
    @httpQuery("type")
    type: WaypointType
    /// Filter waypoints by one or more traits.
    @httpQuery("traits")
    traits: GetSystemWaypointsInputTraits
}

structure GetWaypoint200 {
    @httpPayload
    @required
    body: GetWaypoint200Body
}

///
structure GetWaypoint200Body {
    @required
    data: Waypoint
}

structure GetWaypointInput {
    /// The system symbol
    @httpLabel
    @required
    systemSymbol: String
    /// The waypoint symbol
    @httpLabel
    @required
    waypointSymbol: String
}

structure InstallMount201 {
    @httpPayload
    @required
    body: InstallMount201Body
}

structure InstallMount201Body {
    @required
    data: InstallMount201BodyData
}

structure InstallMount201BodyData {
    @required
    agent: Agent
    @required
    mounts: InstallMount201BodyDataMounts
    @required
    cargo: ShipCargo
    @required
    transaction: ShipModificationTransaction
}

structure InstallMountInput {
    /// The ship's symbol.
    @httpLabel
    @required
    shipSymbol: String
    @httpPayload
    body: InstallMountInputBody
}

structure InstallMountInputBody {
    @required
    symbol: String
}

structure Jettison200 {
    @httpPayload
    @required
    body: Jettison200Body
}

///
structure Jettison200Body {
    @required
    data: Jettison200BodyData
}

structure Jettison200BodyData {
    @required
    cargo: ShipCargo
}

structure JettisonInput {
    /// The ship symbol.
    @httpLabel
    @required
    shipSymbol: String
    @httpPayload
    body: JettisonInputBody
}

structure JettisonInputBody {
    @required
    symbol: TradeSymbol
    /// Amount of units to jettison of this good.
    @range(
        min: 1
    )
    @required
    units: Integer
}

///
structure JumpGate {
    @required
    connections: Connections
}

structure JumpShip200 {
    @httpPayload
    @required
    body: JumpShip200Body
}

///
structure JumpShip200Body {
    @required
    data: JumpShip200BodyData
}

structure JumpShip200BodyData {
    @required
    nav: ShipNav
    @required
    cooldown: Cooldown
    @required
    transaction: MarketTransaction
}

structure JumpShipInput {
    /// The ship symbol.
    @httpLabel
    @required
    shipSymbol: String
    @httpPayload
    body: JumpShipInputBody
}

structure JumpShipInputBody {
    /// The symbol of the waypoint to jump to. The destination must be a connected waypoint.
    @required
    waypointSymbol: String
}

structure Leaderboards {
    @required
    mostCredits: MostCredits
    @required
    mostSubmittedCharts: MostSubmittedCharts
}

///
structure Market {
    /// The symbol of the market. The symbol is the same as the waypoint where the market is located.
    @required
    symbol: String
    @required
    exports: Exports
    @required
    imports: Imports
    @required
    exchange: Exchange
    transactions: MarketTransactions
    tradeGoods: TradeGoods
}

structure MarketTradeGood {
    @required
    symbol: TradeSymbol
    @required
    type: MarketTradeGoodType
    /// This is the maximum number of units that can be purchased or sold at this market in a single trade for this good. Trade volume also gives an indication of price volatility. A market with a low trade volume will have large price swings, while high trade volume will be more resilient to price changes.
    @range(
        min: 1
    )
    @required
    tradeVolume: Integer
    @required
    supply: SupplyLevel
    activity: ActivityLevel
    /// The price at which this good can be purchased from the market.
    @range(
        min: 0
    )
    @required
    purchasePrice: Integer
    /// The price at which this good can be sold to the market.
    @range(
        min: 0
    )
    @required
    sellPrice: Integer
}

/// Result of a transaction with a market.
structure MarketTransaction {
    @required
    waypointSymbol: WaypointSymbol
    /// The symbol of the ship that made the transaction.
    @required
    shipSymbol: String
    /// The symbol of the trade good.
    @required
    tradeSymbol: String
    @required
    type: MarketTransactionType
    /// The number of units of the transaction.
    @range(
        min: 0
    )
    @required
    units: Integer
    /// The price per unit of the transaction.
    @range(
        min: 0
    )
    @required
    pricePerUnit: Integer
    /// The total price of the transaction.
    @range(
        min: 0
    )
    @required
    totalPrice: Integer
    /// The timestamp of the transaction.
    @required
    @timestampFormat("date-time")
    timestamp: Timestamp
}

/// Meta details for pagination.
structure Meta {
    /// Shows the total amount of items of this kind that exist.
    @range(
        min: 0
    )
    @required
    total: Integer
    /// A page denotes an amount of items, offset from the first item. Each page holds an amount of items equal to the `limit`.
    @range(
        min: 1
    )
    @required
    page: Integer
    /// The amount of items in each page. Limits how many items can be fetched at once.
    @range(
        min: 1
        max: 20
    )
    @required
    limit: Integer
}

structure NavigateShip200 {
    @httpPayload
    @required
    body: NavigateShip200Body
}

///
structure NavigateShip200Body {
    @required
    data: NavigateShip200BodyData
}

structure NavigateShip200BodyData {
    @required
    fuel: ShipFuel
    @required
    nav: ShipNav
}

structure NavigateShipInput {
    /// The ship symbol.
    @httpLabel
    @required
    shipSymbol: String
    ///
    @httpPayload
    body: NavigateShipInputBody
}

structure NavigateShipInputBody {
    /// The target destination.
    @required
    waypointSymbol: String
}

structure NegotiateContract201 {
    @httpPayload
    @required
    body: NegotiateContract201Body
}

///
structure NegotiateContract201Body {
    @required
    data: NegotiateContract201BodyData
}

structure NegotiateContract201BodyData {
    @required
    contract: Contract
}

structure NegotiateContractInput {
    /// The ship's symbol.
    @httpLabel
    @required
    shipSymbol: String
}

structure OrbitShip200 {
    @httpPayload
    @required
    body: OrbitShip200Body
}

///
structure OrbitShip200Body {
    @required
    data: OrbitShip200BodyData
}

structure OrbitShip200BodyData {
    @required
    nav: ShipNav
}

structure OrbitShipInput {
    /// The symbol of the ship.
    @httpLabel
    @required
    shipSymbol: String
}

structure PatchShipNav200 {
    @httpPayload
    @required
    body: PatchShipNav200Body
}

///
structure PatchShipNav200Body {
    @required
    data: ShipNav
}

structure PatchShipNavInput {
    /// The ship symbol.
    @httpLabel
    @required
    shipSymbol: String
    @httpPayload
    body: PatchShipNavInputBody
}

structure PatchShipNavInputBody {
    flightMode: ShipNavFlightMode
}

structure PurchaseCargo201 {
    @httpPayload
    @required
    body: PurchaseCargo201Body
}

///
structure PurchaseCargo201Body {
    @required
    data: PurchaseCargo201BodyData
}

structure PurchaseCargo201BodyData {
    @required
    agent: Agent
    @required
    cargo: ShipCargo
    @required
    transaction: MarketTransaction
}

structure PurchaseCargoInput {
    /// The ship's symbol.
    @httpLabel
    @required
    shipSymbol: String
    @httpPayload
    body: PurchaseCargoInputBody
}

structure PurchaseCargoInputBody {
    @required
    symbol: TradeSymbol
    /// Amounts of units to purchase.
    @required
    units: Integer
}

structure PurchaseShip201 {
    @httpPayload
    @required
    body: PurchaseShip201Body
}

///
structure PurchaseShip201Body {
    @required
    data: PurchaseShip201BodyData
}

structure PurchaseShip201BodyData {
    @required
    agent: Agent
    @required
    ship: Ship
    @required
    transaction: ShipyardTransaction
}

structure PurchaseShipInput {
    @httpPayload
    body: PurchaseShipInputBody
}

structure PurchaseShipInputBody {
    @required
    shipType: ShipType
    /// The symbol of the waypoint you want to purchase the ship at.
    @required
    waypointSymbol: String
}

/// The reactor of the ship.
structure Reactor {
    /// The symbol of the reactor.
    @required
    symbol: String
}

structure RefuelShip200 {
    @httpPayload
    @required
    body: RefuelShip200Body
}

///
structure RefuelShip200Body {
    @required
    data: RefuelShip200BodyData
}

structure RefuelShip200BodyData {
    @required
    agent: Agent
    @required
    fuel: ShipFuel
    @required
    transaction: MarketTransaction
}

structure RefuelShipInput {
    /// The ship symbol.
    @httpLabel
    @required
    shipSymbol: String
    @httpPayload
    body: RefuelShipInputBody
}

structure RefuelShipInputBody {
    /// The amount of fuel to fill in the ship's tanks. When not specified, the ship will be refueled to its maximum fuel capacity. If the amount specified is greater than the ship's remaining capacity, the ship will only be refueled to its maximum fuel capacity. The amount specified is not in market units but in ship fuel units.
    @dataExamples([
        {
            json: 100
        }
    ])
    @range(
        min: 1
    )
    units: Integer
    /// Wether to use the FUEL thats in your cargo or not. Default: false
    @dataExamples([
        {
            json: false
        }
    ])
    fromCargo: Boolean
}

structure Register201 {
    @httpPayload
    @required
    body: Register201Body
}

structure Register201Body {
    @required
    data: Register201BodyData
}

structure Register201BodyData {
    @required
    agent: Agent
    @required
    contract: Contract
    @required
    faction: Faction
    @required
    ship: Ship
    /// A Bearer token for accessing secured API endpoints.
    @required
    token: String
}

structure RegisterInput {
    ///
    @httpPayload
    body: RegisterInputBody
}

structure RegisterInputBody {
    @required
    faction: FactionSymbol
    /// Your desired agent symbol. This will be a unique name used to represent your agent, and will be the prefix for your ships.
    @dataExamples([
        {
            json: "BADGER"
        }
    ])
    @length(
        min: 3
        max: 14
    )
    @required
    symbol: String
    /// Your email address. This is used if you reserved your call sign between resets.
    email: String
}

structure RemoveMount201 {
    @httpPayload
    @required
    body: RemoveMount201Body
}

structure RemoveMount201Body {
    @required
    data: RemoveMount201BodyData
}

structure RemoveMount201BodyData {
    @required
    agent: Agent
    @required
    mounts: RemoveMount201BodyDataMounts
    @required
    cargo: ShipCargo
    @required
    transaction: ShipModificationTransaction
}

structure RemoveMountInput {
    /// The ship's symbol.
    @httpLabel
    @required
    shipSymbol: String
    @httpPayload
    body: RemoveMountInputBody
}

structure RemoveMountInputBody {
    /// The symbol of the mount to remove.
    @required
    symbol: String
}

/// The ship that was scanned. Details include information about the ship that could be detected by the scanner.
structure ScannedShip {
    /// The globally unique identifier of the ship.
    @required
    symbol: String
    @required
    registration: ShipRegistration
    @required
    nav: ShipNav
    frame: Frame
    reactor: Reactor
    @required
    engine: Engine
    mounts: ScannedShipMounts
}

/// A mount on the ship.
structure ScannedShipMountsItem {
    /// The symbol of the mount.
    @required
    symbol: String
}

/// Details of a system was that scanned.
structure ScannedSystem {
    /// Symbol of the system.
    @length(
        min: 1
    )
    @required
    symbol: String
    /// Symbol of the system's sector.
    @length(
        min: 1
    )
    @required
    sectorSymbol: String
    @required
    type: SystemType
    /// Position in the universe in the x axis.
    @required
    x: Integer
    /// Position in the universe in the y axis.
    @required
    y: Integer
    /// The system's distance from the scanning ship.
    @required
    distance: Integer
}

/// A waypoint that was scanned by a ship.
structure ScannedWaypoint {
    @required
    symbol: WaypointSymbol
    @required
    type: WaypointType
    @required
    systemSymbol: SystemSymbol
    /// Position in the universe in the x axis.
    @required
    x: Integer
    /// Position in the universe in the y axis.
    @required
    y: Integer
    @required
    orbitals: ScannedWaypointOrbitals
    faction: WaypointFaction
    @required
    traits: ScannedWaypointTraits
    chart: Chart
}

structure SellCargo201 {
    @httpPayload
    @required
    body: SellCargo201Body
}

///
structure SellCargo201Body {
    @required
    data: SellCargo201BodyData
}

structure SellCargo201BodyData {
    @required
    agent: Agent
    @required
    cargo: ShipCargo
    @required
    transaction: MarketTransaction
}

structure SellCargoInput {
    /// Symbol of a ship.
    @httpLabel
    @required
    shipSymbol: String
    @httpPayload
    body: SellCargoInputBody
}

structure SellCargoInputBody {
    @required
    symbol: TradeSymbol
    /// Amounts of units to sell of the selected good.
    @required
    units: Integer
}

structure ServerResets {
    /// The date and time when the game server will reset.
    @required
    next: String
    /// How often we intend to reset the game server.
    @required
    frequency: String
}

/// Ship details.
structure Ship {
    /// The globally unique identifier of the ship in the following format: `[AGENT_SYMBOL]-[HEX_ID]`
    @required
    symbol: String
    @required
    registration: ShipRegistration
    @required
    nav: ShipNav
    @required
    crew: ShipCrew
    @required
    frame: ShipFrame
    @required
    reactor: ShipReactor
    @required
    engine: ShipEngine
    @required
    cooldown: Cooldown
    @required
    modules: ShipModules
    @required
    mounts: ShipMounts
    @required
    cargo: ShipCargo
    @required
    fuel: ShipFuel
}

/// Ship cargo details.
structure ShipCargo {
    /// The max number of items that can be stored in the cargo hold.
    @range(
        min: 0
    )
    @required
    capacity: Integer
    /// The number of items currently stored in the cargo hold.
    @range(
        min: 0
    )
    @required
    units: Integer
    @required
    inventory: Inventory
}

/// The type of cargo item and the number of units.
structure ShipCargoItem {
    @required
    symbol: TradeSymbol
    /// The name of the cargo item type.
    @required
    name: String
    /// The description of the cargo item type.
    @required
    description: String
    /// The number of units of the cargo item.
    @range(
        min: 1
    )
    @required
    units: Integer
}

/// The ship's crew service and maintain the ship's systems and equipment.
structure ShipCrew {
    /// The current number of crew members on the ship.
    @required
    current: Integer
    /// The minimum number of crew members required to maintain the ship.
    @required
    required: Integer
    /// The maximum number of crew members the ship can support.
    @required
    capacity: Integer
    @required
    rotation: Rotation
    /// A rough measure of the crew's morale. A higher morale means the crew is happier and more productive. A lower morale means the ship is more prone to accidents.
    @range(
        min: 0
        max: 100
    )
    @required
    morale: Integer
    /// The amount of credits per crew member paid per hour. Wages are paid when a ship docks at a civilized waypoint.
    @range(
        min: 0
    )
    @required
    wages: Integer
}

/// The engine determines how quickly a ship travels between waypoints.
structure ShipEngine {
    @required
    symbol: ShipEngineSymbol
    /// The name of the engine.
    @required
    name: String
    /// The description of the engine.
    @required
    description: String
    condition: ShipCondition
    /// The speed stat of this engine. The higher the speed, the faster a ship can travel from one point to another. Reduces the time of arrival when navigating the ship.
    @range(
        min: 1
    )
    @required
    speed: Integer
    @required
    requirements: ShipRequirements
}

/// The frame of the ship. The frame determines the number of modules and mounting points of the ship, as well as base fuel capacity. As the condition of the frame takes more wear, the ship will become more sluggish and less maneuverable.
structure ShipFrame {
    @required
    symbol: ShipFrameSymbol
    /// Name of the frame.
    @required
    name: String
    /// Description of the frame.
    @required
    description: String
    condition: ShipCondition
    /// The amount of slots that can be dedicated to modules installed in the ship. Each installed module take up a number of slots, and once there are no more slots, no new modules can be installed.
    @range(
        min: 0
    )
    @required
    moduleSlots: Integer
    /// The amount of slots that can be dedicated to mounts installed in the ship. Each installed mount takes up a number of points, and once there are no more points remaining, no new mounts can be installed.
    @range(
        min: 0
    )
    @required
    mountingPoints: Integer
    /// The maximum amount of fuel that can be stored in this ship. When refueling, the ship will be refueled to this amount.
    @range(
        min: 0
    )
    @required
    fuelCapacity: Integer
    @required
    requirements: ShipRequirements
}

/// Details of the ship's fuel tanks including how much fuel was consumed during the last transit or action.
structure ShipFuel {
    /// The current amount of fuel in the ship's tanks.
    @range(
        min: 0
    )
    @required
    current: Integer
    /// The maximum amount of fuel the ship's tanks can hold.
    @range(
        min: 0
    )
    @required
    capacity: Integer
    consumed: ShipFuelConsumed
}

/// An object that only shows up when an action has consumed fuel in the process. Shows the fuel consumption data.
structure ShipFuelConsumed {
    /// The amount of fuel consumed by the most recent transit or action.
    @range(
        min: 0
    )
    @required
    amount: Integer
    /// The time at which the fuel was consumed.
    @required
    @timestampFormat("date-time")
    timestamp: Timestamp
}

/// Result of a transaction for a ship modification, such as installing a mount or a module.
structure ShipModificationTransaction {
    /// The symbol of the waypoint where the transaction took place.
    @required
    waypointSymbol: String
    /// The symbol of the ship that made the transaction.
    @required
    shipSymbol: String
    /// The symbol of the trade good.
    @required
    tradeSymbol: String
    /// The total price of the transaction.
    @range(
        min: 0
    )
    @required
    totalPrice: Integer
    /// The timestamp of the transaction.
    @required
    @timestampFormat("date-time")
    timestamp: Timestamp
}

/// A module can be installed in a ship and provides a set of capabilities such as storage space or quarters for crew. Module installations are permanent.
structure ShipModule {
    @required
    symbol: ShipModuleSymbol
    /// Modules that provide capacity, such as cargo hold or crew quarters will show this value to denote how much of a bonus the module grants.
    @range(
        min: 0
    )
    capacity: Integer
    /// Modules that have a range will such as a sensor array show this value to denote how far can the module reach with its capabilities.
    @range(
        min: 0
    )
    range: Integer
    /// Name of this module.
    @required
    name: String
    /// Description of this module.
    @required
    description: String
    @required
    requirements: ShipRequirements
}

/// A mount is installed on the exterier of a ship.
structure ShipMount {
    @required
    symbol: ShipMountSymbol
    /// Name of this mount.
    @required
    name: String
    /// Description of this mount.
    description: String
    /// Mounts that have this value, such as mining lasers, denote how powerful this mount's capabilities are.
    @range(
        min: 0
    )
    strength: Integer
    deposits: ShipMountDeposits
    @required
    requirements: ShipRequirements
}

/// The navigation information of the ship.
structure ShipNav {
    @required
    systemSymbol: SystemSymbol
    @required
    waypointSymbol: WaypointSymbol
    @required
    route: ShipNavRoute
    @required
    status: ShipNavStatus
    @required
    flightMode: ShipNavFlightMode
}

/// The routing information for the ship's most recent transit or current location.
structure ShipNavRoute {
    @required
    destination: ShipNavRouteWaypoint
    @required
    departure: ShipNavRouteWaypoint
    @required
    origin: ShipNavRouteWaypoint
    /// The date time of the ship's departure.
    @required
    @timestampFormat("date-time")
    departureTime: Timestamp
    /// The date time of the ship's arrival. If the ship is in-transit, this is the expected time of arrival.
    @required
    @timestampFormat("date-time")
    arrival: Timestamp
}

/// The destination or departure of a ships nav route.
structure ShipNavRouteWaypoint {
    /// The symbol of the waypoint.
    @length(
        min: 1
    )
    @required
    symbol: String
    @required
    type: WaypointType
    @required
    systemSymbol: SystemSymbol
    /// Position in the universe in the x axis.
    @required
    x: Integer
    /// Position in the universe in the y axis.
    @required
    y: Integer
}

/// The reactor of the ship. The reactor is responsible for powering the ship's systems and weapons.
structure ShipReactor {
    @required
    symbol: ShipReactorSymbol
    /// Name of the reactor.
    @required
    name: String
    /// Description of the reactor.
    @required
    description: String
    condition: ShipCondition
    /// The amount of power provided by this reactor. The more power a reactor provides to the ship, the lower the cooldown it gets when using a module or mount that taxes the ship's power.
    @range(
        min: 1
    )
    @required
    powerOutput: Integer
    @required
    requirements: ShipRequirements
}

structure ShipRefine201 {
    @httpPayload
    @required
    body: ShipRefine201Body
}

structure ShipRefine201Body {
    @required
    data: ShipRefine201BodyData
}

structure ShipRefine201BodyData {
    @required
    cargo: ShipCargo
    @required
    cooldown: Cooldown
    @required
    produced: Produced
    @required
    consumed: ShipRefine201BodyDataConsumed
}

structure ShipRefine201BodyDataConsumedItem {
    /// Symbol of the good.
    @required
    tradeSymbol: String
    /// Amount of units of the good.
    @required
    units: Integer
}

structure ShipRefine201BodyDataProducedItem {
    /// Symbol of the good.
    @required
    tradeSymbol: String
    /// Amount of units of the good.
    @required
    units: Integer
}

structure ShipRefineInput {
    /// The symbol of the ship.
    @httpLabel
    @required
    shipSymbol: String
    @httpPayload
    body: ShipRefineInputBody
}

structure ShipRefineInputBody {
    @required
    produce: Produce
}

/// The public registration information of the ship
structure ShipRegistration {
    /// The agent's registered name of the ship
    @length(
        min: 1
    )
    @required
    name: String
    /// The symbol of the faction the ship is registered with
    @length(
        min: 1
    )
    @required
    factionSymbol: String
    @required
    role: ShipRole
}

/// The requirements for installation on a ship
structure ShipRequirements {
    /// The amount of power required from the reactor.
    power: Integer
    /// The number of crew required for operation.
    crew: Integer
    /// The number of module slots required for installation.
    slots: Integer
}

///
structure Shipyard {
    /// The symbol of the shipyard. The symbol is the same as the waypoint where the shipyard is located.
    @length(
        min: 1
    )
    @required
    symbol: String
    @required
    shipTypes: ShipTypes
    transactions: ShipyardTransactions
    ships: ShipyardShips
    /// The fee to modify a ship at this shipyard. This includes installing or removing modules and mounts on a ship. In the case of mounts, the fee is a flat rate per mount. In the case of modules, the fee is per slot the module occupies.
    @required
    modificationsFee: Integer
}

///
structure ShipyardShip {
    @required
    type: ShipType
    @required
    name: String
    @required
    description: String
    @required
    supply: SupplyLevel
    activity: ActivityLevel
    @required
    purchasePrice: Integer
    @required
    frame: ShipFrame
    @required
    reactor: ShipReactor
    @required
    engine: ShipEngine
    @required
    modules: ShipyardShipModules
    @required
    mounts: ShipyardShipMounts
    @required
    crew: Crew
}

structure ShipyardShipTypesItem {
    @required
    type: ShipType
}

/// Results of a transaction with a shipyard.
structure ShipyardTransaction {
    @required
    waypointSymbol: WaypointSymbol
    /// The symbol of the ship that was the subject of the transaction.
    @required
    shipSymbol: String
    /// The price of the transaction.
    @range(
        min: 0
    )
    @required
    price: Integer
    /// The symbol of the agent that made the transaction.
    @required
    agentSymbol: String
    /// The timestamp of the transaction.
    @required
    @timestampFormat("date-time")
    timestamp: Timestamp
}

/// Siphon details.
structure Siphon {
    /// Symbol of the ship that executed the siphon.
    @length(
        min: 1
    )
    @required
    shipSymbol: String
    @required
    yield: SiphonYield
}

structure SiphonResources201 {
    @httpPayload
    @required
    body: SiphonResources201Body
}

///
structure SiphonResources201Body {
    @required
    data: SiphonResources201BodyData
}

structure SiphonResources201BodyData {
    @required
    cooldown: Cooldown
    @required
    siphon: Siphon
    @required
    cargo: ShipCargo
}

structure SiphonResourcesInput {
    /// The ship symbol.
    @httpLabel
    @required
    shipSymbol: String
}

/// Yields from the siphon operation.
structure SiphonYield {
    @required
    symbol: TradeSymbol
    /// The number of units siphoned that were placed into the ship's cargo hold.
    @required
    units: Integer
}

structure Stats {
    /// Number of registered agents in the game.
    @required
    agents: Integer
    /// Total number of ships in the game.
    @required
    ships: Integer
    /// Total number of systems in the game.
    @required
    systems: Integer
    /// Total number of waypoints in the game.
    @required
    waypoints: Integer
}

structure SupplyConstruction201 {
    @httpPayload
    @required
    body: SupplyConstruction201Body
}

///
structure SupplyConstruction201Body {
    @required
    data: SupplyConstruction201BodyData
}

structure SupplyConstruction201BodyData {
    @required
    construction: Construction
    @required
    cargo: ShipCargo
}

structure SupplyConstructionInput {
    /// The system symbol
    @httpLabel
    @required
    systemSymbol: String
    /// The waypoint symbol
    @httpLabel
    @required
    waypointSymbol: String
    ///
    @httpPayload
    body: SupplyConstructionInputBody
}

structure SupplyConstructionInputBody {
    /// Symbol of the ship to use.
    @required
    shipSymbol: String
    /// The symbol of the good to supply.
    @required
    tradeSymbol: String
    /// Amount of units to supply.
    @required
    units: Integer
}

/// A resource survey of a waypoint, detailing a specific extraction location and the types of resources that can be found there.
structure Survey {
    /// A unique signature for the location of this survey. This signature is verified when attempting an extraction using this survey.
    @length(
        min: 1
    )
    @required
    signature: String
    /// The symbol of the waypoint that this survey is for.
    @length(
        min: 1
    )
    @required
    symbol: String
    @required
    deposits: SurveyDeposits
    /// The date and time when the survey expires. After this date and time, the survey will no longer be available for extraction.
    @required
    @timestampFormat("date-time")
    expiration: Timestamp
    @required
    size: Size
}

/// A surveyed deposit of a mineral or resource available for extraction.
structure SurveyDeposit {
    /// The symbol of the deposit.
    @required
    symbol: String
}

structure System {
    /// The symbol of the system.
    @length(
        min: 1
    )
    @required
    symbol: String
    /// The symbol of the sector.
    @length(
        min: 1
    )
    @required
    sectorSymbol: String
    @required
    type: SystemType
    /// Relative position of the system in the sector in the x axis.
    @required
    x: Integer
    /// Relative position of the system in the sector in the y axis.
    @required
    y: Integer
    @required
    waypoints: SystemWaypoints
    @required
    factions: Factions
}

structure SystemFaction {
    @required
    symbol: FactionSymbol
}

structure SystemWaypoint {
    @required
    symbol: WaypointSymbol
    @required
    type: WaypointType
    /// Relative position of the waypoint on the system's x axis. This is not an absolute position in the universe.
    @required
    x: Integer
    /// Relative position of the waypoint on the system's y axis. This is not an absolute position in the universe.
    @required
    y: Integer
    @required
    orbitals: SystemWaypointOrbitals
    /// The symbol of the parent waypoint, if this waypoint is in orbit around another waypoint. Otherwise this value is undefined.
    @length(
        min: 1
    )
    orbits: String
}

/// A good that can be traded for other goods or currency.
structure TradeGood {
    @required
    symbol: TradeSymbol
    /// The name of the good.
    @required
    name: String
    /// The description of the good.
    @required
    description: String
}

structure TransferCargo200 {
    @httpPayload
    @required
    body: TransferCargo200Body
}

structure TransferCargo200Body {
    @required
    data: TransferCargo200BodyData
}

structure TransferCargo200BodyData {
    @required
    cargo: ShipCargo
}

structure TransferCargoInput {
    /// The transferring ship's symbol.
    @httpLabel
    @required
    shipSymbol: String
    @httpPayload
    body: TransferCargoInputBody
}

structure TransferCargoInputBody {
    @required
    tradeSymbol: TradeSymbol
    /// Amount of units to transfer.
    @required
    units: Integer
    /// The symbol of the ship to transfer to.
    @required
    shipSymbol: String
}

structure WarpShip200 {
    @httpPayload
    @required
    body: WarpShip200Body
}

///
structure WarpShip200Body {
    @required
    data: WarpShip200BodyData
}

structure WarpShip200BodyData {
    @required
    fuel: ShipFuel
    @required
    nav: ShipNav
}

structure WarpShipInput {
    /// The ship symbol.
    @httpLabel
    @required
    shipSymbol: String
    ///
    @httpPayload
    body: WarpShipInputBody
}

structure WarpShipInputBody {
    /// The target destination.
    @required
    waypointSymbol: String
}

/// A waypoint is a location that ships can travel to such as a Planet, Moon or Space Station.
structure Waypoint {
    @required
    symbol: WaypointSymbol
    @required
    type: WaypointType
    @required
    systemSymbol: SystemSymbol
    /// Relative position of the waypoint on the system's x axis. This is not an absolute position in the universe.
    @required
    x: Integer
    /// Relative position of the waypoint on the system's y axis. This is not an absolute position in the universe.
    @required
    y: Integer
    @required
    orbitals: WaypointOrbitals
    /// The symbol of the parent waypoint, if this waypoint is in orbit around another waypoint. Otherwise this value is undefined.
    @length(
        min: 1
    )
    orbits: String
    faction: WaypointFaction
    @required
    traits: WaypointTraits
    modifiers: Modifiers
    chart: Chart
    /// True if the waypoint is under construction.
    @required
    isUnderConstruction: Boolean
}

/// The faction that controls the waypoint.
structure WaypointFaction {
    @required
    symbol: FactionSymbol
}

structure WaypointModifier {
    @required
    symbol: WaypointModifierSymbol
    /// The name of the trait.
    @required
    name: String
    /// A description of the trait.
    @required
    description: String
}

/// An orbital is another waypoint that orbits a parent waypoint.
structure WaypointOrbital {
    /// The symbol of the orbiting waypoint.
    @length(
        min: 1
    )
    @required
    symbol: String
}

structure WaypointTrait {
    @required
    symbol: WaypointTraitSymbol
    /// The name of the trait.
    @required
    name: String
    /// A description of the trait.
    @required
    description: String
}

list Announcements {
    member: GetStatus200BodyAnnouncementsItem
}

/// All the gates that are connected to this waypoint.
list Connections {
    member: String
}

/// List of scanned ships.
list CreateShipShipScan201BodyDataShips {
    member: ScannedShip
}

/// List of scanned waypoints.
list CreateShipWaypointScan201BodyDataWaypoints {
    member: ScannedWaypoint
}

/// The cargo that needs to be delivered to fulfill the contract.
list Deliver {
    member: ContractDeliverGood
}

/// The list of goods that are bought and sold between agents at this market.
list Exchange {
    member: TradeGood
}

/// The list of goods that are exported from this market.
list Exports {
    member: TradeGood
}

/// Factions that control this system.
list Factions {
    member: SystemFaction
}

/// List of traits that define this faction.
list FactionTraits {
    member: FactionTrait
}

list GetAgents200BodyData {
    member: Agent
}

list GetContracts200BodyData {
    member: Contract
}

list GetFactions200BodyData {
    member: Faction
}

list GetMounts200BodyData {
    member: ShipMount
}

list GetMyShips200BodyData {
    member: Ship
}

list GetSystems200BodyData {
    member: System
}

list GetSystemWaypoints200BodyData {
    member: Waypoint
}

list GetSystemWaypointsInputTraits {
    member: WaypointTraitSymbol
}

/// The list of goods that are sought as imports in this market.
list Imports {
    member: TradeGood
}

/// List of installed mounts after the installation of the new mount.
list InstallMount201BodyDataMounts {
    member: ShipMount
}

/// The items currently in the cargo hold.
list Inventory {
    member: ShipCargoItem
}

list Links {
    member: GetStatus200BodyLinksItem
}

/// The list of recent transactions at this market. Visible only when a ship is present at the market.
list MarketTransactions {
    member: MarketTransaction
}

/// The materials required to construct the waypoint.
list Materials {
    member: ConstructionMaterial
}

/// The modifiers of the waypoint.
list Modifiers {
    member: WaypointModifier
}

/// Top agents with the most credits.
list MostCredits {
    member: GetStatus200BodyLeaderboardsMostCreditsItem
}

/// Top agents with the most charted submitted.
list MostSubmittedCharts {
    member: GetStatus200BodyLeaderboardsMostSubmittedChartsItem
}

/// Goods that were produced by this refining process.
list Produced {
    member: ShipRefine201BodyDataProducedItem
}

/// List of installed mounts after the removal of the selected mount.
list RemoveMount201BodyDataMounts {
    member: ShipMount
}

/// List of mounts installed in the ship.
list ScannedShipMounts {
    member: ScannedShipMountsItem
}

/// List of waypoints that orbit this waypoint.
list ScannedWaypointOrbitals {
    member: WaypointOrbital
}

/// The traits of the waypoint.
list ScannedWaypointTraits {
    member: WaypointTrait
}

/// Modules installed in this ship.
list ShipModules {
    member: ShipModule
}

/// Mounts that have this value denote what goods can be produced from using the mount.
list ShipMountDeposits {
    member: ShipMountDepositsItem
}

/// Mounts installed in this ship.
list ShipMounts {
    member: ShipMount
}

/// Goods that were consumed during this refining process.
list ShipRefine201BodyDataConsumed {
    member: ShipRefine201BodyDataConsumedItem
}

/// The list of ship types available for purchase at this shipyard.
list ShipTypes {
    member: ShipyardShipTypesItem
}

list ShipyardShipModules {
    member: ShipModule
}

list ShipyardShipMounts {
    member: ShipMount
}

/// The ships that are currently available for purchase at the shipyard.
list ShipyardShips {
    member: ShipyardShip
}

/// The list of recent transactions at this shipyard.
list ShipyardTransactions {
    member: ShipyardTransaction
}

/// A list of deposits that can be found at this location. A ship will extract one of these deposits when using this survey in an extraction request. If multiple deposits of the same type are present, the chance of extracting that deposit is increased.
list SurveyDeposits {
    member: SurveyDeposit
}

/// Surveys created by this action.
list Surveys {
    member: Survey
}

/// List of scanned systems.
list Systems {
    member: ScannedSystem
}

/// Waypoints that orbit this waypoint.
list SystemWaypointOrbitals {
    member: WaypointOrbital
}

/// Waypoints in this system.
list SystemWaypoints {
    member: SystemWaypoint
}

/// The list of goods that are traded at this market. Visible only when a ship is present at the market.
list TradeGoods {
    member: MarketTradeGood
}

/// Waypoints that orbit this waypoint.
list WaypointOrbitals {
    member: WaypointOrbital
}

/// The traits of the waypoint.
list WaypointTraits {
    member: WaypointTrait
}

/// The activity level of a trade good. If the good is an import, this represents how strong consumption is. If the good is an export, this represents how strong the production is for the good. When activity is strong, consumption or production is near maximum capacity. When activity is weak, consumption or production is near minimum capacity.
enum ActivityLevel {
    WEAK
    GROWING
    STRONG
    RESTRICTED
}

/// Type of contract.
enum ContractType {
    PROCUREMENT
    TRANSPORT
    SHUTTLE
}

/// The symbol of the faction.
enum FactionSymbol {
    COSMIC
    VOID
    GALACTIC
    QUANTUM
    DOMINION
    ASTRO
    CORSAIRS
    OBSIDIAN
    AEGIS
    UNITED
    SOLITARY
    COBALT
    OMEGA
    ECHO
    LORDS
    CULT
    ANCIENTS
    SHADOW
    ETHEREAL
}

/// The unique identifier of the trait.
enum FactionTraitSymbol {
    BUREAUCRATIC
    SECRETIVE
    CAPITALISTIC
    INDUSTRIOUS
    PEACEFUL
    DISTRUSTFUL
    WELCOMING
    SMUGGLERS
    SCAVENGERS
    REBELLIOUS
    EXILES
    PIRATES
    RAIDERS
    CLAN
    GUILD
    DOMINION
    FRINGE
    FORSAKEN
    ISOLATED
    LOCALIZED
    ESTABLISHED
    NOTABLE
    DOMINANT
    INESCAPABLE
    INNOVATIVE
    BOLD
    VISIONARY
    CURIOUS
    DARING
    EXPLORATORY
    RESOURCEFUL
    FLEXIBLE
    COOPERATIVE
    UNITED
    STRATEGIC
    INTELLIGENT
    RESEARCH_FOCUSED
    COLLABORATIVE
    PROGRESSIVE
    MILITARISTIC
    TECHNOLOGICALLY_ADVANCED
    AGGRESSIVE
    IMPERIALISTIC
    TREASURE_HUNTERS
    DEXTEROUS
    UNPREDICTABLE
    BRUTAL
    FLEETING
    ADAPTABLE
    SELF_SUFFICIENT
    DEFENSIVE
    PROUD
    DIVERSE
    INDEPENDENT
    SELF_INTERESTED
    FRAGMENTED
    COMMERCIAL
    FREE_MARKETS
    ENTREPRENEURIAL
}

/// The type of trade good (export, import, or exchange).
enum MarketTradeGoodType {
    EXPORT
    IMPORT
    EXCHANGE
}

/// The type of transaction.
enum MarketTransactionType {
    PURCHASE
    SELL
}

/// The type of good to produce out of the refining process.
enum Produce {
    IRON
    COPPER
    SILVER
    GOLD
    ALUMINUM
    PLATINUM
    URANITE
    MERITIUM
    FUEL
}

/// The rotation of crew shifts. A stricter shift improves the ship's performance. A more relaxed shift improves the crew's morale.
enum Rotation {
    STRICT
    RELAXED
}

/// Condition is a range of 0 to 100 where 0 is completely worn out and 100 is brand new.
@range(
    min: 0
    max: 100
)
integer ShipCondition

/// The symbol of the engine.
enum ShipEngineSymbol {
    ENGINE_IMPULSE_DRIVE_I
    ENGINE_ION_DRIVE_I
    ENGINE_ION_DRIVE_II
    ENGINE_HYPER_DRIVE_I
}

/// Symbol of the frame.
enum ShipFrameSymbol {
    FRAME_PROBE
    FRAME_DRONE
    FRAME_INTERCEPTOR
    FRAME_RACER
    FRAME_FIGHTER
    FRAME_FRIGATE
    FRAME_SHUTTLE
    FRAME_EXPLORER
    FRAME_MINER
    FRAME_LIGHT_FREIGHTER
    FRAME_HEAVY_FREIGHTER
    FRAME_TRANSPORT
    FRAME_DESTROYER
    FRAME_CRUISER
    FRAME_CARRIER
}

/// The symbol of the module.
enum ShipModuleSymbol {
    MODULE_MINERAL_PROCESSOR_I
    MODULE_GAS_PROCESSOR_I
    MODULE_CARGO_HOLD_I
    MODULE_CARGO_HOLD_II
    MODULE_CARGO_HOLD_III
    MODULE_CREW_QUARTERS_I
    MODULE_ENVOY_QUARTERS_I
    MODULE_PASSENGER_CABIN_I
    MODULE_MICRO_REFINERY_I
    MODULE_ORE_REFINERY_I
    MODULE_FUEL_REFINERY_I
    MODULE_SCIENCE_LAB_I
    MODULE_JUMP_DRIVE_I
    MODULE_JUMP_DRIVE_II
    MODULE_JUMP_DRIVE_III
    MODULE_WARP_DRIVE_I
    MODULE_WARP_DRIVE_II
    MODULE_WARP_DRIVE_III
    MODULE_SHIELD_GENERATOR_I
    MODULE_SHIELD_GENERATOR_II
}

enum ShipMountDepositsItem {
    QUARTZ_SAND
    SILICON_CRYSTALS
    PRECIOUS_STONES
    ICE_WATER
    AMMONIA_ICE
    IRON_ORE
    COPPER_ORE
    SILVER_ORE
    ALUMINUM_ORE
    GOLD_ORE
    PLATINUM_ORE
    DIAMONDS
    URANITE_ORE
    MERITIUM_ORE
}

/// Symbo of this mount.
enum ShipMountSymbol {
    MOUNT_GAS_SIPHON_I
    MOUNT_GAS_SIPHON_II
    MOUNT_GAS_SIPHON_III
    MOUNT_SURVEYOR_I
    MOUNT_SURVEYOR_II
    MOUNT_SURVEYOR_III
    MOUNT_SENSOR_ARRAY_I
    MOUNT_SENSOR_ARRAY_II
    MOUNT_SENSOR_ARRAY_III
    MOUNT_MINING_LASER_I
    MOUNT_MINING_LASER_II
    MOUNT_MINING_LASER_III
    MOUNT_LASER_CANNON_I
    MOUNT_MISSILE_LAUNCHER_I
    MOUNT_TURRET_I
}

/// The ship's set speed when traveling between waypoints or systems.
enum ShipNavFlightMode {
    DRIFT
    STEALTH
    CRUISE
    BURN
}

/// The current status of the ship
enum ShipNavStatus {
    IN_TRANSIT
    IN_ORBIT
    DOCKED
}

/// Symbol of the reactor.
enum ShipReactorSymbol {
    REACTOR_SOLAR_I
    REACTOR_FUSION_I
    REACTOR_FISSION_I
    REACTOR_CHEMICAL_I
    REACTOR_ANTIMATTER_I
}

/// The registered role of the ship
enum ShipRole {
    FABRICATOR
    HARVESTER
    HAULER
    INTERCEPTOR
    EXCAVATOR
    TRANSPORT
    REPAIR
    SURVEYOR
    COMMAND
    CARRIER
    PATROL
    SATELLITE
    EXPLORER
    REFINERY
}

/// Type of ship
enum ShipType {
    SHIP_PROBE
    SHIP_MINING_DRONE
    SHIP_SIPHON_DRONE
    SHIP_INTERCEPTOR
    SHIP_LIGHT_HAULER
    SHIP_COMMAND_FRIGATE
    SHIP_EXPLORER
    SHIP_HEAVY_FREIGHTER
    SHIP_LIGHT_SHUTTLE
    SHIP_ORE_HOUND
    SHIP_REFINING_FREIGHTER
    SHIP_SURVEYOR
}

/// The size of the deposit. This value indicates how much can be extracted from the survey before it is exhausted.
enum Size {
    SMALL
    MODERATE
    LARGE
}

/// The supply level of a trade good.
enum SupplyLevel {
    SCARCE
    LIMITED
    MODERATE
    HIGH
    ABUNDANT
}

/// The system symbol of the ship's current location.
@length(
    min: 1
)
string SystemSymbol

/// The type of system.
enum SystemType {
    NEUTRON_STAR
    RED_STAR
    ORANGE_STAR
    BLUE_STAR
    YOUNG_STAR
    WHITE_DWARF
    BLACK_HOLE
    HYPERGIANT
    NEBULA
    UNSTABLE
}

/// The good's symbol.
enum TradeSymbol {
    PRECIOUS_STONES
    QUARTZ_SAND
    SILICON_CRYSTALS
    AMMONIA_ICE
    LIQUID_HYDROGEN
    LIQUID_NITROGEN
    ICE_WATER
    EXOTIC_MATTER
    ADVANCED_CIRCUITRY
    GRAVITON_EMITTERS
    IRON
    IRON_ORE
    COPPER
    COPPER_ORE
    ALUMINUM
    ALUMINUM_ORE
    SILVER
    SILVER_ORE
    GOLD
    GOLD_ORE
    PLATINUM
    PLATINUM_ORE
    DIAMONDS
    URANITE
    URANITE_ORE
    MERITIUM
    MERITIUM_ORE
    HYDROCARBON
    ANTIMATTER
    FAB_MATS
    FERTILIZERS
    FABRICS
    FOOD
    JEWELRY
    MACHINERY
    FIREARMS
    ASSAULT_RIFLES
    MILITARY_EQUIPMENT
    EXPLOSIVES
    LAB_INSTRUMENTS
    AMMUNITION
    ELECTRONICS
    SHIP_PLATING
    SHIP_PARTS
    EQUIPMENT
    FUEL
    MEDICINE
    DRUGS
    CLOTHING
    MICROPROCESSORS
    PLASTICS
    POLYNUCLEOTIDES
    BIOCOMPOSITES
    QUANTUM_STABILIZERS
    NANOBOTS
    AI_MAINFRAMES
    QUANTUM_DRIVES
    ROBOTIC_DRONES
    CYBER_IMPLANTS
    GENE_THERAPEUTICS
    NEURAL_CHIPS
    MOOD_REGULATORS
    VIRAL_AGENTS
    MICRO_FUSION_GENERATORS
    SUPERGRAINS
    LASER_RIFLES
    HOLOGRAPHICS
    SHIP_SALVAGE
    RELIC_TECH
    NOVEL_LIFEFORMS
    BOTANICAL_SPECIMENS
    CULTURAL_ARTIFACTS
    FRAME_PROBE
    FRAME_DRONE
    FRAME_INTERCEPTOR
    FRAME_RACER
    FRAME_FIGHTER
    FRAME_FRIGATE
    FRAME_SHUTTLE
    FRAME_EXPLORER
    FRAME_MINER
    FRAME_LIGHT_FREIGHTER
    FRAME_HEAVY_FREIGHTER
    FRAME_TRANSPORT
    FRAME_DESTROYER
    FRAME_CRUISER
    FRAME_CARRIER
    REACTOR_SOLAR_I
    REACTOR_FUSION_I
    REACTOR_FISSION_I
    REACTOR_CHEMICAL_I
    REACTOR_ANTIMATTER_I
    ENGINE_IMPULSE_DRIVE_I
    ENGINE_ION_DRIVE_I
    ENGINE_ION_DRIVE_II
    ENGINE_HYPER_DRIVE_I
    MODULE_MINERAL_PROCESSOR_I
    MODULE_GAS_PROCESSOR_I
    MODULE_CARGO_HOLD_I
    MODULE_CARGO_HOLD_II
    MODULE_CARGO_HOLD_III
    MODULE_CREW_QUARTERS_I
    MODULE_ENVOY_QUARTERS_I
    MODULE_PASSENGER_CABIN_I
    MODULE_MICRO_REFINERY_I
    MODULE_SCIENCE_LAB_I
    MODULE_JUMP_DRIVE_I
    MODULE_JUMP_DRIVE_II
    MODULE_JUMP_DRIVE_III
    MODULE_WARP_DRIVE_I
    MODULE_WARP_DRIVE_II
    MODULE_WARP_DRIVE_III
    MODULE_SHIELD_GENERATOR_I
    MODULE_SHIELD_GENERATOR_II
    MODULE_ORE_REFINERY_I
    MODULE_FUEL_REFINERY_I
    MOUNT_GAS_SIPHON_I
    MOUNT_GAS_SIPHON_II
    MOUNT_GAS_SIPHON_III
    MOUNT_SURVEYOR_I
    MOUNT_SURVEYOR_II
    MOUNT_SURVEYOR_III
    MOUNT_SENSOR_ARRAY_I
    MOUNT_SENSOR_ARRAY_II
    MOUNT_SENSOR_ARRAY_III
    MOUNT_MINING_LASER_I
    MOUNT_MINING_LASER_II
    MOUNT_MINING_LASER_III
    MOUNT_LASER_CANNON_I
    MOUNT_MISSILE_LAUNCHER_I
    MOUNT_TURRET_I
    SHIP_PROBE
    SHIP_MINING_DRONE
    SHIP_SIPHON_DRONE
    SHIP_INTERCEPTOR
    SHIP_LIGHT_HAULER
    SHIP_COMMAND_FRIGATE
    SHIP_EXPLORER
    SHIP_HEAVY_FREIGHTER
    SHIP_LIGHT_SHUTTLE
    SHIP_ORE_HOUND
    SHIP_REFINING_FREIGHTER
    SHIP_SURVEYOR
}

/// The unique identifier of the modifier.
enum WaypointModifierSymbol {
    STRIPPED
    UNSTABLE
    RADIATION_LEAK
    CRITICAL_LIMIT
    CIVIL_UNREST
}

/// The waypoint symbol of the ship's current location, or if the ship is in-transit, the waypoint symbol of the ship's destination.
@length(
    min: 1
)
string WaypointSymbol

/// The unique identifier of the trait.
enum WaypointTraitSymbol {
    UNCHARTED
    UNDER_CONSTRUCTION
    MARKETPLACE
    SHIPYARD
    OUTPOST
    SCATTERED_SETTLEMENTS
    SPRAWLING_CITIES
    MEGA_STRUCTURES
    PIRATE_BASE
    OVERCROWDED
    HIGH_TECH
    CORRUPT
    BUREAUCRATIC
    TRADING_HUB
    INDUSTRIAL
    BLACK_MARKET
    RESEARCH_FACILITY
    MILITARY_BASE
    SURVEILLANCE_OUTPOST
    EXPLORATION_OUTPOST
    MINERAL_DEPOSITS
    COMMON_METAL_DEPOSITS
    PRECIOUS_METAL_DEPOSITS
    RARE_METAL_DEPOSITS
    METHANE_POOLS
    ICE_CRYSTALS
    EXPLOSIVE_GASES
    STRONG_MAGNETOSPHERE
    VIBRANT_AURORAS
    SALT_FLATS
    CANYONS
    PERPETUAL_DAYLIGHT
    PERPETUAL_OVERCAST
    DRY_SEABEDS
    MAGMA_SEAS
    SUPERVOLCANOES
    ASH_CLOUDS
    VAST_RUINS
    MUTATED_FLORA
    TERRAFORMED
    EXTREME_TEMPERATURES
    EXTREME_PRESSURE
    DIVERSE_LIFE
    SCARCE_LIFE
    FOSSILS
    WEAK_GRAVITY
    STRONG_GRAVITY
    CRUSHING_GRAVITY
    TOXIC_ATMOSPHERE
    CORROSIVE_ATMOSPHERE
    BREATHABLE_ATMOSPHERE
    THIN_ATMOSPHERE
    JOVIAN
    ROCKY
    VOLCANIC
    FROZEN
    SWAMP
    BARREN
    TEMPERATE
    JUNGLE
    OCEAN
    RADIOACTIVE
    MICRO_GRAVITY_ANOMALIES
    DEBRIS_CLUSTER
    DEEP_CRATERS
    SHALLOW_CRATERS
    UNSTABLE_COMPOSITION
    HOLLOWED_INTERIOR
    STRIPPED
}

/// The type of waypoint.
enum WaypointType {
    PLANET
    GAS_GIANT
    MOON
    ORBITAL_STATION
    JUMP_GATE
    ASTEROID_FIELD
    ASTEROID
    ENGINEERED_ASTEROID
    ASTEROID_BASE
    NEBULA
    DEBRIS_FIELD
    GRAVITY_WELL
    ARTIFICIAL_GRAVITY_WELL
    FUEL_STATION
}
