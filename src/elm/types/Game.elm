module Game exposing (..)

import Keyboard.Extra   as Keyboard
import SpaceObject exposing (SpaceObject, SpaceObjects)
import Dict exposing (Dict, fromList)
import Time exposing (Time, now)
import Types exposing (..)
import Random 

type alias Model =
  { localObjects  : Dict String SpaceObject
  , remoteObjects : Dict String SpaceObject
  , keys          : Keyboard.Model
  , playerId      : UUID
  , playerName    : Name
  , focusOn       : UUID
  , died          : Bool
  , deathMessage  : String
  , ready         : Bool
  , chatInput     : String
  , chatMessages  : List ChatMessage
  , seed          : Random.Seed
  , chatInFocus   : Bool
  , fireIsDown    : Bool
  , bigMapUp      : Bool
  }

init : Model
init =
  { localObjects  = Dict.empty
  , remoteObjects = Dict.empty
  , keys          = fst Keyboard.init
  , playerId      = ""
  , playerName    = ""
  , focusOn       = ""
  , died          = False
  , deathMessage  = ""
  , ready         = False
  , chatInput     = ""
  , chatMessages  = []
  , seed          = Random.initialSeed 0
  , chatInFocus   = False
  , fireIsDown    = False
  , bigMapUp      = False
  }


