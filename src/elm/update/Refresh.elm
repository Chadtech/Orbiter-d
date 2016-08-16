module Refresh exposing (refresh)

import Game exposing (..)
import Types exposing (..)
import HandlePhysics    exposing (handlePhysics)
import CollisionHandle  exposing (handleCollisions)
import SpaceObject exposing (..)
import Dict exposing (..)
import Maybe exposing (withDefault)
import CheckIfDead exposing (handleDeath)
import Debug exposing (log)
import List


refresh : Time -> Model -> Model
refresh dt =
  handleCollisions dt
  >>handleDeath
  >>handlePhysics dt


