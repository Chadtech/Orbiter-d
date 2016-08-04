module HandleKeys exposing (handleKeys)

import Keyboard.Extra   exposing (isPressed)
import Keyboard.Extra   as Keyboard
import Game exposing (Model)

handleKeys : Model -> Keyboard.Model -> Model
handleKeys m keys =
  m
  --let s = m.ship in
  --if isPressed Keyboard.Enter keys then
  --  initModel
  --else
  --{ m
  --| keys = keys
  --, ship = 
  --  { s | thrusters = 
  --    if not m.died then
  --      setThrusters keys 
  --    else s.thrusters
  --  }
  --, paused = 
  --    if isPressed Keyboard.CharP keys then
  --      not m.paused
  --    else m.paused
  -- }
