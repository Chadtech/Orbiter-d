module Died exposing (diedNotice)

import Components       exposing (point)
import Types            exposing (..)
import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)

diedNotice : Bool -> String -> Html Msg
diedNotice died diedMsg =
  if died then
    div 
    [ class "died-notice" ]
    [ point diedMsg 
    , point "Press Enter to rejoin."
    ]
  else span [] []