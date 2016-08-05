module Consumption exposing (consumption)

import List  exposing (sum, product)
import Types exposing (..)

consumption : Time -> (Ship -> Ship)
consumption dt = 
  consumeAir dt >> consumeFuel dt

consumeAir : Time -> Ship -> Ship
consumeAir dt ship =
  let {oxygen} = ship in
  if oxygen > 0 then
    { ship | oxygen = oxygen - (dt / 6) }
  else 
    { ship | oxygen = 0 }

consumeFuel : Time -> Ship -> Ship
consumeFuel dt ship =
  let {fuel, thrusters} = ship in
  if fuel > 0 then
    let
      rate = 
        if thrusters.boost then 3.5
        else 0.5
      consumption =
        product 
        [ 0.6
        , rate
        , dt
        , toFloat
          <|sum 
            [ thrusters.leftFront
            , thrusters.leftSide
            , thrusters.leftBack
            , thrusters.rightFront
            , thrusters.rightSide
            , thrusters.rightBack
            , thrusters.main * 5
            ]
        ]
    in
    { ship | fuel = fuel - consumption }
   else
    { ship | fuel = 0 }
