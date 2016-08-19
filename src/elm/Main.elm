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
import Task
import Json.Encode exposing (..)
import Debug

import Util exposing (elseDummy)

rate : Time -> Time
rate dt = dt / 240

backEnd : String
backEnd = "ws://ctuniverse.zrg.cc/ws"

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
    , diffs WebSocketSend
    , WebSocket.listen backEnd WebsocketRecieve
    ]
  else 
    times PopulateFromRandomness

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of 

    WebsocketRecieve json ->
      (handleWebSocketMessage json model, Cmd.none)

    WebSocketSend dt ->
      let sinceLastPost = dt + model.sinceLastPost in
      if sinceLastPost > 200 then
        let
          player =
            Dict.get model.playerId model.localObjects
            |>elseDummy

          playerMsg =
            (object >> encode 0)
            [ (,) 
                "o" <|
                object
                [ ("uuid", string player.uuid)
                , ("owner", string player.owner)
                , ("type", string "Ship")
                , ("name", string player.name)
                , ("global", list [float (fst player.global), float (snd player.global)])
                , ("velocity", list [ float (fst player.velocity), float (snd player.velocity)])
                , ("angle", float (fst player.angle))
                , ("angle_velocity", float (snd player.angle))
                , ("boost", bool (player.engine.boost))
                , ("air", float (player.air))
                , ("fuel", float (player.fuel))
                , ("mass", float (player.mass))
                , ("thrusters", list [])
                ]
            , (,) "messagetype" (string "SpaceObject")
            ]

          --ya = Debug.log "YES" "WOW"

        in
        ({model | sinceLastPost = 0 }, WebSocket.send backEnd playerMsg)
      else
        ({model | sinceLastPost = sinceLastPost}, Cmd.none)

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

    FocusOnChat ->
      ({model | chatInFocus = True}, Cmd.none)

    FocusOnGame ->
      ({model | chatInFocus = False}, Cmd.none)

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







