module HandleKeys exposing (handleKeys)

import Types            exposing (..)
import Keyboard.Extra   exposing (isPressed)
import Keyboard.Extra   as Keyboard
import Init             exposing (initModel)
import ThrusterState    exposing (setThrusters)

handleKeys : Model -> Keyboard.Model -> Model
handleKeys m keys =
  let s = m.ship in
  if isPressed Keyboard.Enter keys then
    initModel
  else
  { m
  | keys = keys
  , ship = 
    { s | thrusters = 
      if not m.died then
        setThrusters keys 
      else s.thrusters
    }
  , paused = 
      if isPressed Keyboard.CharP keys then
        not m.paused
      else m.paused
   }
