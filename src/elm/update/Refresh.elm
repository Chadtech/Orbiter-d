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


refresh : Time -> Model -> Model
refresh dt model =
  let 
    {localObjects, remoteObjects} = 
      collisionsHandle dt model 

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
  --, remove =
  --    case deathState of
  --      FellIntoPlanet     -> True
  --      HighSpeedCollision -> False
  --      RanOutOfAir        -> False
  --      _                  -> False

  }
