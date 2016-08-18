module InsertMissile exposing (insertMissile)

import Keyboard.Extra   exposing (Key)
import Keyboard.Extra   exposing (isPressed)
import Keyboard.Extra   as Keyboard
import Game             exposing (Model)
import Engine           exposing (..)
import Dict             exposing (get, insert, Dict)
import List             exposing (foldr)
import SpaceObject      exposing (..)
import Maybe            exposing (withDefault)
import Util             exposing (modulo, getSector, makeUUID)
import Random           exposing (Seed)
import Util             exposing (addObject, elseDummy)


insertMissile : Model -> (Seed, Dict String SpaceObject)
insertMissile model =
  let
    player =
      get model.playerId model.localObjects
      |>elseDummy
  in
    if player.missiles > 0 then
      let
        player' =
          { player | missiles = player.missiles - 1 }
        (missile, seed) =
          makeMissile model.seed player' 
      in
        (seed, foldr addObject model.localObjects [ player', missile ])
    else
      (model.seed, model.localObjects)

makeMissile : Seed -> Player -> (SpaceObject, Seed)
makeMissile seed player =
  let
    (x, y) = player.global
    a = fst player.angle

    dx = -50 * sin (degrees a)
    dy = 50 * cos (degrees a)

    x' = x + dx
    y' = y + dy

    (uuid, seed') = makeUUID seed
  in
  (,)
  { angle     = player.angle
  , global    = (x', y')
  , local     = (modulo x', modulo y')
  , velocity  = player.velocity
  , sector    = (getSector x', getSector y')
  , direction = 0
  , dimensions = (5, 14)
  , fuel     = 3
  , air      = 0
  , mass     = 200
  , missiles = 0
  , type'    = Missile
  , name     = "missile"
  , uuid    = uuid
  , owner   = player.uuid
  , engine  = 
    { boost = True
    , thrusters = [ {type' = MissileMain, firing = 1 } ]
    }
  , sprite =
    { src        = "stuff/missile"
    , dimensions = (5, 14)
    , area       = (5, 42)
    , position   = (0,0)
    }
  , remove = False
  , explode = False
  }
  seed'