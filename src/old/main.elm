import Html             exposing (p, text)
import Html.Attributes  exposing (class)
import Html.App         as App
import Types            exposing (..)
import PageVisibility   exposing (..)
import View             exposing (view)
import Init             exposing (initModel)
import AnimationFrame   exposing (..)
import Keyboard.Extra   as Keyboard
import CollisionHandle  exposing (collisionsHandle)
import Refresh          exposing (refresh)
import HandleKeys       exposing (handleKeys)

main =
  App.program
  { init          = (initModel, Cmd.none) 
  , view          = view
  , update        = update
  , subscriptions = subscriptions
  }

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
  [ Sub.map HandleKeys Keyboard.subscriptions
  , diffs Refresh
  , visibilityChanges Pause
  ]

rate : Time -> Time
rate dt = dt / 240

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of 

    Refresh dt ->
      let {paused, died} = model in
      if (paused || died) then 
        (model, Cmd.none)
      else
        let 
          model' =
            let dt' = rate dt in
            model |>
            (collisionsHandle dt' >> refresh dt')
        in (model', Cmd.none)

    HandleKeys keyMsg ->
      let
        (keys, kCmd) = 
          Keyboard.update keyMsg model.keys
      in
        (handleKeys model keys, Cmd.map HandleKeys kCmd)

    Pause visibility ->
      if visibility == Hidden then
        ({ model | paused = True }, Cmd.none)
      else
        (model, Cmd.none)



