module Types exposing (..)

import Keyboard.Extra as Keyboard
import Time
import Dom
import PageVisibility   exposing (..)


type alias Time       = Float
type alias Angle      = Float
type alias Coordinate = (Float, Float)
type alias Sector     = (Int, Int)
type alias Dimensions = (Int, Int)
type alias UUID       = String
type alias Name       = String
type alias JSON       = String
type alias Boost      = Bool

type Msg 
  = Refresh Time
  | UpdateKeys Keyboard.Msg
  | PopulateFromRandomness Time
  | UpdateName String
  | UpdateChatInput String
  | CheckForEnter Int
  | WebsocketRecieve JSON
  | WebSocketSendObject Time
  | FocusOnChat
  | FocusOnGame
  | HandleVisibility Visibility

type alias Sprite =
  { dimensions : Dimensions
  , area       : Dimensions
  , src        : String
  , position   : (Int, Int)
  }

type DeathState
  = RanOutOfAir
  | FellIntoPlanet
  | HighSpeedCollision
  | NotDead


type alias ChatMessage =
  { content : String
  , speaker : String
  }