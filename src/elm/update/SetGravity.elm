module SetGravity exposing (setGravity)

import Types exposing (..)
import SpaceObject exposing (..)

setGravity : Time -> SpaceObject -> SpaceObject
setGravity dt object =
  let
    (vx, vy) = object.velocity
    (gvx, gvy) = gravity dt object.global
  in
    { object | velocity = (vx - gvx, vy - gvy) }

gravity : Time -> Coordinate -> Coordinate
gravity dt (x,y) =
  let
    dist  = sqrt ((x - 60000)^2 + (y - 60000)^2)
    angle = atan2 (x - 60000) (y - 60000)
    g     = dt * (50000 / dist)^2
  in (g * (sin angle), g * (cos angle))