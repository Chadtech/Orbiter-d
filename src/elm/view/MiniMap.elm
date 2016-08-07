module MiniMap exposing (miniMap)

import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)
import Collage          exposing (..)
import Element          exposing (..)
import Transform        exposing (..)
import Types            exposing (Msg, Coordinate)
import SpaceObject      exposing (SpaceObject, SpaceObjects, Player)
import List             exposing (append, map)
import Pather           exposing (root)

miniMap : Player -> SpaceObjects -> Html Msg
miniMap {global} objects =
  div
  [ class "mini-map-container" ]
  [ append
    [ "celestia/real-stars"
      |>image' 80 63
      |>alpha 0.2
      |>rotate (degrees 0)
      |>move (-50, 0)
    , "markers/ring"
      |>image' 5 5
      |>move (position global)
    , "celestia/planet"
      |>image' 15 15
    ]
    (map draw objects)
    |>collage 222 222 
    |>toHtml
  ]

position : Coordinate -> Coordinate
position (x,y) =
  ((x * 0.00185) - 111, (y * 0.00185) - 111)

draw : SpaceObject -> Form
draw {sprite, angle, global} =
  let
    (w,h) = sprite.dimensions
    a     = fst angle
  in
  sprite.src
  |>image' (w // 10) (h // 10)
  |>rotate (degrees a)
  |>move (position global)

image' : Int -> Int -> String -> Form
image' w h src = 
  root src |> image w h |> toForm