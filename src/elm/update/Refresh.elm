module Refresh exposing (refresh)

import Game exposing (..)
import Types exposing (..)
import UpdateObjects    exposing (updateObjects)
import CollisionHandle  exposing (collisionsHandle)
import SpaceObject exposing (..)
import Dict exposing (..)
import Maybe exposing (withDefault)
import CheckIfDead exposing (checkIfDead)
import Debug exposing (log)
import List


refresh : Time -> Model -> Model
refresh dt model =
  let 
    (localObjects, remoteObjects) = 
      collisionsHandle dt model
      |>seperateObjects model.playerId  

    (deathState, deathMessage) =
      checkIfDead model
  in
  { model
  | localObjects  = updateObjects dt localObjects
  , remoteObjects = updateObjects dt remoteObjects
  , died =
      case deathState of
        NotDead -> False
        _ -> True
  , deathMessage = deathMessage
  }

seperateObjects : UUID -> SpaceObjects -> (SpaceObjectDict, SpaceObjectDict)
seperateObjects uuid objects =
  let isLocal' = isLocal uuid in
  (dictOutput isLocal' objects, dictOutput (isLocal' >> not) objects)

dictOutput : (SpaceObject -> Bool) -> SpaceObjects ->  SpaceObjectDict
dictOutput filter' objects =
  fromList <| List.map bundle <| List.filter filter' objects

isLocal : UUID -> SpaceObject -> Bool
isLocal playersId object =
  playersId == object.owner

bundle : SpaceObject -> (UUID, SpaceObject)
bundle object = (object.uuid, object)