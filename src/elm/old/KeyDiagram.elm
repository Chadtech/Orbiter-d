module KeyDiagram exposing (keyDiagram, keyExample)

import Types            exposing (..)
import Collage          exposing (..)
import Element          exposing (..)
import Transform        exposing (..)
import Pather           exposing (root)
import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)


keyDiagram : Html Msg
keyDiagram =
  "key-diagram"
  |>root
  |>image 156 131
  |>toHtml

keyExample : Html Msg
keyExample =
  div
  [ class "key-example" ]
  [ "key-example"
    |>root
    |>image 178 178
    |>toHtml
  ]