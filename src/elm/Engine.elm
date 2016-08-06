module Engine exposing (..)

import Types exposing (..)
import Keyboard.Extra exposing (Key)

type ThrusterType
  = Main
  | FrontLeft 
  | FrontRight
  | SideLeft
  | SideRight
  | BackLeft
  | BackRight

type alias Engine = 
  { boost : Bool
  , thrusters : List Thruster
  }

type alias Thruster =
  { firing      : Int
  , type'       : ThrusterType
  }