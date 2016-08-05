import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.App         as App
import AnimationFrame   exposing (..)
import Keyboard.Extra   as Keyboard
import Game             exposing (Model)
import Types            exposing (..)
import HandleKeys       exposing (handleKeys)
import View             exposing (view)

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
subscriptions model =
  Sub.batch
  [ Sub.map HandleKeys Keyboard.subscriptions
  , diffs Refresh
  ]

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of 

    Refresh dt ->
      (model, Cmd.none)

    HandleKeys keyMsg ->
      let
        (keys, kCmd) = 
          Keyboard.update keyMsg model.keys
      in
        (handleKeys model keys, Cmd.map HandleKeys kCmd)
