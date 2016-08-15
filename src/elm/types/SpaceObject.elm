module SpaceObject exposing (..)

import Types exposing (..)
import Engine exposing (..)
import Dict exposing (Dict)

type alias SpaceObjects = List SpaceObject
type alias SpaceObjectDict = Dict String SpaceObject
type alias Player = SpaceObject

type OnCollision = 
  OnCollision (SpaceObject -> SpaceObject)

type SpaceObjectType 
  = Ship
  | AirTank
  | FuelTank
  | Missile
  | Debris

type alias SpaceObject =
  { local       : Coordinate
  , global      : Coordinate
  , velocity    : Coordinate
  , angle       : (Float, Float)
  , direction   : Float
  , sector      : Sector
  , dimensions  : Dimensions
  , type'       : SpaceObjectType
  , sprite      : Sprite
  , fuel        : Float
  , air         : Float
  , missiles    : Int
  , mass        : Float
  , name        : String
  , owner       : UUID
  , uuid        : UUID
  , engine      : Engine
  , remove      : Bool
  }

dummyShip : SpaceObject
dummyShip =
  let
    gx = 0
    gy = 0

    sector = 
      (floor (gx / 600), floor (gy / 600))
  in
  { angle       = (0, 0)
  , local       = (gx, gy)
  , global      = (gx, gy)
  , velocity    = (0, 0)
  , sector      = sector
  , direction   = 0
  , dimensions  = (34, 29)
  , fuel        = 505.1
  , air         = 63
  , mass        = 852
  , missiles    = 0
  , type'       = Ship
  , name        = "dummy"
  , uuid        = "21"
  , owner       = "40"
  , engine      =
    { boost     = False
    , thrusters = []
    }
  , sprite =
    { src        = "ship/ship"
    , dimensions = (1, 1)
    , area       = (1, 1)
    , position   = (0,0)
    }
  , remove      = False
  }