module GameScope exposing (gameScope)

import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)
import Collage          exposing (..)
import Element          exposing (..)
import Transform        exposing (..)
import List             exposing (filter, map)
import Pather           exposing (root)
import Types            exposing (..)
import SpaceObject      exposing (..)
import RenderObject     exposing (draw)
import PopulateArea     exposing (populateArea)

gameScope : Player -> SpaceObjects -> Html Msg
gameScope player objects =
  [ layerer 
    [ area
      |>populateArea   player objects
      |>positionArea   player
      |>backdropGalaxy player
      |>backdropStars  player
      |>rotateArea     player
    , draw player
    ]
  ]
  |>collage 600 600 >> toHtml

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

layerer : List Form -> Form
layerer = toForm << collage 1200 1200

image' : Int -> Int -> String -> Form
image' w h src = 
  root src |> image w h |> toForm

  --p [ class "point" ] [ Html.text "COOOOLLL" ]

