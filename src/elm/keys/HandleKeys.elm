module HandleKeys exposing (handleKeys)

import Keyboard.Extra   exposing (Key)
import Keyboard.Extra   exposing (isPressed)
import Keyboard.Extra   as Keyboard
import Game             exposing (Model)
import Engine           exposing (..)
import Dict             exposing (get, insert, Dict)
import SpaceObject      exposing (..)
import Maybe            exposing (withDefault)
import Init             exposing (makePlayer)
import SetEngine        exposing (setEngine)
import Random           exposing (Seed)
import InsertMissile    exposing (insertMissile)
import Util             exposing (elseDummy)

handleKeys : Model -> Keyboard.Model -> Model
handleKeys model keys =
  let 
    model' =
      model
      |>setChatInFocus keys
      |>setBigMap keys
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
      if isPressed Keyboard.CharG keys && (not model.chatInFocus) then
        insertMissile model
      else 
        (model.seed, model.localObjects)
  in
  { model
  | localObjects = 
      if model.chatInFocus then localObjects
      else
        let
          player = 
            get model.playerId localObjects
            |>elseDummy
            |>setEngine keys
        in
          insert model.playerId player localObjects
  , seed = seed
  }


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

setBigMap : Keyboard.Model -> Model -> Model
setBigMap keys model =
  let tIsPressed = isPressed Keyboard.CharT keys in
  { model | bigMapUp = tIsPressed && (not model.chatInFocus)}

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
  , seed = seed'
  , died = False
  } 


