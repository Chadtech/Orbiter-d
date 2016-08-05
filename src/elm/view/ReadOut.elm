module ReadOut exposing (readOut)

import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)
import Types            exposing (Msg)
import Game             exposing (Model)
import SpaceObject      exposing (Player)
import Components       exposing (..)
import List             exposing (unzip, map)
import String           exposing (slice, length)


--readOut : Player -> Html Msg
--readOut player =
readOut : Html Msg
readOut =

  --let
  --  (keys, values) = content player
  --in
  div
  [ class "read-out-container" ]
  [ point "READ OUT"]
  --[ point "READ OUT"
  --, column (map point keys)
  --, column (map point values)
  --]