module NavMarkers exposing (navMarkers)

import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)
import Types            exposing (..)
import Collage          exposing (..)
import Element          exposing (..)
import Transform        exposing (..)
import List             exposing (filter, map, concat, append)
import Pather           exposing (root)
import Debug            exposing (log)


navMarkers : Model -> Html Msg
navMarkers m =
  let
    s = m.ship
    markers =
      append
      [ northMarker
      , directionMarker s.dir
      ]
      <|thingMarkers m
    a = fst s.angle
  in
  markers
  |>collage 600 600
  |>toForm
  |>rotate (degrees -a)
  |>listify
  |>collage 600 600 
  |>container

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

thingMarkers : Model -> List Form
thingMarkers m =
  m.things
  |>filter (nearEnough m.ship.global)
  |>map (drawThing m.ship)

drawThing : Ship -> Thing -> Form
drawThing s t =
  let 
    (svx, svy) = s.velocity
    (tvx, tvy) = t.velocity
    rvx = svx - tvx
    rvy = svy - tvy
    rv  = sqrt ((rvx^2) + (rvy^2))
    dir = atan2 rvx rvy

    (sgx, sgy) = s.global
    (gx, gy)   = t.global
    dx = sgx - gx
    dy = sgy - gy

    pos  = atan2 dx dy
    x    = (sin pos) * -r
    y    = (cos pos) * -r

    markerType =
      if rv < 80 then
        if rv < 40 then "normal"
        else "highlight"
      else "urgent"
  in
  "markers/thing-" ++ markerType
  |>marker
  |>move (x, y)
  |>rotate (pi - dir)

nearEnough : Coordinate -> Thing -> Bool
nearEnough (sgx,sgy) t =
  let
    (gx, gy) = t.global
    dx = sgx - gx
    dy = sgy - gy
    dist = sqrt ((dx^2) + (dy^2))
  in 
  dist < 12000 && 300 < dist

marker : String -> Form
marker src = 
  root src |> image 20 20 |> toForm

r : Float
r = 290

listify : Form -> List Form
listify f = [f]


