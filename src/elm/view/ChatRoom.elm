module ChatRoom exposing (..)

import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)
import Types            exposing (..)
import Components       exposing (tinyPoint)
import SpaceObject      exposing (Player)
import Game             exposing (..)
import List             exposing (map, reverse, intersperse)
import Json.Decode as Json


chatroom : Model -> Html Msg
chatroom {chatInput, chatMessages, playerName} =
  div 
  [ class "chat-room-container" ]
  [ nameField playerName 
  , chatMessagesList chatMessages
  , chatInputField chatInput
  ] 

nameField : String -> Html Msg
nameField name =
  input 
  [ value name 
  , placeholder "username"
  , spellcheck False
  , class "name-field"
  , onFocus FocusOnChat
  , onBlur FocusOnGame
  , onInput UpdateName
  ] []

chatMessagesList : List ChatMessage -> Html Msg
chatMessagesList =
  map eachMessage
  >>reverse
  >>intersperse (br [] [])
  >>div [ class "chat-messages" ]

chatInputField : String -> Html Msg
chatInputField input' =
  textarea
  [ id "chat-input-box"
  , value input'
  , class "chat-input" 
  , onFocus FocusOnChat
  , onBlur FocusOnGame
  , onInput UpdateChatInput
  , on "keydown" <| Json.map CheckForEnter keyCode
  , placeholder "chat input"
  , spellcheck False
  ]
  []

eachMessage : ChatMessage -> Html Msg
eachMessage {content, speaker} =
  p 
  [ class "point tiny ignorable" ] 
  [ text (speaker ++ " : " ++ content) ]

  
