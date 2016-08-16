module FellIntoPlanet exposing (..)

import Game exposing (..)
import Types exposing (..)
import Dict exposing (toList, remove, union, get)
import List exposing (..)
import SpaceObject exposing (dummyShip, SpaceObject)
import Maybe exposing (withDefault)
import Random exposing (..)
import Debug exposing (log)

fellIntoPlanet : Model -> String ->  Model
fellIntoPlanet model deathMessage =
  let
    oldPlayerId = model.playerId
    (newPlayerId, seed) =
      randomObject model
  in
  { model
  | playerId = newPlayerId
  , localObjects =
      let {localObjects} = model in
      remove oldPlayerId localObjects
  , died = True
  , deathMessage = deathMessage
  , seed = seed
  }

randomObject : Model -> (UUID, Seed)
randomObject {seed, localObjects, remoteObjects} =
  let 
    objects = 
      union localObjects remoteObjects 
      |>toList

    (i, seed') =
      getInt 0 (length objects) seed

  in
    (fst <| unravel (i - 1) 0 objects, seed')

unravel : Int -> Int -> List (UUID, SpaceObject) -> (UUID, SpaceObject)
unravel i j l =
  if i == j then
     head l |> withDefault (dummyShip.uuid, dummyShip)
  else
    unravel i (j + 1) (tail l |> withDefault []) 

getInt : Int -> Int -> Seed -> (Int, Seed)
getInt i j seed =
  Random.step (Random.int i j) seed