module ShipPosition exposing (shipPosition)

import Types exposing (..)
import Debug exposing (log)

modulo : Float -> Float
modulo f =
  let 
    f' = round f 
    m = (toFloat (f' % 600)) + (f - (toFloat f'))
  in
  if m > 300 then m - 600 else m

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

axisCrosses : (Float, Float) -> Int
axisCrosses (p, f) =
  if (p > 0) /= (f > 0) then 
    ((f // 600) + 1) * (abs f // f)
  else 0

setQuadrant : Coordinate -> Quadrant
setQuadrant (x, y) =
  if x > 0 then
    if y > 0 then B else D
  else
    if y > 0 then A else C

shipPosition : Time -> Ship -> Ship
shipPosition dt ship =
  let 
    (gx, gy) = ship.global
    (lx, ly) = ship.local
    (vx, vy) = ship.velocity
    (sx, sy) = ship.sector
    (a, va)  = ship.angle

    vy' = dt * vy
    vx' = dt * vx

    gx' = gx + vx'
    gy' = gy + vy'

    gym = modulo gy'
    gxm = modulo gx'

    
    dsy = 
      axisCrosses
      (ly, ly + vy')
    
    dsx = 
      axisCrosses
      (lx, lx + vx')

    a' = 
      moduloAngle (a + (dt * va))
  in
  { ship
  | local    = (gxm, gym)
  , global   = (gx', gy')
  , angle    = (a', va)
  , sector   = (sx + dsx, sy + dsy)
  , quadrant = setQuadrant (gxm, gym)
  , dir      = atan2 vx vy
  } 

