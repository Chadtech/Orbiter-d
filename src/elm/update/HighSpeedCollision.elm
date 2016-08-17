module HighSpeedCollision exposing (highSpeedCollision)

import Game exposing (..)
import Types exposing (..)
import SpaceObject exposing (..)
import Dict exposing (toList, Dict, get, insert, remove)
import Maybe exposing (withDefault)
import Random exposing (..)
import List exposing (head, repeat, foldr)
import Char        exposing (fromCode)
import String      exposing (fromChar)
import Util exposing (makeUUID, getFloat, getSector, modulo)

highSpeedCollision : Model -> Model
highSpeedCollision model =
  let
    player =
      get model.playerId model.localObjects
      |>withDefault dummyShip

    --(wreckedPlayer, seed) =
    --  makeDebris model.seed player

    (debris, seed1) =
      foldr (addDebris player) ([], model.seed) listOfDebrisSprites
  in
  { model
  | localObjects =
      let 
        localObjects' = 
          remove player.uuid model.localObjects 
      in
      foldr addObject localObjects' debris
  , focusOn = (head debris |> withDefault dummyShip).uuid
  , died = True
  , deathMessage = "You exploded in a high speed collision."
  , seed = seed1
  }

addDebris : Player -> Sprite -> (SpaceObjects, Seed) -> (SpaceObjects, Seed) 
addDebris player sprite (objects, seed0) =
  let
    (debris, seed1) = 
      makeDebris seed0 player sprite
  in
    (debris :: objects, seed1)

listOfDebrisSprites : List Sprite
listOfDebrisSprites =
  [ { src        = "ship/ship-exploded"
    , dimensions = (47, 47)
    , area       = (138, 138)
    , position   = (0,0)
    }
  , { src        = "ship/ship-exploded"
    , dimensions = (47, 47)
    , area       = (138, 138)
    , position   = (0,0)
    }
  , { src        = "ship/ship-exploded"
    , dimensions = (47, 47)
    , area       = (138, 138)
    , position   = (0,0)
    }
  , { src        = "ship/ship-exploded"
    , dimensions = (47, 47)
    , area       = (138, 138)
    , position   = (0,0)
    }
  , { src        = "ship/ship-exploded"
    , dimensions = (47, 47)
    , area       = (138, 138)
    , position   = (0,0)
    }
  ]

makeDebris : Seed -> Player -> Sprite -> (SpaceObject, Seed)
makeDebris seed player sprite =
  let
    (pvx, pvy) = player.velocity
    (px, py) = player.global
    (pa, pva) = player.angle

    (a, seed0) = getFloat 0 360 seed
    (va, seed1) = getFloat -70 70 seed0
    (vx, seed2) = getFloat -30 30 seed1
    (vy, seed3) = getFloat -30 30 seed2

    (uuid, seed4) = makeUUID seed3
  in
  (,)
  { angle = (a + pa, va + pva)
  , local = (modulo px, modulo py)
  , global = player.global
  , velocity = (pvx + vx, pvy + vy)
  , sector = (getSector px, getSector py)
  , direction = atan2 (pvx + vx) (pvy + vy)
  , dimensions = (34, 29)
  , fuel = 0
  , air = 0
  , mass = 1
  , missiles = 0
  , type' = Debris
  , name = "debris"
  , uuid = uuid
  , owner = player.uuid
  , engine = 
    { boost = False
    , thrusters = []
    }
  , sprite = sprite
  , remove = False
  , explode = False 
  }
  seed4

addObject : SpaceObject -> Dict String SpaceObject -> Dict String SpaceObject
addObject newObject objects =
  insert newObject.uuid newObject objects
