module HandleDeath exposing (handleDeath)

import Game exposing (..)
import Types exposing (..)
import SpaceObject exposing (..)
import Dict exposing (..)
import Maybe exposing (withDefault)
import FellIntoPlanet exposing (fellIntoPlanet)
import HighSpeedCollision exposing (highSpeedCollision)
import List exposing (head)

handleDeath : Model -> Model
handleDeath model =
  if model.died then model
  else
  let (deathState, deathMessage) = checkIfDead model in
  case deathState of
    RanOutOfAir ->
      { model
      | died = True
      , deathMessage = deathMessage
      }

    FellIntoPlanet ->
      fellIntoPlanet model deathMessage

    HighSpeedCollision ->
      highSpeedCollision model deathMessage

    _ -> model


checkIfDead : Model -> (DeathState, String)
checkIfDead {playerId, localObjects} =
  let
    player = 
      get playerId localObjects
      |>withDefault dummyShip
  in
    (NotDead, "")
    |>isThereAir player
    |>notTooCloseToPlanet player
    |>notExploded player

notExploded : Player -> (DeathState, String) -> (DeathState, String)
notExploded player state =
  if player.explode then 
    (HighSpeedCollision, "You exploded in a high speed collision.")
  else state

isThereAir : Player -> (DeathState, String) -> (DeathState, String)
isThereAir {air} state =
  if air > 0 then state
  else (RanOutOfAir, "You ran out of air.")

notTooCloseToPlanet : Player -> (DeathState, String) -> (DeathState, String)
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
    else (FellIntoPlanet, "You burnt up in the atmosphere.")
