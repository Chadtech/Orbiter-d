module NavMarkers exposing (navMarkers)

import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)
import Types            exposing (..)
import SpaceObject      exposing (..)
import Collage          exposing (..)
import Element          exposing (..)
import Transform        exposing (..)
import List             exposing (filter, map, concat, append)
import Pather           exposing (root)

navMarkers : Player -> SpaceObjects -> Html Msg
navMarkers player objects =
  let
    {direction, angle} = player
    (a, va) = angle
    defaultMarkers =
      [ northMarker
      , directionMarker direction
      ]
  in
  objectMarkers player objects
  |>append defaultMarkers
  |>collage 600 600
  |>toForm
  |>rotate (degrees -a)
  |>listify
  |>collage 600 600
  |>container

objectMarkers : Player -> SpaceObjects -> List Form
objectMarkers player objects =
  objects
  |>filter (nearEnough player.global)
  |>map (draw player)

nearEnough : Coordinate -> SpaceObject -> Bool
nearEnough (x, y) object =
  let 
    (x', y') = object.global 
    dist = sqrt ((x - x')^2 + (y - y')^2)
  in dist < 12000 && 300 < dist

draw : Player -> SpaceObject -> Form
draw player object =
  let
    (pvx, pvy) = player.velocity
    (ovx, ovy) = object.velocity
    
    rvx = pvx - ovx
    rvy = pvy - ovy

    rv = sqrt (rvx^2 + rvy^2)

    direction = atan2 rvx rvy

    (px, py) = player.global
    (ox, oy) = object.global

    rx = px - ox
    ry = py - oy

    position = atan2 rx ry
    x = (sin position) * -r
    y = (cos position) * -r

    markerType =
      if rv > 150 then "urgent" else
      if rv > 75 then "highlight" else "normal"

  in
  "markers/thing-" ++ markerType
  |>marker
  |>move (x, y)
  |>rotate (pi - direction)

container : Element -> Html Msg
container child =
  div
  [ class "nav-markers" ]
  [ toHtml child ]

directionMarker : Float -> Form
directionMarker dir =
  "markers/direction"
  |>marker
  |>move ((sin dir) * r, (cos dir) * r)
  |>rotate -dir

northMarker : Form
northMarker = 
  "markers/north"
  |>marker
  |>move (0, r)

marker : String -> Form
marker src = 
  root src |> image 20 20 |> toForm

r : Float
r = 290

listify : Form -> List Form
listify f = [f]