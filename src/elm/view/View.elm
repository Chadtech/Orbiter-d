module View exposing (..)

import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)
import Game             exposing (Model)
import SpaceObject      exposing (dummyShip, SpaceObject, SpaceObjects, Player)
import Types            exposing (..)
import KeyDiagram       exposing (keyDiagram, keyExample)
import Instructions     exposing (instructions)
import MiniMap          exposing (miniMap)
import ReadOut          exposing (readOut)
import GameScope        exposing (gameScope)
import NavMarkers       exposing (navMarkers)
import VelocityGauge    exposing (velocityGauge)
import ChatRoom         exposing (chatroom)
import Died             exposing (diedNotice)
import Components       exposing (veryIgnorablePoint)
import Dict             exposing (get, toList, Dict)
import Maybe            exposing (withDefault)
import List             exposing (filter, append, map)

import Debug exposing (log)

view : Model -> Html Msg
view model =
  let 
    (player, objects) = 
      isolatePlayer model 
    {bigMapUp} = model
  in
  div
  [ class "root" ]
  [ veryIgnorablePoint "Game : Orbiter D"
  , div
    [ class "main" ]
    [ div
      [ class "left-hud" ]
      [ instructions
      , keyDiagram
      , keyExample
      ]
    , chatroom model
    , ifBigMapUp bigMapUp
    <| div
      [ class "game-view" ]
      [ if bigMapUp then (span [] [])
        else gameScope player objects 
      , navMarkers player objects
      , velocityGauge player
      , diedNotice model.died model.deathMessage
      ]
    , div
      [ class "right-hud" ]
      [ miniMap player objects
      , readOut player
      ]
    ]
  ]

ifBigMapUp : Bool -> Html Msg -> Html Msg
ifBigMapUp itsUp game =
  if itsUp then span [] []
  else game

isntPlayer : UUID -> SpaceObject -> Bool
isntPlayer uuid' {uuid} = uuid' /= uuid

justObjects : Dict String SpaceObject -> SpaceObjects
justObjects objects = map snd <| toList objects

isolatePlayer : Model -> (Player, SpaceObjects)
isolatePlayer model =
  let
    {localObjects, remoteObjects, focusOn, playerId} = model

    player =
      get focusOn localObjects
      |>elseDummy

    objects =
      localObjects
      |>justObjects
      |>filter (isntPlayer focusOn)
      |>append (justObjects remoteObjects)
      
  in (player, objects)







