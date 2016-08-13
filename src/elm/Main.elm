import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.App         as App
import AnimationFrame   exposing (..)
import Keyboard.Extra   as Keyboard
import Game             exposing (Model)
import Types            exposing (..)
import HandleKeys       exposing (handleKeys)
import View             exposing (view)
import UpdateObjects    exposing (updateObjects)
import SetPlayersName   exposing (setPlayersName)
import Dict             exposing (toList)
import CollisionHandle  exposing (collisionsHandle)
import Time             exposing (inMilliseconds)
import Random           exposing (initialSeed)
import Init             exposing (init)
import List
import String           exposing (length, slice)
import HandleMessageSubmit exposing (handleMessageSubmit)
import HandleWebSocketMessage exposing (handleWebSocketMessage)
import WebSocket
--import Json.Decode as Json
import Json.Decode exposing (..)
import Debug exposing (log)


rate : Time -> Time
rate dt = dt / 240

main =
  App.program
  { init          = (Game.init, Cmd.none) 
  , view          = view
  , update        = update
  , subscriptions = subscriptions
  }

subscriptions : Model -> Sub Msg
subscriptions {ready} =
  if ready then
    Sub.batch
    [ Sub.map HandleKeys Keyboard.subscriptions
    , diffs Refresh
    , WebSocket.listen "ws://ctuniverse.zrg.cc/ws" WSRecieve
    ]
  else 
    times PopulateFromRandomness

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of 

    WSRecieve json ->
      (handleWebSocketMessage json model, Cmd.none)

    Refresh dt ->
      let
        dt'    = rate dt
        model' =
          let
            {localObjects, remoteObjects} = 
              collisionsHandle dt' model
          in
          { model
          | localObjects  = updateObjects dt' localObjects
          , remoteObjects = updateObjects dt' remoteObjects
          }
      in
      (model', Cmd.none)

    HandleKeys keyMsg ->
      let
        (keys, kCmd) = 
          Keyboard.update keyMsg model.keys
      in
        (handleKeys model keys, Cmd.map HandleKeys kCmd)

    PopulateFromRandomness time ->
      (init model (initialSeed (floor time)), Cmd.none)

    UpdateName string ->
      (setPlayersName string model, Cmd.none)

    CheckForEnter code ->
      if code == 13 then
        (handleMessageSubmit model, Cmd.none)
      else (model, Cmd.none)

    UpdateChatInput string ->
      let 
        l = length string 

        isntEnter =
          slice (l - 1) l string /= "\n"
      in
      if isntEnter then
        if l < 45 then
          ({model | chatInput = string}, Cmd.none)
        else 
          (model, Cmd.none)
      else (model, Cmd.none)










