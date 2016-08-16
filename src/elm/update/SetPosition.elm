module SetPosition exposing (setPosition)

import Types       exposing (..)
import SpaceObject exposing (SpaceObject, SpaceObjects)
import List        exposing (map)
import Util        exposing (getSector, modulo, moduloAngle)

setPosition : Time -> SpaceObject -> SpaceObject
setPosition dt object =
  let
    (x, y)  = object.global
    (a, va) = object.angle
    (vx,vy) = object.velocity

    vx' = dt * vx
    vy' = dt * vy

    x' = x + vx'
    y' = y + vy'

    a' = a + (dt * va)
  in
  { object 
  | local     = (modulo x', modulo y')
  , global    = (x', y')
  , angle     = (moduloAngle a', va)
  , sector    = (getSector x', getSector y')
  , direction = atan2 vx vy
  }
