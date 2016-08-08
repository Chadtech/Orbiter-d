module UpdateObjects exposing (updateObjects)

import Types       exposing (..)
import SpaceObject exposing (SpaceObject, SpaceObjects)
import Dict        exposing (fromList, toList, Dict)
import List        exposing (map)
import SetPosition exposing (setPosition)
import SetThrust   exposing (setThrust)
import SetGravity  exposing (setGravity)
import SetWeight   exposing (setWeight)
import Consumption exposing (consumeAir, consumeFuel)

updateObjects : Time -> Dict String SpaceObject -> Dict String SpaceObject
updateObjects dt objects =
  toList objects
  |>map snd
  |>map (update dt)
  |>map pairWithuuid
  |>fromList

update : Time -> SpaceObject -> SpaceObject
update dt =
  consumeAir dt
  >>consumeFuel dt
  >>setWeight
  >>setThrust
  >>setGravity dt
  >>setPosition dt



pairWithuuid : SpaceObject -> (String, SpaceObject)
pairWithuuid object =
  (object.uuid, object)
