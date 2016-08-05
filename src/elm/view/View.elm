module View exposing (..)

import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)
import Game             exposing (Model)
import SpaceObject      exposing (dummyShip, SpaceObject)
import Types            exposing (..)
import KeyDiagram       exposing (keyDiagram, keyExample)
import Instructions     exposing (instructions)
import MiniMap          exposing (miniMap)
import ReadOut          exposing (readOut)
import GameScope        exposing (gameScope)
import Components       exposing (veryIgnorablePoint)
import Dict             exposing (get, toList)
import Maybe            exposing (withDefault)
import List             exposing (filter, append, map)

isntPlayer : String -> (String, SpaceObject) -> Bool
isntPlayer uuid (uuid', object) =
  uuid' /= uuid

view : Model -> Html Msg
view model =
  let
    {localObjects, remoteObjects, playerId} = model

    player =
      get playerId localObjects
      |>withDefault dummyShip

    objects =
      let
        localsMinusPlayer =
          localObjects
          |>toList
          |>filter (isntPlayer playerId)
          |>map snd
      in
        append localsMinusPlayer
        <|map snd
        <|toList remoteObjects
  in
  div
  [ class "root" ]
  [ veryIgnorablePoint "Game : Orbiter D"
  , div
    [ class "main" ]
    [ div
      [ class "left-hud" ]
      [ keyDiagram 
      , instructions
      , keyExample
      ]
    , div
      [ class "game-view" ]
      [ gameScope player objects ]
    , div
      [ class "right-hud" ]
      [ miniMap player objects
      , readOut  
      ]
    ]
  ]
