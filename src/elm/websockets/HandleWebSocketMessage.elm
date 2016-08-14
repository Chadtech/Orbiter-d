module HandleWebSocketMessage exposing (handleWebSocketMessage)

import Json.Decode exposing (..)
import Game exposing (..)
import Types exposing (..)
import SpaceObject exposing (..)
import Dict exposing (insert)
import Debug exposing (log)


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
        handleObjectUpdate model json

      _ -> 
        model


getMessageType : Decoder String
getMessageType =
  object1 identity ("messagetype" := string)


handleObjectUpdate : Model -> String -> Model
handleObjectUpdate model json =
  let
    object =
      case decodeString spaceObjectDecoder json of
        Ok object -> object
        Err _ -> dummyShip
  in
  { model
  | remoteObjects = 
      insert
        object.uuid
        object
        model.remoteObjects
  }

spaceObjectDecoder : Decoder SpaceObject
spaceObjectDecoder =
  object7 jsonToSpaceObject 
    ("uuid" := string)
    ("owner" := string)
    ("type" := string) 
    ("global_x" := float)
    ("global_y" := float)
    ("velocity_x" := float)
    ("velocity_y" := float)
  |>(:=) "o"
  |>object1 identity

jsonToSpaceObject : UUID -> UUID -> String -> Float -> Float -> Float -> Float -> SpaceObject
jsonToSpaceObject uuid owner type' gx gy vx vy =
  let
    lx = modulo gx
    ly = modulo gy
  in
  { angle = (0, 0)
  , local = (lx, ly)
  , global = (gx, gy)
  , velocity = (vx, gy)
  , direction = atan2 vx vy
  , dimensions =
      case type' of
        "Ship" -> (34, 29)
        _ -> (20, 20)
  , sector = (getSector gx, getSector gy)
  , fuel = 0
  , air = 0
  , mass = 0
  , missiles =0
  , type' =
      case type' of
        "Ship" -> Craft
        _ -> AirTank
  , name = "THOMAS"
  , uuid = uuid
  , owner = owner
  , engine = 
    { boost = False
    , thrusters = []
    }
  , sprite =
      case type' of
        "Ship" ->
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

getSector : Float -> Int
getSector f = floor (f / 600)

modulo : Float -> Float
modulo f =
  let f' = floor f in
  (toFloat (f' % 600)) + (f - (toFloat f'))
