module View exposing (..)

import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)
import Types            exposing (..)
import GameView         exposing (gameView)
import RightHud         exposing (rightHud)
import NavMarkers       exposing (navMarkers)
import VelocityGauge    exposing (velocityGauge)
import KeyDiagram       exposing (keyDiagram, keyExample)
import PauseView        exposing (pausedNotice, instructions)
import DiedView         exposing (diedNotice)


view : Model -> Html Msg
view model = 
  let {ship, died, deathMsg, paused} = model in
  div
  [ class "root" ]
  [ div 
    [ class "main" ]
    [ div
      [ class "left-hud" ]
      [ keyDiagram
      , instructions
      ]
    , keyExample
    , div 
      [ class "game-view" ] 
      [ gameView model
      , navMarkers model
      , velocityGauge ship
      , pausedNotice paused
      , diedNotice died deathMsg
      ]
    , rightHud model
    ]
  ]

