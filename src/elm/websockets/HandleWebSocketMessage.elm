module HandleWebSocketMessage exposing (handleWebSocketMessage)

import Json.Decode exposing (..)
import Game exposing (..)
import Debug exposing (log)


handleWebSocketMessage : String -> Model -> Model
handleWebSocketMessage json model =
  let
    messageType = 
      decodeString getMessageType json
      |>log "messagetype"
  in
    model

getMessageType : Decoder String
getMessageType =
  object1 identity ("messagetype" := string)




--messageDecode : Decoder (String, Float)
--messageDecode =
--  "o" := (object2 (,) ("uuid" := string) ("global_x" := float))
--  |>object1 identity

----nameAndAge : Decoder (String,Int)
----nameAndAge =
----    object2 (,)
----      ("name" := string)
----      ("age" := int)