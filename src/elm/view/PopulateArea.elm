module PopulateArea exposing (populateArea)

import SpaceObject      exposing (..)
import Types            exposing (..)
import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)
import Collage          exposing (..)
import Element          exposing (..)
import Transform        exposing (..)
import List             exposing (map, filter)
import Util             exposing (layerer, root)
import RenderObject

populateArea : Player -> SpaceObjects -> Form -> Form
populateArea player objects area =
  let
    nearByObjects =
      let {global, local} = player in
      objects
      |>filter (nearEnough global)
      |>map (adjustPosition global local)
      |>map draw
      |>layerer
  in layerer [ area, nearByObjects ]

nearEnough : Coordinate -> SpaceObject -> Bool
nearEnough (x, y) object =
  let (x', y') = object.global in
  (sqrt ((x - x')^2 + (y - y')^2)) < 300

adjustPosition : Coordinate -> Coordinate -> SpaceObject -> (Coordinate, SpaceObject)
adjustPosition (gx, gy) (lx, ly) object =
  let 
    (x', y') = object.global 
    position = 
      (x' - gx + lx - 300, y' - gy + ly - 300)
  in
  (position, object)

draw : (Coordinate, SpaceObject) -> Form
draw (position, object) =
  let a = fst object.angle in
  RenderObject.draw object
  |>move position
  |>rotate (degrees a)

