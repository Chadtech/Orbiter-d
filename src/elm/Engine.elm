module Engine exposing (..)

import Types exposing (..)
import Keyboard.Extra exposing (Key)

type alias Engine = 
  { boost : Bool
  , thrusters : List Thruster
  }

type alias Thruster =
  { firing      : Int
  , sprite      : Sprite
  , key         : Key
  , power       : 
    { weak      : Float
    , strong    : Float
    }
  , consumption :
    { weak      : Float
    , strong    : Float
    }
  , sprites     : 
    { weak      : Sprite
    , strong    : Sprite
    }
  }
