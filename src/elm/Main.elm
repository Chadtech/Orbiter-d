import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.App         as App
import AnimationFrame   exposing (..)
import Keyboard.Extra   as Keyboard
import Game             exposing (Model)
import Types            exposing (..)
import HandleKeys       exposing (handleKeys)
import View             exposing (view)
import SetPlayersName   exposing (setPlayersName)
import Dict             exposing (toList)
import Time             exposing (inMilliseconds)
import Random           exposing (initialSeed)
import Init             exposing (init)
import List
import String                 exposing (length, slice)
import HandleMessageSubmit    exposing (handleMessageSubmit)
import HandleWebSocketMessage exposing (handleWebSocketMessage)
import Refresh                exposing (refresh)
import WebSocket
import Dom
import Task

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
    [ Sub.map UpdateKeys Keyboard.subscriptions
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
      (refresh (rate dt) model, Cmd.none)

    UpdateKeys keyMsg ->
      let
        (keys, kCmd) = 
          Keyboard.update keyMsg model.keys
      in
        (handleKeys model keys, Cmd.map UpdateKeys kCmd)

    PopulateFromRandomness time ->
      let time' = floor time in
      (init { model | seed = initialSeed time'}, Cmd.none)

    UpdateName string ->
      (setPlayersName string model, Cmd.none)

    CheckForEnter code ->
      if code == 13 then
        (handleMessageSubmit model, Cmd.none)
      else (model, Cmd.none)

    UpdateChatInput string ->
      let 
        is' = is string
        isEnter = is' '\n'
        isSquiggle = is' '`'
      in
      if isEnter || isSquiggle then (model, Cmd.none)
      else
        if (length string) < 45 then
          ({model | chatInput = string}, Cmd.none)
        else 
          (model, Cmd.none)

is : String -> Char -> Bool
is string char =
  String.toList string |> List.any ((==) char)







