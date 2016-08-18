module Components exposing (..)

import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)
import Types            exposing (Msg)


point : String -> Html Msg
point s = 
  p [ class "point" ] [ text s ]

blinkingPoint : String -> Html Msg
blinkingPoint s =
  p [ class "point blink" ] [ text s ]

tinyPoint : String -> Html Msg
tinyPoint s =
  p [ class "point tiny" ] [ text s ]

veryIgnorablePoint : String -> Html Msg
veryIgnorablePoint s =
  p [ class "point very-ignorable" ] [ text s ]

ignorablePoint : String -> Html Msg
ignorablePoint s =
  p [ class "point ignorable" ] [ text s ]

criticalPoint : String -> Html Msg
criticalPoint s = 
  p [ class "point critical" ] [ text s ]