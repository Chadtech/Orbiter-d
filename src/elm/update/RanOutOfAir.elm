module RanOutOfAir exposing (ranOutOfAir)

import Game        exposing (..)
import Types       exposing (..)
import SpaceObject exposing (..)
import Dict        exposing (toList, Dict, get, insert, remove)
import Maybe       exposing (withDefault)
import Random      exposing (..)
import List        exposing (head, repeat, foldr)
import Char        exposing (fromCode)
import String      exposing (fromChar)
import Util        exposing (addObject, makeUUID, getFloat, getSector, modulo)

ranOutOfAir : Model -> Model
ranOutOfAir model =
  let
    player =
      get model.playerId model.localObjects
      |>withDefault dummyShip

    (deadPlayer, seed) =
      makeDebris model.seed player
  in
  { model
  | localObjects =
      let 
        localObjects' = 
          remove player.uuid model.localObjects 
      in
      foldr addObject localObjects'  [deadPlayer]
  , focusOn = deadPlayer.uuid
  , died = True
  , deathMessage = "You ran out of air."
  , seed = seed
  }

makeDebris : Seed -> Player -> (SpaceObject, Seed)
makeDebris seed player =
  let
    (vx, vy) = player.velocity
    (px, py) = player.global

    (uuid, seed') = makeUUID seed
  in
  (,)
  { angle = player.angle
  , local = (modulo px, modulo py)
  , global = player.global
  , velocity = player.velocity
  , sector = (getSector px, getSector py)
  , direction = atan2 vx vy
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
  , sprite =
    { src        = "ship/ship-powered-down"
    , dimensions = (47, 47)
    , area       = (138, 138)
    , position   = (0,0)
    }
  , remove = False
  , explode = False 
  }
  seed'
