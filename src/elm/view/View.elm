module View exposing (..)

import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)
import Game             exposing (Model)
import Types            exposing (..)
import KeyDiagram       exposing (keyDiagram, keyExample)
import Instructions     exposing (instructions)
import MiniMap          exposing (miniMap)
import ReadOut          exposing (readOut)
import Components       exposing (veryIgnorablePoint)


view : Model -> Html Msg
view model =
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
      []
    , div
      [ class "right-hud" ]
      [ miniMap model
      , readOut  
      ]
    ]
  ]
