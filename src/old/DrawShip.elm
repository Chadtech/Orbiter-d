module DrawShip exposing (drawShip)

import Collage          exposing (..)
import Element          exposing (..)
import Types            exposing (..)
import List             exposing (foldr, append)
import Debug            exposing (log)
import Pather           exposing (root)

drawShip : Bool -> Thrusters -> Form
drawShip enoughFuel t =
  let
    shipSprite =
      [ image' 47 47 (root "ship/ship") ]     
    shipRendering =
      if enoughFuel then
      [ mainThruster t.main       t.boost
      , leftFront    t.leftFront  t.boost
      , leftBack     t.leftBack   t.boost
      , leftSide     t.leftSide   t.boost
      , rightFront   t.rightFront t.boost
      , rightBack    t.rightBack  t.boost
      , rightSide    t.rightSide  t.boost
      , shipSprite
      ]
      else
      [ shipSprite ]
  in
  shipRendering
  |>foldr append []
  |>collage 138 138
  |>toForm

image' : Int -> Int -> String -> Form
image' w h src = image w h src |> toForm

drawThruster : Dimensions -> Coordinate -> String -> Form
drawThruster (w, h) p str =
  move p <| image' w h str

transform : Int -> List (Form -> Form) -> Form -> List Form
transform f tfs thruster =
  foldr (\b -> \a -> b a) thruster tfs |> isFiring f

turn : Form -> Form
turn = rotate (degrees 180)

isFiring : Int -> Form -> List Form
isFiring i f = if i > 0 then [f] else []

srcBlast : Bool -> String -> String
srcBlast b str =
  if b then root str
  else root (str ++ "-weak")

mainThruster : Int -> Bool -> List Form
mainThruster firing boost =
  srcBlast boost "blasts/main"
  |>drawThruster (11, 30) (0, -30)
  |>transform firing []

leftFront : Int -> Bool -> List Form
leftFront firing boost =
  srcBlast boost "blasts/yaw"
  |>drawThruster (2, 9) (-19, 9)
  |>transform firing []

leftBack : Int -> Bool -> List Form
leftBack firing boost =
  srcBlast boost "blasts/yaw-f"
  |>drawThruster (2, 9) (-19, -9)
  |>transform firing [ scale -1]

leftSide : Int -> Bool -> List Form
leftSide firing boost =
  srcBlast boost "blasts/strafe"
  |>drawThruster (8, 3) (26, -1) 
  |>transform firing [ turn ]

rightFront : Int -> Bool -> List Form
rightFront firing boost =
  srcBlast boost "blasts/yaw-f"
  |>drawThruster (2, 9) (20, 9)
  |>transform firing [ scale -1, turn ]

rightBack : Int -> Bool -> List Form
rightBack firing boost =
  srcBlast boost "blasts/yaw"
  |>drawThruster (2, 9) (20, -9)
  |>transform firing [ turn ]

rightSide : Int -> Bool -> List Form
rightSide firing boost =
  srcBlast boost "blasts/strafe"
  |>drawThruster (8, 3) (-25, -1) 
  |>transform firing []

