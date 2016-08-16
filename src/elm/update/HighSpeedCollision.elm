module HighSpeedCollision exposing (highSpeedCollision)

import Game exposing (..)
import Types exposing (..)
import SpaceObject exposing (..)
import Dict exposing (..)
import Maybe exposing (withDefault)
import Random exposing (..)
import List exposing (head, repeat, foldr)
import Char        exposing (fromCode)
import String      exposing (fromChar)

highSpeedCollision : Model -> Model
highSpeedCollision model =
  let
    (player, seed) =
      get model.playerId model.localObjects
      |>withDefault dummyShip
      |>modifyPlayer model.seed

    (newDebris, seed1) =
      makeDebris seed player

    newPlayerId = 
      model.localObjects
      |>toList
      |>head
      |>withDefault (dummyShip.uuid, dummyShip)
      |>snd
      |>(.uuid)
  in
  { model
  | localObjects =
      let {playerId, localObjects} = model in
      List.foldr addObject localObjects [player, newDebris]
  , died = True
  , deathMessage = "You exploded in a high speed collision."
  , seed = seed1
  }



makeDebris : Seed -> Player -> (SpaceObject, Seed)
makeDebris seed player =
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
  , sprite =
    { src        = "ship/ship-exploded"
    , dimensions = (47, 47)
    , area       = (138, 138)
    , position   = (0,0)
    }
  , remove = False
  , explode = False 
  }
  seed4

getSector : Float -> Int
getSector f = floor (f / 600)

modulo : Float -> Float
modulo f =
  let f' = floor f in
  (toFloat (f' % 600)) + (f - (toFloat f'))

getFloat : Float -> Float -> Seed -> (Float, Seed)
getFloat i j seed =
  Random.step (Random.float i j) seed

makeUUID : Seed -> (String, Seed)
makeUUID seed =
  let
    floats =
      List.foldr (always addToUUID) ([], seed) [0..15]
  in
    (floatsToString (fst floats), snd floats)

addToUUID : (List Float, Seed) -> (List Float, Seed)
addToUUID (floats, seed) =
  let (thisFloat, seed') = getFloat 0 15 seed in
  (thisFloat :: floats, seed')

floatsToString : List Float -> String
floatsToString list =
  list
  |>List.map (fromChar << fromCode << floor << (+) 65)
  |>List.foldr (++) ""

addObject : SpaceObject -> Dict String SpaceObject -> Dict String SpaceObject
addObject newObject objects =
  insert newObject.uuid newObject objects

modifyPlayer : Seed -> Player -> (Player, Seed)
modifyPlayer seed player =
  let
    (dva, seed1) = getFloat -20 20 seed
    (dvx, seed2) = getFloat -20 20 seed1
    (dvy, seed3) = getFloat -20 20 seed2
 
    (a, va) = player.angle
    (vx, vy) = player.velocity
  in
  (,)
  { player
  | angle = (a, va + dva)
  , velocity = (vx + dvx, vy + dvy)
  , type' = Debris
  , sprite =
    { src        = "ship/ship-exploded"
    , dimensions = (47, 47)
    , area       = (138, 138)
    , position   = (0,0)
    }
  , engine = 
    { boost = False
    , thrusters = []
    }
  }
  seed3
