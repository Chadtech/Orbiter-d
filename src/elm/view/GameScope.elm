module GameScope exposing (gameScope)

import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)
import Collage          exposing (..)
import Element          exposing (..)
import Transform        exposing (..)
import List             exposing (filter, map)
import Types            exposing (..)
import SpaceObject      exposing (..)
import RenderObject     exposing (draw)
import PopulateArea     exposing (populateArea)
import Util             exposing (layerer, root, image')

gameScope : Player -> SpaceObjects -> Html Msg
gameScope player objects =
  (collage 600 600 >> toHtml)
  [ layerer 
    [ area
      |>populateArea   player objects
      |>positionArea   player
      |>backdropGalaxy player
      |>backdropStars  player
      |>rotateArea     player
    , sky player.global
    , draw player
    ]
  ]

sky : Coordinate -> Form
sky (x,y) =
  let 
    transparency = 
      let 
        x'   = x - 60000
        y'   = y - 60000
        dist = sqrt (x'^2 + y'^2) 
      in
      if dist > 8000 then 0
      else (8000 - dist) / 4000
  in
  "celestia/sky"
  |>image' 601 601
  |>alpha transparency

rotateArea : Player -> Form -> Form
rotateArea {angle} area =
  let a = fst angle in
  layerer [ rotate (degrees -a) area ]

backdropStars : Player -> Form -> Form
backdropStars {global} area =
  let
    (x,y) = global
    x'    = modulo 600 (x / 30)
    y'    = modulo 600 (y / 30)
    pos   = (300 - x', 300 - y')
  in
  layerer
  [ layerer
    [ smallStars (-300, 300) 
    , smallStars (300, 300)  
    , smallStars (300, -300) 
    , smallStars (-300, -300)
    ]|> move pos |> alpha 0.8 
    , area
  ]

modulo : Int -> Float -> Float
modulo m f =
  let f' = floor f in
  (toFloat (f' % m)) + (f - (toFloat f'))

backdropGalaxy : Player -> Form -> Form
backdropGalaxy {global} area =
  let
    (x,y) = global
    x' = (-x * 0.005) + 100
    y' = (-y * 0.005) + 275
  in
  layerer
  [ "celestia/real-stars" 
    |>image' 320 250
    |>alpha 0.2
    |>move (x', y')
  , area
  ]

positionArea : Player -> Form -> Form
positionArea {local} area = 
  let (x,y) = local in
  layerer [ move (300 - x, 300 - y) area ]

area : Form
area = 
  layerer
  [ stars (-300, 300)  -- A
  , stars (300, 300)   -- B
  , stars (300, -300)  -- C
  , stars (-300, -300) -- D
  ]

stars : Coordinate -> Form
stars pos = 
  "celestia/stars-1"
  |>image' 601 601
  |>move pos

smallStars : Coordinate -> Form
smallStars pos = 
  "celestia/smaller-stars"
  |>image' 601 601
  |>move pos

