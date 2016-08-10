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
import Dict             exposing (toList)
import CollisionHandle  exposing (collisionsHandle)
import Time exposing (inMilliseconds)
import Random exposing (initialSeed)
import Debug exposing (log)
import List

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
  if model.ready then
    Sub.batch
    [ Sub.map HandleKeys Keyboard.subscriptions
    , diffs Refresh
    ]
  else 
    times PopulateFromRandomness

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of 

    Refresh dt ->
      let
        model' =
          let
            {localObjects, remoteObjects} = model
            dt' = rate dt

            (localObjects', remoteObjects') = 
              collisionsHandle dt' model
          in
          { model
          | localObjects  = updateObjects dt' localObjects'
          , remoteObjects = updateObjects dt' remoteObjects'
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
      --let what = log "WhAT" <| initialSeed <| floor <| inMilliseconds time in
      ({model | ready = True }, Cmd.none)


