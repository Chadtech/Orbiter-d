module HandlePhysics exposing (handlePhysics, physics)

import Types       exposing (..)
import SpaceObject exposing (SpaceObject, SpaceObjects)
import Dict        exposing (fromList, values, Dict)
import List        exposing (map)
import SetPosition exposing (setPosition)
import SetThrust   exposing (setThrust)
import SetGravity  exposing (setGravity)
import SetWeight   exposing (setWeight)
import Consumption exposing (consumeAir, consumeFuel)
import Util        exposing (bundle)
import Game        exposing (Model)

handlePhysics : Time -> Model -> Model
handlePhysics dt model =
  let {localObjects, remoteObjects} = model in
  { model
  | localObjects = applyPhysics dt localObjects
  , remoteObjects = applyPhysics dt remoteObjects
  }

applyPhysics : Time -> Dict String SpaceObject -> Dict String SpaceObject
applyPhysics dt objects =
  values objects
  |>map (physics dt)
  |>map bundle
  |>fromList

physics : Time -> SpaceObject -> SpaceObject
physics dt =
  consumeAir dt
  >>consumeFuel dt
  >>setWeight
  >>setThrust
  >>setGravity dt
  >>setPosition dt

