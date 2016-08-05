module RightHud exposing (rightHud)

import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)
import Types            exposing (..)
import ReadOut          exposing (readOut)
import MiniMap          exposing (miniMap)

rightHud : Model -> Html Msg
rightHud m = 
  div
  [ class "right-hud" ]
  [ miniMap m
  , readOut m.ship
  ]
