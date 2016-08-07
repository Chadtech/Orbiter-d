module UpdateObjects exposing (updateObjects)

import Types       exposing (..)
import SpaceObject exposing (SpaceObject, SpaceObjects)
import Dict        exposing (fromList, toList, Dict)
import List        exposing (map)
import SetPosition exposing (setPosition)
import SetThrust   exposing (setThrust)

updateObjects : Time -> Dict String SpaceObject -> Dict String SpaceObject
updateObjects dt objects =
  toList objects
  |>map snd
  |>map (update dt)
  |>map pairWithuuid
  |>fromList

update : Time -> SpaceObject -> SpaceObject
update dt =
  setThrust
  >>setPosition dt

pairWithuuid : SpaceObject -> (String, SpaceObject)
pairWithuuid object =
  (object.uuid, object)
