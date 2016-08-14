module HandleWebSocketMessage exposing (handleWebSocketMessage)

import Json.Decode.Extra exposing (..)
import Json.Decode exposing (..)
import Game exposing (..)
import Types exposing (..)
import SpaceObject exposing (..)
import List exposing (head, tail)
import Dict exposing (insert)
--import Maybe exposing (withDefault)
import Debug exposing (log)

type alias SpaceObjectPayload =
  { uuid : UUID
  , owner : UUID
  --, name : Name
  , type' : String
  , global : Coordinate
  , velocity: Coordinate
  , angle : Float
  , anglevelocity : Float
  , boost : Int
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
    Err _ -> model

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
        "ship" -> (34, 29)
        _ -> (20, 20)
  , sector = sector
  , fuel = 0
  , air = 0
  , mass = 0
  , missiles = 0
  , type' =
      case payload.type' of
        "ship" -> Ship
        _ -> AirTank
  , name = "THOMAS"
  , uuid = payload.uuid
  , owner = payload.owner
  , engine = 
    { boost = payload.boost == 1
    , thrusters = []
    }
  , sprite =
      case payload.type' of
        "ship" ->
        { src        = "ship/ship"
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
  }

payload : Decoder a -> String -> Result String a
payload = (:=) "o" >> object1 identity >> decodeString

decodeSpaceObject : String -> Result String SpaceObjectPayload
decodeSpaceObject =
  decodeString (object1 identity ("o" := spaceObjectDecoder))

spaceObjectDecoder : Decoder SpaceObjectPayload
spaceObjectDecoder =
  succeed SpaceObjectPayload
    |: ("uuid" := string)
    |: ("owner" := string)
    --|: ("name" := string)
    |: ("type" := string)
    |: ("global" := (tuple2 (,) float float))
    |: ("velocity" := (tuple2 (,) float float))
    |: ("angle" := float)
    |: ("angle_velocity" := float)
    |: ("boost" := int)


getSector : Float -> Int
getSector f = floor (f / 600)

modulo : Float -> Float
modulo f =
  let f' = floor f in
  (toFloat (f' % 600)) + (f - (toFloat f'))
