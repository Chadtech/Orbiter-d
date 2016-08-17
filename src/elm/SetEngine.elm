module SetEngine exposing (setEngine)

import Keyboard.Extra   exposing (Key)
import Keyboard.Extra   exposing (isPressed)
import Keyboard.Extra   as Keyboard
import Engine           exposing (..)
import List             exposing (map)
import SpaceObject      exposing (..)

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
    MissileMain -> Keyboard.Space