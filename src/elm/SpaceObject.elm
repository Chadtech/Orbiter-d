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
  = Craft
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
  , mass        : Float
  , name        : String
  , owner       : UUID
  , uuid        : UUID
  , engine      : Engine
  , remove      : Bool
  }

o2Box : SpaceObject
o2Box =
  let
    gx = 44750
    gy = 60000

    sector = 
      (floor (gx / 600), floor (gy / 600))
  in
  { angle       = (10, -10)
  , local       = (gx, gy)
  , global      = (gx, gy)
  , velocity    = (15, -420)
  , sector      = sector
  , direction   = 0
  , dimensions  = (20, 20)
  , fuel        = 505.1
  , air         = 63
  , mass        = 852
  , type'       = AirTank
  , name        = "air box"
  , uuid        = "12"
  , owner       = "40"
  , engine      =
    { boost     = False
    , thrusters = []
    }
  , sprite =
    { src        = "stuff/oxygen-tank"
    , dimensions = (20, 20)
    , area       = (20, 20)
    , position   = (0,0)
    }
  , remove      = False
  }

playersShip : SpaceObject
playersShip =
  let
    gx = 44850
    gy = 60000

    sector = 
      (floor (gx / 600), floor (gy / 600))
  in
  { angle       = (0, 0)
  , local       = (gx, gy)
  , global      = (gx, gy)
  , velocity    = (10, -400)
  , sector      = sector
  , direction   = 0
  , dimensions  = (34, 29)
  , fuel        = 505.1
  , air         = 63
  , mass        = 852
  , type'       = Craft
  , name        = "Frege"
  , uuid        = "40"
  , owner       = "40"
  , engine      =
    { boost     = False
    , thrusters = 
      [ { type' = Main,       firing = 0 }
      , { type' = FrontLeft,  firing = 0 }
      , { type' = FrontRight, firing = 0 }
      , { type' = SideLeft,   firing = 0 }
      , { type' = SideRight,  firing = 0 }
      , { type' = BackLeft,   firing = 0 }
      , { type' = BackRight,  firing = 0 }
      ]
    }
  , sprite =
    { src        = "ship/ship"
    , dimensions = (47, 47)
    , area       = (138, 138)
    , position   = (0,0)
    }
  , remove      = False

  }

player2 : SpaceObject
player2 =
  let
    gx = 44950
    gy = 60000

    sector = 
      (floor (gx / 600), floor (gy / 600))
  in
  { angle       = (0, 0)
  , local       = (gx, gy)
  , global      = (gx, gy)
  , velocity    = (10, -400)
  , sector      = sector
  , direction   = 0
  , dimensions  = (34, 29)
  , fuel        = 505.1
  , air         = 63
  , mass        = 852
  , type'       = Craft
  , name        = "Russell"
  , uuid        = "03"
  , owner       = "40"
  , engine      =
    { boost     = False
    , thrusters = 
      [ { type' = Main,       firing = 0 }
      , { type' = FrontLeft,  firing = 1 }
      , { type' = FrontRight, firing = 0 }
      , { type' = SideLeft,   firing = 0 }
      , { type' = SideRight,  firing = 0 }
      , { type' = BackLeft,   firing = 0 }
      , { type' = BackRight,  firing = 0 }
      ]
    }
  , sprite =
    { src        = "ship/ship"
    , dimensions = (47, 47)
    , area       = (138, 138)
    , position   = (0,0)
    }
  , remove      = False
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
  , type'       = Craft
  , name        = "dummy"
  , uuid        = "21"
  , owner       = "40"
  , engine      =
    { boost     = False
    , thrusters = []
    }
  , sprite =
    { src        = "ship/ship"
    , dimensions = (47, 47)
    , area       = (138, 138)
    , position   = (0,0)
    }
  , remove      = False
  }