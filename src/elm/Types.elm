module Types exposing (..)

import Keyboard.Extra   as Keyboard

type alias Time       = Float
type alias Angle      = Float
type alias Coordinate = (Float, Float)
type alias Sector     = (Int, Int)
type alias Dimensions = (Int, Int)
type alias UUID       = String

type Msg 
  = Refresh Time
  | HandleKeys Keyboard.Msg

type alias Sprite =
  { dimensions : Dimensions
  , src        : String
  , position   : (Int, Int)
  }