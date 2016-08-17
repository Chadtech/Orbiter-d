module SetWeight exposing (setWeight)

import SpaceObject exposing (SpaceObject)

setWeight : SpaceObject -> SpaceObject
setWeight object =
  let {fuel, air, missiles} = object in
  { object 
  | mass = (
    fuel / 1.7) + air + 263 + (toFloat missiles * 200)
  }