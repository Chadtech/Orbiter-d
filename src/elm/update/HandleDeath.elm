module HandleDeath exposing (handleDeath)

import Game exposing (..)
import Types exposing (..)
import SpaceObject exposing (..)
import Dict exposing (..)
import Maybe exposing (withDefault)
import FellIntoPlanet exposing (fellIntoPlanet)
import HighSpeedCollision exposing (highSpeedCollision)
import RanOutOfAir exposing (ranOutOfAir)
import List exposing (head)

handleDeath : Model -> Model
handleDeath model =
  if model.died then model
  else
  let deathState = checkIfDead model in
  case deathState of
    RanOutOfAir ->
      ranOutOfAir model

    FellIntoPlanet ->
      fellIntoPlanet model

    HighSpeedCollision ->
      highSpeedCollision model

    _ -> model

checkIfDead : Model -> DeathState
checkIfDead {playerId, localObjects} =
  let
    player = 
      get playerId localObjects
      |>withDefault dummyShip
  in
    NotDead
    |>isThereAir player
    |>notTooCloseToPlanet player
    |>notExploded player

notExploded : Player -> DeathState -> DeathState
notExploded {explode} state =
  if explode then HighSpeedCollision
  else state

isThereAir : Player -> DeathState -> DeathState
isThereAir {air} state =
  if air > 0 then state
  else RanOutOfAir

notTooCloseToPlanet : Player -> DeathState -> DeathState
notTooCloseToPlanet {global} state =
  let
    tooClose =
      let
        (x,y) = global
        x' = x - 60000
        y' = y - 60000
      in
      (sqrt (x'^2 + y'^2)) < 5000
  in
    if not tooClose then state
    else FellIntoPlanet
