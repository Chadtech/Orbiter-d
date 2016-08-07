module RenderObject exposing (draw)

import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)
import Collage          exposing (..)
import Element          exposing (..)
import List             exposing (filter, map, reverse)
import Pather           exposing (root)
import Types            exposing (..)
import SpaceObject      exposing (..)
import Engine           exposing (..)


draw : SpaceObject -> Form
draw {engine, sprite} =
  let
    {dimensions, area, src} = sprite
    bodySprite = 
      let (w,h) = dimensions in
      image' w h src
    (w, h) = area
    {boost, thrusters} = engine
  in 
    thrusters
    |>filter isFiring
    |>map (drawThruster boost)
    |>(::) bodySprite
    |>reverse
    |>collage w h
    |>toForm

isFiring : Thruster -> Bool
isFiring thruster = 0 /= thruster.firing

blastSource : Boost -> String -> String
blastSource boost source =
  "blasts/" ++
  if boost then source else (source ++ "-weak")

turn : Form -> Form
turn = rotate (degrees 180)

drawThruster : Boost -> Thruster -> Form
drawThruster boost {type'} =
  let src' = blastSource boost in
  case type' of
    Main ->
      thruster (11, 30) (0, -30) (src' "main")
    FrontLeft ->
      thruster (2, 9) (-19, 9) (src' "yaw")
    FrontRight ->
      thruster (2, 9) (20, 9) (src' "yaw-f")
      |>scale -1 >> turn
    SideLeft ->
      thruster (8, 3) (26, -1) (src' "strafe")
      |>turn
    SideRight ->
      thruster (8, 3) (-25, -1) (src' "strafe")
    BackLeft ->
      thruster (2, 9) (-19, -9) (src' "yaw-f")
      |>scale -1
    BackRight ->
      thruster (2, 9) (20, -9) (src' "yaw")
      |>turn

image' : Int -> Int -> String -> Form
image' w h src = 
  root src |> image w h |> toForm

thruster : Dimensions -> Coordinate -> String -> Form
thruster (w, h) position source =
  move position <| image' w h source