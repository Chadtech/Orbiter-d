module Instructions exposing (instructions)

import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)
import Components       exposing (tinyPoint)
import Types            exposing (Msg)

instructions : Html Msg
instructions = 
  div 
  [ class "instructions" ] 
  [ p [ class "point tiny ignorable" ] [ text "Collect resources. Dont run out of air. Dont crash. 'G' to fire missile. 'T' for map view. Nav markers show nearby stuff and point where they are traveling relative to you. Gray arrow is north. Blue arrow is your direction." ]
  ]
