module ReadOut exposing (readOut)

import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)
import Types            exposing (Msg)
import Game             exposing (Model)
import SpaceObject      exposing (Player)
import Components       exposing (..)
import List             exposing (unzip, map)
import String           exposing (slice, length)


readOut : Player -> Html Msg
readOut player =
  let
    (left, right) = content player
  in
  div
  [ class "read-out-container" ]
  [ column left
  , column right
  ]

column : List (Html Msg) -> Html Msg
column list =
  div [ class "read-out-column" ] list

content : Player -> (List (Html Msg), List (Html Msg))
content player =
  let 
    (x,y)    = player.global 
    (sx, sy) = player.sector
    (a, va)  = player.angle
    (vx, vy) = player.velocity

    {fuel, air, mass, missiles, direction, name} = 
      player

    name' =
      if (length name) > 0 then
        slice 0 8 name
      else
        "NO NAME!"
  in
  unzip
  [ ( ignorablePoint "READ OUT"  , ignorablePoint name')
  , ( ignorablePoint "--------"  , ignorablePoint "--------" )
  , status player
  , ( ignorablePoint "--inv"     , ignorablePoint "--------" )
  , ( ignorablePoint "FUEL"      , ignorablePoint ((nf 6 (oneDecimal fuel))   ++ "l"))
  , ( ignorablePoint "AIR"       , ignorablePoint ((nf 6 (oneDecimal air)) ++ "l"))
  , ( ignorablePoint "POWER"     , ignorablePoint "unavaila")
  , ( ignorablePoint "MASS"      , ignorablePoint ((nf 6 (oneDecimal mass)) ++ " yH") )
  , ( ignorablePoint "MISSILES"  , ignorablePoint (toString missiles) )
  , ( ignorablePoint "--pos"     , ignorablePoint "--------" )
  , ( ignorablePoint "rpms "     , ignorablePoint (nf 4 (-va * (10/9))) )
  , ( ignorablePoint "dir"       , ignorablePoint (angleFormat (direction / pi * 200)) )
  , ( ignorablePoint ": angle"   , ignorablePoint (angleFormat (-a / 0.9)) )
  , ( ignorablePoint ": x"       , ignorablePoint (toString (sx - 100)) )
  , ( ignorablePoint ": y"       , ignorablePoint (toString (sy - 100)) )
  ]

status : Player -> (Html Msg, Html Msg)
status player =
  if 40 > player.air then 
    if 0 >= player.air then
      (criticalPoint "STATUS", criticalPoint "NO AIR")
    else
      (blinkingPoint "STATUS", blinkingPoint "LOW AIR")
  else
  if 300 > player.fuel then 
    if 0 >= player.fuel then
      (criticalPoint "STATUS", criticalPoint "NO FUEL")
    else
      (blinkingPoint "STATUS", blinkingPoint "LOW FUEL")
  else 
    (ignorablePoint "NOMINAL", ignorablePoint "NOMINAL")



angleFormat : Float -> String
angleFormat =
  round 
  >>toFloat 
  >>nf 5 
  >>pad
  >>(\s -> s ++ "/200")

pad : String -> String
pad string =
  if length string >= 4 then string
  else pad (string ++ "_")

-- Number Format
nf : Int -> Float -> String
nf i f = 
  let s = toString f in
  if length s > i then slice 0 i s 
  else s

oneDecimal : Float -> Float
oneDecimal f = (toFloat (round (f * 10))) / 10
