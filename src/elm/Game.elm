module Game exposing (..)

import Keyboard.Extra   as Keyboard
import SpaceObject exposing (SpaceObject, SpaceObjects)
import Dict exposing (Dict, fromList)

type alias Model =
  { spaceObjects : Dict String SpaceObject
  , keys         : Keyboard.Model
  , playerName   : String
  , playerId     : String
  , died         : Bool
  , deathMessage : String
  }

init : Model
init =
  { spaceObjects = 
      fromList 
      [ ("40", playersShip) ]
  , keys         = fst Keyboard.init
  , playerName   = "Frege"
  , playerId     = "40"
  , died         = False
  , deathMessage = ""
  }

playersShip : SpaceObject
playersShip =
  let
    gx = 44900
    gy = 60000

    sector = 
      (floor (gx / 600), floor (gy / 600))
  in
  { angle       = (0, 0)
  , local       = (gx, gy)
  , global      = (gx, gy)
  , velocity    = (0, -400)
  , sector      = sector
  , direction   = 0
  , dimensions  = (34, 29)
  , fuel        = 505.1
  , air         = 63
  , mass        = 852
  , onCollision = 
      SpaceObject.OnCollision (\s -> s)
  , name        = "Frege"
  , uuid        = "40"
  , engine      =
    { boost     = False
    , thrusters = []
    }
  , sprite =
    { src        = "ship/ship"
    , dimensions = (47, 47)
    , position   = (0,0)
    }
  }
