module Game exposing (..)

import Keyboard.Extra   as Keyboard
import SpaceObject exposing (SpaceObject, SpaceObjects)
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
  { localObjects  = fromList []
  , remoteObjects = fromList []
  , keys          = fst Keyboard.init
  , playerId      = ""
  , died          = False
  , deathMessage  = ""
  , ready         = False
  , chatInput     = ""
  , chatMessages  = []
  }


