module HighSpeedCollision exposing (highSpeedCollision)

import Game exposing (..)
import Types exposing (..)
import SpaceObject exposing (..)
import Dict exposing (..)
import Maybe exposing (withDefault)
import List exposing (head)

highSpeedCollision : Model -> Model
highSpeedCollision model =
  let
    player =
      get model.playerId model.localObjects
      |>withDefault dummyShip
      |>\p -> 
        { p 
        | type' = Debris
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

    newPlayerId = 
      model.localObjects
      |>toList
      |>head
      |>withDefault (dummyShip.uuid, dummyShip)
      |>snd
      |> (.uuid)
  in
  { model
  | localObjects =
      let {playerId, localObjects} = model in
      insert 
        playerId 
        player
        localObjects
  , died = True
  , deathMessage = "You exploded in a high speed collision."
  }