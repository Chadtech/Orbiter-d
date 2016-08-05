module Refresh exposing (refresh)

import SetWeight        exposing (setWeight)
import Types            exposing (..)
import Gravity          exposing (shipGravity, thingGravity)
import Thrust           exposing (setThrust)
import List             exposing (map)
import Consumption      exposing (consumption)
import ShipPosition     exposing (shipPosition)
import ThingPosition    exposing (thingPosition)


refresh : Time -> Model -> Model
refresh dt m =
  let
    {ship, things, died} = m
    (isDead, deathMsg) =
      checkIfDead ship
  in
  { m 
  | ship = refreshShip dt ship
  , things = 
      things
      |>map (refreshThing dt)
  , died     = isDead || died
  , deathMsg = deathMsg
  }

refreshShip : Time -> (Ship -> Ship)
refreshShip dt =
  consumption dt
  >>setWeight
  >>setThrust
  >>shipGravity dt
  >>shipPosition dt

checkIfDead : Ship -> (Bool, String)
checkIfDead {global, oxygen} =
  let
    (x,y) = global
    x' = x - 60000
    y' = y - 60000
    noMoreAir = oxygen < 1
    tooCloseToPlanet = 
      (sqrt (x'^2 + y'^2)) < 5000 

    deathMsg =

      if noMoreAir then "You ran out of air"
      else
        if tooCloseToPlanet then 
          "You burnt up in the atmosphere"
        else ""
  in 
    (noMoreAir || tooCloseToPlanet, deathMsg)

refreshThing : Time -> (Thing -> Thing)
refreshThing dt =
  thingPosition dt >> thingGravity dt