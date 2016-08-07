module SetPosition exposing (setPosition)

import Types       exposing (..)
import SpaceObject exposing (SpaceObject, SpaceObjects)
import List        exposing (map)

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
  | local  = (modulo x', modulo y')
  , global = (x', y')
  , angle  = (moduloAngle a', va)
  , sector = (getSector x', getSector y')
  }

modulo : Float -> Float
modulo f =
  let f' = floor f in
  (toFloat (f' % 600)) + (f - (toFloat f'))

moduloAngle : Angle -> Angle
moduloAngle a =
  let a' = floor a in
  (toFloat (a' % 360)) + (a - (toFloat a'))

getSector : Float -> Int
getSector f = floor (f / 600)