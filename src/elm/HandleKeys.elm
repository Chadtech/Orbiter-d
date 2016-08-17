module HandleKeys exposing (handleKeys)

import Keyboard.Extra   exposing (Key)
import Keyboard.Extra   exposing (isPressed)
import Keyboard.Extra   as Keyboard
import Game             exposing (Model)
import Engine           exposing (..)
import Dict             exposing (get, insert)
import List             exposing (map)
import SpaceObject      exposing (..)
import Maybe            exposing (withDefault)
import Init             exposing (makePlayer)

handleKeys : Model -> Keyboard.Model -> Model
handleKeys model keys =
  let 
    {seed, playerId, localObjects, chatInFocus} = model 

    chatInFocus' =
      if isPressed Keyboard.BackQuote keys then
        not chatInFocus
      else
        chatInFocus
  in
  if model.died then
    if isPressed Keyboard.Enter keys then
      let
        (player, seed') =
          makePlayer seed playerId model.playerName
      in
      { model
      | keys = keys
      , localObjects = 
          insert playerId player localObjects
      , focusOn = playerId
      , chatInFocus = chatInFocus'
      , seed = seed'
      , died = False
      } 
    else
      { model | keys = keys }

  else
  { model
  | keys = keys
  , localObjects = 
      if chatInFocus then localObjects
      else
        let
          player = 
            get playerId localObjects
            |>withDefault dummyShip
            |>setEngine keys
        in
          insert playerId player localObjects
  , chatInFocus =
      if isPressed Keyboard.BackQuote keys then
        not chatInFocus
      else
        model.chatInFocus
  }

setEngine : Keyboard.Model -> Player -> Player
setEngine keys player =
  let {engine} = player in
  { player
  | engine =
    { thrusters =
        map (setThruster (player.fuel > 0) keys) engine.thrusters
    , boost = isPressed Keyboard.Shift keys 
    }
  }

setThruster : Bool -> Keyboard.Model -> Thruster -> Thruster
setThruster enoughFuel keys thruster =
  let keyIsPressed = isPressed (thrustersKey thruster) keys in
  if not enoughFuel then { thruster | firing = 0 }
  else
    if keyIsPressed then { thruster | firing = 1 }
    else { thruster | firing = 0 }


thrustersKey : Thruster -> Keyboard.Key
thrustersKey {type'} =
  case type' of
    Main       -> Keyboard.Space
    FrontLeft  -> Keyboard.CharC
    FrontRight -> Keyboard.CharN
    SideLeft   -> Keyboard.CharS
    SideRight  -> Keyboard.CharK
    BackLeft   -> Keyboard.CharE
    BackRight  -> Keyboard.CharU

