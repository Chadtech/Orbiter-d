module Game exposing (..)

import Keyboard.Extra   as Keyboard
import SpaceObject exposing (SpaceObject, SpaceObjects, playersShip, player2, o2Box)
import Dict exposing (Dict, fromList)
import Time exposing (Time, now)
import Types exposing (..)

type alias Model =
  { localObjects  : Dict String SpaceObject
  , remoteObjects : Dict String SpaceObject
  , keys          : Keyboard.Model
  , playerId      : String
  , died          : Bool
  , deathMessage  : String
  , ready         : Bool
  , chatInput     : String
  , chatMessages  : List ChatMessage
  }

init : Model
init =
  { localObjects  = fromList [ ("40", playersShip), ("12", o2Box), ("03", player2)]
  , remoteObjects = fromList []
  , keys          = fst Keyboard.init
  , playerId      = "40"
  , died          = False
  , deathMessage  = ""
  , ready         = False
  , chatInput     = ""
  , chatMessages  = []
  }


