module ThingPosition exposing (thingPosition)

import Types exposing (..)

modulo : Float -> Float
modulo f =
  let f' = round f in
  (toFloat (f' % 600)) + (f - (toFloat f'))

moduloClockwise : Angle -> Angle
moduloClockwise a =
  if a > 180 then
    moduloClockwise (a - 360)
  else a

moduloCClockwise : Angle -> Angle
moduloCClockwise a =
  if a < -180 then
    moduloCClockwise (a + 360)
  else a

moduloAngle : Angle -> Angle
moduloAngle =
  moduloClockwise >> moduloCClockwise

getSector : Float -> Int
getSector f = floor (f / 600)

thingPosition : Time -> Thing -> Thing
thingPosition dt thing =
  let
    (x,y)    = thing.global
    (vx, vy) = thing.velocity
    (a, va)  = thing.angle
    vy'      = dt * vy
    vx'      = dt * vx
    y'       = y + vy'
    x'       = x + vx'
    a'       = a + (dt * va)
    ym       = modulo y'
    xm       = modulo x'
  in
  { thing
  | local  = (xm, ym)
  , global = (x + vx', y + vy')
  , angle  = (moduloAngle a', va)
  , sector = (getSector x', getSector y')
  }