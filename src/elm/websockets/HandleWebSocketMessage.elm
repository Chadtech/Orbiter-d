module HandleWebSocketMessage exposing (handleWebSocketMessage)

import Json.Decode.Extra exposing (..)
import Json.Decode exposing (..)
import Game exposing (..)
import Types exposing (..)
import SpaceObject exposing (..)
import Engine exposing (..)
import List
import Dict exposing (insert)
import Util exposing (modulo, getSector)


type alias SpaceObjectPayload =
  { uuid : UUID
  , owner : UUID
  , name : Name
  , type' : String
  , global : Coordinate
  , velocity: Coordinate
  , angle : Float
  , anglevelocity : Float
  , boost : Bool
  , mass : Float
  , air : Float
  , fuel : Float
  , thrusters : List ThrusterPayload
  }

type alias ThrusterPayload =
  { firing : Int
  , type' : String
  }

type alias ChatMessagePayload =
  { name : String
  , message : String
  , ownerid : String
  }

handleWebSocketMessage : String -> Model -> Model
handleWebSocketMessage json model =
  let
    messageType =
      case decodeString getMessageType json of
        Ok value -> (value, json)
        Err value -> (value, json)
  in
    case messageType of
      ("SpaceObject", _) ->
        handleObjectUpdate json model 
      ("SpaceChat", _) ->
        case decodeChatMessage json of
          Ok payload ->
            let
              newMessage =
                let {name, message} = payload in
                { content = message
                , speaker = name
                }
            in
            { model 
            | chatMessages = 
                newMessage :: model.chatMessages
            }
          Err _ ->
            let
              ya = Debug.log "json is" json
            in
            model
      _ -> 
        model

getMessageType : Decoder String
getMessageType =
  object1 identity ("messagetype" := string)

handleObjectUpdate : String -> Model -> Model
handleObjectUpdate json model =
  case decodeSpaceObject json of
    Ok payload ->
      let object = spaceObject payload in
      { model
      | remoteObjects = 
          insert
            object.uuid
            object
            model.remoteObjects
      }
    Err _ ->
      model

spaceObject : SpaceObjectPayload -> SpaceObject
spaceObject payload =
  let
    local =
      let (gx, gy) = payload.global in
      (modulo gx, modulo gy)

    direction =
      let (vx, vy) = payload.velocity in
      atan2 vx vy

    sector =
      let (gx, gy) = payload.global in
      (getSector gx, getSector gy)
  in
  { angle = (payload.angle, payload.anglevelocity)
  , local = local
  , global = payload.global
  , velocity = payload.velocity
  , direction = direction
  , dimensions =
      case payload.type' of
        "Ship" -> (34, 29)
        _ -> (20, 20)
  , sector = sector
  , fuel = payload.fuel
  , air = payload.air
  , mass = payload.mass
  , missiles = 0
  , type' =
      case payload.type' of
        "Ship" -> Ship
        _ -> AirTank
  , name = "THOMAS"
  , uuid = payload.uuid
  , owner = payload.owner
  , engine = 
    { boost = payload.boost
    , thrusters = 
        List.map thruster payload.thrusters
    }
  , sprite =
      case payload.type' of
        "Ship" ->
        { src        = "ship/ship-1"
        , dimensions = (47, 47)
        , area       = (138, 138)
        , position   = (0,0)
        }
        _ ->
        { src        = "stuff/oxygen-tank"
        , dimensions = (20, 20)
        , area       = (20, 20)
        , position   = (0,0)
        }
  , remove = False
  , explode = False
  }

thruster : ThrusterPayload -> Thruster
thruster payload =
  { firing = payload.firing 
  , type' =
      case payload.type' of
        "main" -> Main
        "frontleft" -> FrontLeft
        "frontright" -> FrontRight
        "sideleft" -> SideLeft
        "sideright" -> SideRight
        "backleft" -> BackLeft
        "backright" -> BackRight
        _ -> Main
  }

payload : Decoder a -> String -> Result String a
payload = (:=) "o" >> object1 identity >> decodeString

decodeSpaceObject : String -> Result String SpaceObjectPayload
decodeSpaceObject =
  decodeString (object1 identity ("o" := spaceObjectDecoder))


decodeChatMessage : String -> Result String ChatMessagePayload
decodeChatMessage =
  decodeString (object1 identity ("o" := chatMessageDecoder))

spaceObjectDecoder : Decoder SpaceObjectPayload
spaceObjectDecoder =
  succeed SpaceObjectPayload
  |: ("uuid" := string)
  |: ("owner" := string)
  |: ("name" := string)
  |: ("type" := string)
  |: ("global" := (tuple2 (,) float float))
  |: ("velocity" := (tuple2 (,) float float))
  |: ("angle" := float)
  |: ("angle_velocity" := float)
  |: ("boost" := bool)
  |: ("mass" := float)
  |: ("air" := float)
  |: ("fuel" := float)
  |: thrusterDecoder

thrusterDecoder : Decoder (List ThrusterPayload)
thrusterDecoder =
  object2 ThrusterPayload
    ("firing" := int)
    ("type" := string)
  |>list
  |>(:=) "thrusters"

chatMessageDecoder : Decoder ChatMessagePayload
chatMessageDecoder =
  succeed ChatMessagePayload
  |: ("name" := string)
  |: ("message" := string)  
  |: ("owner" := string)





