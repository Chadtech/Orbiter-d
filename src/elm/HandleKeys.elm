module HandleKeys exposing (handleKeys)

import Keyboard.Extra   exposing (Key)
import Keyboard.Extra   exposing (isPressed)
import Keyboard.Extra   as Keyboard
import Game             exposing (Model)
import Engine           exposing (..)
import Dict             exposing (get, insert)
import List             exposing (map)
import SpaceObject      exposing (..)
import Maybe            exposing (withDefault)

handleKeys : Model -> Keyboard.Model -> Model
handleKeys model keys =
  let {playerId, localObjects} = model in
  { model
  | keys = keys
  , localObjects = 
      let
        player = 
          get playerId localObjects
          |>withDefault dummyShip
          |>setEngine keys
      in
      insert playerId player localObjects
  }

setEngine : Keyboard.Model -> Player -> Player
setEngine keys player =
  let {engine} = player in
  { player
  | engine =
    { thrusters =
        map (setThruster (player.fuel > 0) keys) engine.thrusters
    , boost = isPressed Keyboard.Shift keys 
    }
  }

setThruster : Bool -> Keyboard.Model -> Thruster -> Thruster
setThruster enoughFuel keys thruster =
  let keyIsPressed = isPressed (thrustersKey thruster) keys in
  if not enoughFuel then { thruster | firing = 0 }
  else
    if keyIsPressed then { thruster | firing = 1 }
    else { thruster | firing = 0 }


thrustersKey : Thruster -> Keyboard.Key
thrustersKey {type'} =
  case type' of
    Main       -> Keyboard.Space
    FrontLeft  -> Keyboard.CharC
    FrontRight -> Keyboard.CharN
    SideLeft   -> Keyboard.CharS
    SideRight  -> Keyboard.CharK
    BackLeft   -> Keyboard.CharE
    BackRight  -> Keyboard.CharU

