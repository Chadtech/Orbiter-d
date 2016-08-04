module Types exposing (..)

import Keyboard.Extra   as Keyboard

type alias Time = Float

type Msg 
  = Refresh Time
  | HandleKeys Keyboard.Msg
