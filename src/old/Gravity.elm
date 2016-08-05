module Gravity exposing (shipGravity, thingGravity)

import Types exposing (..)

shipGravity : Time -> Ship -> Ship
shipGravity dt ship =
  let 
    (vx, vy)   = ship.velocity
    (gvx, gvy) = gravity dt ship.global
  in
  { ship | velocity = (vx - gvx, vy - gvy) }

thingGravity : Time -> Thing -> Thing
thingGravity dt thing =
  let 
    (gvx, gvy) = gravity dt thing.global
    (vx, vy)   = thing.velocity
  in
  { thing | velocity = (vx - gvx, vy - gvy) }

gravity : Time -> Coordinate -> Coordinate
gravity dt (x,y) =
  let
    dist  = sqrt ((x - 60000)^2 + (y - 60000)^2)
    angle = atan2 (x - 60000) (y - 60000)
    g     = dt * (50000 / dist)^2
  in (g * (sin angle), g * (cos angle))