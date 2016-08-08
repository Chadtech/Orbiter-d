module VelocityGauge exposing (..)

import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)
import Types            exposing (..)
import SpaceObject      exposing (Player)
import Components       exposing (point)
import String           exposing (slice)

velocityGauge : Player -> Html Msg
velocityGauge {velocity} =
  let
    (vx, vy)  = velocity
    velocity' = (sqrt (vx^2 + vy^2))/10
    urgency = 
      if 20 > velocity' then 
        ""
      else
        if 40 > velocity' then 
          "urgent"
        else 
          if 60 > velocity' then 
            "urgenter"
          else "critical"
  in
  div
  [ class "velocity-gauge" ]
  [ point "speed" 
  , p
    [class ("point " ++ urgency) ]
    [ text
      <|slice 0 5
      <|toString velocity'
    ]
  ]
