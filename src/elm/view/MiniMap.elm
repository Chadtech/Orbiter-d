module MiniMap exposing (miniMap)

import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)
import Collage          exposing (..)
import Element          exposing (..)
import Transform        exposing (..)
import Types            exposing (Msg)
import Game             exposing (Model)
import List             exposing (append, map)
import Pather           exposing (root)

miniMap : Model -> Html Msg
miniMap m =
  div
  [ class "mini-map-container" ]
  []

