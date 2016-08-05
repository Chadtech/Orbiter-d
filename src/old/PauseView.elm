module PauseView exposing (pausedNotice, instructions)

import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)
import Types        exposing (..)
import Components   exposing (point, tinyPoint)

pausedNotice : Bool -> Html Msg
pausedNotice paused =
  if paused then
    div
    [ class "paused-notice" ]
    [ point "PAUSED" ]
  else span [] []

instructions : Html Msg
instructions = 
  div 
  [ class "pause" ] 
  [ tinyPoint "'P' to pause. Collect resources. Dont run out of air. Dont fly into the planet. Nav markers show nearby resources and point in their relative direction. Gray arrow is north. Blue arrow is your direction."]
