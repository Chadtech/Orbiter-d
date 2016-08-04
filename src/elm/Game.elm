module Game exposing (..)

import Keyboard.Extra   as Keyboard

type alias Model =
  { spaceObjects : SpaceObjects
  , keys         : Keyboard.Model
  , playerName   : String
  , playerId     : String
  , died         : Bool
  , deathMessage : String
  }

init : Model
init =
  { spaceObjects = []
  , keys         = fst Keyboard.init
  , playerName   = "Frege"
  , playerId     = "40"
  , died         = False
  , deathMessage = ""
  }

type alias SpaceObjects = List Int