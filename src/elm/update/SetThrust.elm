module SetThrust exposing (setThrust)

import Types       exposing (..)
import Engine      exposing (..)
import SpaceObject exposing (SpaceObject, SpaceObjects)
import List        exposing (map, foldr, filter)

setThrust: SpaceObject -> SpaceObject
setThrust object =
  let
    {velocity, engine, angle, mass} = object
    {boost, thrusters} = engine
    (a, va)            = angle
    massFactor         = mass / 1528

    firingThrusters =
      filter isFiring thrusters

    calculateThrust' =
      calculateThrust boost a massFactor

    calculateAngularThrust' =
      calculateAngularThrust boost massFactor
  in
  { object
  | velocity = 
      firingThrusters
      |>map calculateThrust'
      |>foldr sumTuple velocity
  , angle =
      firingThrusters
      |>map calculateAngularThrust'
      |>foldr (+) va
      |>(,) a
  }

isFiring : Thruster -> Bool
isFiring thruster = 0 /= thruster.firing

sumTuple : Coordinate -> Coordinate -> Coordinate
sumTuple (x,y) (x', y') = (x + x', y + y')

calculateBoost : Boost -> Coordinate -> Coordinate
calculateBoost boost (vx, vy) =
  if boost then (vx * 5, vy * 5)
  else (vx, vy)

calculateThrust : Boost -> Angle -> Float -> Thruster -> Coordinate
calculateThrust boost angle massFactor {type'} =
  let
    attenuation = 
      if boost then 5 * power / massFactor
      else power / massFactor

    dvx =
      case type' of
        Main        -> -mainsPower * (sin' angle)
        FrontLeft   -> sin' angle
        FrontRight  -> sin' angle
        SideLeft    -> -(cos' angle)
        SideRight   -> cos' angle
        BackLeft    -> -(sin' angle)
        BackRight   -> -(sin' angle)

    dvy =
      case type' of
        Main       -> mainsPower * (cos' angle)
        FrontLeft  -> -(cos' angle)
        FrontRight -> -(cos' angle)
        SideLeft   -> -(sin' angle)
        SideRight  -> sin' angle
        BackLeft   -> cos' angle
        BackRight  -> cos' angle

  in (dvx * attenuation, dvy * attenuation)

calculateAngularThrust : Boost -> Float -> Thruster -> Float
calculateAngularThrust boost massFactor {type'} =
  case type' of
    FrontLeft  -> rotatePower  / massFactor
    FrontRight -> -rotatePower / massFactor
    BackLeft   -> -rotatePower / massFactor
    BackRight  -> rotatePower  / massFactor
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


