module SetPlayersName exposing (setPlayersName)

import Game exposing (Model)
import Dict exposing (get, insert)
import Maybe exposing (withDefault)
import SpaceObject exposing (..)
import Util exposing (elseDummy)

setPlayersName : String -> Model -> Model
setPlayersName newName model =
  let 
    {playerId, localObjects} = model 
  
    player' =
      let
        player =
          get playerId localObjects
          |>elseDummy
      in
      { player | name = newName }
  in
    { model 
    | localObjects =
        insert 
          playerId 
          player' 
          localObjects
    , playerName = newName
    }
