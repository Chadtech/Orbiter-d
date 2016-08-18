module HandleMessageSubmit exposing (handleMessageSubmit)

import Game        exposing (..)
import Types       exposing (..)
import SpaceObject exposing (..)
import Dict        exposing (get)
import Maybe       exposing (withDefault)
import String      exposing (length, slice)
import Util        exposing (elseDummy)

handleMessageSubmit : Model -> Model
handleMessageSubmit model =
  if length model.chatInput > 0 then
    { model
    | chatMessages =
        (makeChatMessage model) :: model.chatMessages
    , chatInput = ""
    }
  else
    model

makeChatMessage : Model -> ChatMessage
makeChatMessage {playerId, chatInput, localObjects} =
  get playerId localObjects
  |>elseDummy
  |> .name
  |>slice 0 8
  |>ChatMessage chatInput