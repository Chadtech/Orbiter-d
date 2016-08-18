module BigMap exposing (bigMap)

import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)
import Collage          exposing (..)
import Element          exposing (..)
import Transform        exposing (..)
import Types            exposing (Msg, Coordinate)
import SpaceObject      exposing (SpaceObject, SpaceObjects, Player)
import List             exposing (append, map, maximum)
import Util             exposing (root)
import Maybe            exposing (withDefault)
import Debug exposing (log)

bigMap : Player -> SpaceObjects -> Html Msg
bigMap {global} objects =
  div
  [ class "big-map-container" ]
  [ append
    [ "celestia/real-stars"
      |>image' 240 189
      |>alpha 0.2
      |>rotate (degrees 0)
      |>move (-50, 0)
    , "markers/ring"
      |>image' 15 15
      |>move (position global)
    , "celestia/planet"
      |>image' 45 45
    ]
    (map draw objects)
    |>collage 600 600 
    |>toHtml
  ]

position : Coordinate -> Coordinate
position (x,y) =
  ((x * 0.005) - 300, (y * 0.005) - 300)

draw : SpaceObject -> Form
draw {sprite, angle, global} =
  let
    (w,h) = sprite.dimensions
    w'    = if 1 > w // 3 then 1 else w // 3
    h'    = if 1 > h // 3 then 1 else h // 3
    a     = fst angle
  in
  sprite.src
  |>image' w' h'
  |>rotate (degrees a)
  |>move (position global)

image' : Int -> Int -> String -> Form
image' w h src = 
  root src |> image w h |> toForm


