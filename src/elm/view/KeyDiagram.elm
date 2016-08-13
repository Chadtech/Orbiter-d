module KeyDiagram exposing (keyDiagram, keyExample)

import Types            exposing (..)
import Collage          exposing (..)
import Element          exposing (..)
import Transform        exposing (..)
import Pather           exposing (root)
import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)


keyExample : Html Msg
keyExample =
  div
  [ class "key-example" ]
  [ img
    [ src (root "key-example")
    , class "key-example-image"
    ]
    []
  ]

keyDiagram : Html Msg
keyDiagram =
  div
  [ class "key-diagram" ]
  [ img
    [ src (root "key-diagram")
    , class "key-diagram-image"
    ]
    []
  ]
