module HandleKeys exposing (handleKeys)

import Keyboard.Extra   exposing (Key)
import Keyboard.Extra   exposing (isPressed)
import Keyboard.Extra   as Keyboard
import Game             exposing (Model)
import Engine           exposing (..)
import Dict             exposing (get, insert, Dict)
import List             exposing (map, foldr)
import SpaceObject      exposing (..)
import Maybe            exposing (withDefault)
import Init             exposing (makePlayer)
import SetEngine        exposing (setEngine)
import Util             exposing (modulo, getSector, makeUUID)
import Random           exposing (Seed)

handleKeys : Model -> Keyboard.Model -> Model
handleKeys model keys =
  let 
    model' =
      model
      |>setChatInFocus keys
      |>setKeys keys
  in
    if model.died then
      if isPressed Keyboard.Enter keys then
        resetGame keys model
      else
        model'
    else
      normalConditions keys model'

normalConditions : Keyboard.Model -> Model -> Model
normalConditions keys model =
  let 
    (seed, localObjects) =
      if isPressed Keyboard.CharG keys then
        insertMissile model
      else (model.seed, model.localObjects)
  in
  { model
  | localObjects = 
      if model.chatInFocus then localObjects
      else
        let
          player = 
            get model.playerId localObjects
            |>withDefault dummyShip
            |>setEngine keys
        in
          insert model.playerId player localObjects
  , seed = seed
  }

insertMissile : Model -> (Seed, Dict String SpaceObject)
insertMissile model =
  let
    player =
      get model.playerId model.localObjects
      |>withDefault dummyShip
  in
    if player.missiles > 0 && player.fuel > 0 then
      let
        player' =
          { player 
          | missiles = player.missiles - 1 
          , fuel = player.fuel - 3
          }
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

addObject : SpaceObject -> Dict String SpaceObject -> Dict String SpaceObject
addObject newObject objects =
  insert newObject.uuid newObject objects


setKeys : Keyboard.Model -> Model -> Model
setKeys keys model = { model | keys = keys }

setChatInFocus : Keyboard.Model -> Model -> Model
setChatInFocus keys model =
  let {chatInFocus} = model in
  {model
  | chatInFocus =
      if isPressed Keyboard.BackQuote keys then
        not chatInFocus
      else
        chatInFocus
  }

resetGame : Keyboard.Model -> Model -> Model
resetGame keys model =
  let
    {seed, playerId, playerName, localObjects} = model
    (player, seed') = 
      makePlayer seed playerId playerName
  in
  { model
  | keys = keys
  , localObjects = 
      insert playerId player localObjects
  , focusOn = playerId
  --, chatInFocus = chatInFocus'
  , seed = seed'
  , died = False
  } 


