module Consumption exposing (consumeAir, consumeFuel)

import List        exposing (map, sum, product, filter)
import SpaceObject exposing (SpaceObject)
import Types       exposing (..)
import Engine      exposing (..)

consumeAir : Time -> SpaceObject -> SpaceObject
consumeAir dt object =
  let {air} = object in
  if air > 0 then
    { object | air = air - (dt / 6) }
  else
    { object | air = 0}

consumeFuel : Time -> SpaceObject -> SpaceObject
consumeFuel dt object =
  let {fuel, engine} = object in
  let {thrusters, boost} = engine in
  if fuel > 0 then
    let
      rate =
        if boost then 3.5
        else 0.5
      consumption =
        product
        [ 0.6
        , rate
        , dt
        , thrusters
          |>filter isFiring
          |>map fuelConsumption
          |>sum
          |>toFloat
        ]
    in { object | fuel = fuel - consumption }
  else { object | fuel = 0 }

isFiring : Thruster -> Bool
isFiring {firing} = firing /= 0

fuelConsumption : Thruster -> Int
fuelConsumption {type'} =
  case type' of
    Main -> 5
    _    -> 1
