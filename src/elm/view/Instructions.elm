module Instructions exposing (instructions)

import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)
import Components       exposing (tinyPoint)
import Types            exposing (Msg)



instructions : Html Msg
instructions = 
  div 
  [ class "pause" ] 
  [ tinyPoint "'P' to pause. Collect resources. Dont run out of air. Dont fly into the planet. Nav markers show nearby resources and point in their relative direction. Gray arrow is north. Blue arrow is your direction."]
