module Refresh exposing (refresh)

import Game               exposing (..)
import Types              exposing (..)
import HandlePhysics      exposing (handlePhysics)
import HandleCollisions   exposing (handleCollisions)
import SpaceObject        exposing (..)
import Dict               exposing (..)
import Maybe              exposing (withDefault)
import HandleDeath        exposing (handleDeath)
import Util               exposing (bundle, isLocal)
import List

refresh : Time -> Model -> Model
refresh dt =
  handleCollisions dt
  >>checkIfTooClose
  >>handleDeath
  >>handlePhysics dt


checkIfTooClose : Model -> Model
checkIfTooClose model =
  let
    objects =
      union 
        model.localObjects
        model.remoteObjects
      |>values
      |>List.filter (tooClose >> not)
  in
  { model
  | localObjects =
      objects
      |>List.filter (isLocal model.playerId)
      |>List.map bundle
      |>fromList
  , remoteObjects =
      objects
      |>List.filter (isLocal model.playerId >> not)
      |>List.map bundle
      |>fromList
  }

tooClose : SpaceObject -> Bool
tooClose {global, type'} =
  if type' /= Ship then
    let
      (x,y) = global
      x' = x - 60000
      y' = y - 60000
    in
    (sqrt (x'^2 + y'^2)) < 5000
  else False
