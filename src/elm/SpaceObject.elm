module SpaceObject exposing (..)

import Types exposing (..)
import Engine exposing (..)

type alias SpaceObjects = List (String, SpaceObject)
type alias Player = SpaceObject

type OnCollision = 
  OnCollision (SpaceObject -> SpaceObject)

type alias SpaceObject =
  { local       : Coordinate
  , global      : Coordinate
  , velocity    : Coordinate
  , angle       : (Float, Float)
  , direction   : Float
  , sector      : Sector
  , dimensions  : Dimensions
  , onCollision : OnCollision
  , sprite      : Sprite
  , fuel        : Float
  , air         : Float
  , mass        : Float
  , name        : String
  , uuid        : String
  , engine      : Engine
  }


