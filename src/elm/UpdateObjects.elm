module UpdateObjects exposing (updateObjects)

import Types       exposing (..)
import SpaceObject exposing (SpaceObject, SpaceObjects)
import Dict        exposing (fromList, toList, Dict)
import List        exposing (map)

updateObjects : Time -> Dict String SpaceObject -> Dict String SpaceObject
updateObjects dt objects =
  toList objects
  |>map snd
  |>map (update dt)
  |>map pairWithuuid
  |>fromList

update : Time -> SpaceObject -> SpaceObject
update dt =
  setPosition dt

pairWithuuid : SpaceObject -> (String, SpaceObject)
pairWithuuid object =
  (object.uuid, object)

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