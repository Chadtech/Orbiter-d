module Components exposing (..)

import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)
import Types            exposing (Msg)


point : String -> Html Msg
point s = 
  p [ class "point" ] [ text s ]

tinyPoint : String -> Html Msg
tinyPoint s =
  p [ class "point tiny" ] [ text s ]

veryIgnorablePoint : String -> Html Msg
veryIgnorablePoint s =
  p [ class "point very-ignorable" ] [ text s ]