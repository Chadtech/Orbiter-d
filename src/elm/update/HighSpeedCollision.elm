module HighSpeedCollision exposing (highSpeedCollision)

import Game exposing (..)
import Types exposing (..)
import SpaceObject exposing (..)
import Dict exposing (..)
import Maybe exposing (withDefault)
import Random exposing (..)
import List exposing (head)

highSpeedCollision : Model -> Model
highSpeedCollision model =
  let
    (player, seed) =
      get model.playerId model.localObjects
      |>withDefault dummyShip
      |>modifyPlayer model.seed

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
      addObject localObjects player 
  , died = True
  , deathMessage = "You exploded in a high speed collision."
  , seed = seed
  }

--makeDebris : Seed 

getFloat : Float -> Float -> Seed -> (Float, Seed)
getFloat i j seed =
  Random.step (Random.float i j) seed

addObject : Dict String SpaceObject -> SpaceObject -> Dict String SpaceObject
addObject objects newObject =
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
