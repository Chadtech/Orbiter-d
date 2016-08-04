module SetWeight exposing (setWeight)

import Types exposing (Ship)

setWeight : Ship -> Ship
setWeight ship =
  let {fuel, oxygen} = ship in
  { ship | weight = (fuel / 1.7) + (oxygen * 3) + 263 }