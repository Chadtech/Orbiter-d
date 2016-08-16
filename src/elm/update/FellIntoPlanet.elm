module FellIntoPlanet exposing (..)

import Game exposing (..)
import Types exposing (..)
import Dict exposing (toList, remove, union, get)
import List exposing (..)
import SpaceObject exposing (dummyShip, SpaceObject)
import Maybe exposing (withDefault)
import Random exposing (Seed)
import Util exposing (getInt)

fellIntoPlanet : Model -> Model
fellIntoPlanet model =
  let
    (newFocus, seed) =
      randomObject model
  in
  { model
  | focusOn = newFocus
  , localObjects =
      let {localObjects} = model in
      remove model.playerId localObjects
  , died = True
  , deathMessage = "You burnt up in the atmosphere."
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

