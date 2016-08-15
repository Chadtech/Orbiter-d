module CheckIfDead exposing (handleDeath)

import Game exposing (..)
import Types exposing (..)
import SpaceObject exposing (..)
import Dict exposing (..)
import Maybe exposing (withDefault)
import Debug exposing (log)
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
      let
        player =
          get model.playerId model.localObjects
          |>withDefault dummyShip
          |> (\p -> { p | remove = True })

        newPlayerId = 
          model.localObjects
          |>toList
          |>head
          |>withDefault (dummyShip.uuid, dummyShip)
          |>snd
          |> (.uuid)
      in
      { model
      | playerId = newPlayerId
      , localObjects =
          let {playerId, localObjects} = model in
          remove playerId localObjects
      , died = True
      , deathMessage = deathMessage
      }
    HighSpeedCollision ->
      let
        player =
          get model.playerId model.localObjects
          |>withDefault dummyShip
          |>\p -> 
            { p 
            | sprite =
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

        newPlayerId = 
          model.localObjects
          |>toList
          |>head
          |>withDefault (dummyShip.uuid, dummyShip)
          |>snd
          |> (.uuid)
      in
      { model
      --| playerId = newPlayerId
      | localObjects =
          let {playerId, localObjects} = model in
          insert 
            playerId 
            player
            localObjects
      , died = True
      , deathMessage = deathMessage
      }
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
