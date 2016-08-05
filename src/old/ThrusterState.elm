module ThrusterState exposing (setThrusters)

import Keyboard.Extra exposing (isPressed)
import Keyboard.Extra as Keyboard
import Types exposing (Ship, Model, Thrusters)
import Debug exposing (log)

set : Keyboard.Model -> Keyboard.Key -> Int
set m keys = 
  if isPressed keys m then 1 
  else 0

setThrusters : Keyboard.Model -> Thrusters
setThrusters keys =
  let set' = set keys in
  { leftFront  = set' Keyboard.CharC
  , leftSide   = set' Keyboard.CharS
  , leftBack   = set' Keyboard.CharE
  , main       = set' Keyboard.Space
  , rightFront = set' Keyboard.CharN
  , rightSide  = set' Keyboard.CharK
  , rightBack  = set' Keyboard.CharU
  , boost = isPressed Keyboard.Shift keys
  }
