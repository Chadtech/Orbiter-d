module SetThrust exposing (setThrust)

import Types       exposing (..)
import Engine      exposing (..)
import SpaceObject exposing (SpaceObject, SpaceObjects)
import List        exposing (map, foldr, filter)

setThrust: SpaceObject -> SpaceObject
setThrust object =
  let
    {velocity, engine, angle} = object
    {boost, thrusters} = engine
    (a, va) = angle
    --weightFactor = object.weight / 1528

    firingThrusters =
      filter isFiring thrusters

    va' =
      firingThrusters
      |>map (calculateAngularThrust boost)
      |>foldr (+) va

    --angle' =
    --  foldr
    --    calculateAngle
    --    object.angle
  in
  { object
  | velocity = 
      firingThrusters
      |>map (calculateThrust boost a)
      |>foldr sumTuple velocity
  , angle = (a, va')
  }

isFiring : Thruster -> Bool
isFiring thruster = 0 /= thruster.firing

sumTuple : Coordinate -> Coordinate -> Coordinate
sumTuple (x,y) (x', y') = (x + x', y + y')

calculateBoost : Boost -> Coordinate -> Coordinate
calculateBoost boost (vx, vy) =
  if boost then (vx * 5, vy * 5)
  else (vx, vy)

calculateThrust : Boost -> Angle -> Thruster -> Coordinate
calculateThrust boost angle {type'} =
  let
    attenuation = 
      if boost then 5 * power
      else power

    dvx =
      case type' of
        Main        -> -mainsPower * (sin' angle)
        FrontLeft   -> sin' angle
        FrontRight  -> sin' angle

        _ -> 0

    dvy =
      case type' of
        Main       -> mainsPower * (cos' angle)
        FrontLeft  -> -(cos' angle)
        FrontRight -> -(cos' angle)


        _ -> 0

  in (dvx * attenuation, dvy * attenuation)

calculateAngularThrust : Boost -> Thruster -> Float
calculateAngularThrust boost {type'} =
  case type' of
    FrontLeft  -> rotatePower
    FrontRight -> -rotatePower
    _ -> 0


cos' : Angle -> Angle
cos' = cos << degrees

sin' : Angle -> Angle
sin' = sin << degrees

power : Float
power = 0.128

rotatePower : Float
rotatePower = 0.3 * power

mainsPower : Float
mainsPower = 7


