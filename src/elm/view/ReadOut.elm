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
    (keys, values) = content player
  in
  div
  [ class "read-out-container" ]
  [ column (map point keys)
  , column (map point values)
  ]

column : List (Html Msg) -> Html Msg
column list =
  div [ class "read-out-column" ] list

content : Player -> (List String, List String)
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
  [ "READ OUT"  . name'
  , "--------"  . "--------"
  , "STATUS"    . "NOMINAL"
  , "--inv"     . "--------"
  , "FUEL"      . ((nf 6 (oneDecimal fuel))   ++ "l")
  , "AIR"       . ((nf 6 (oneDecimal air)) ++ "l")
  , "POWER"     . "unavaila"
  , "MASS"      . ((nf 6 (oneDecimal mass)) ++ " yH")
  , "MISSILES"  . (toString missiles)
  , "--pos"     . "--------"
  , "rpms "     . (nf 4 (-va * (10/9)))
  , "dir"       . (angleFormat (direction / pi * 200))
  , ": angle"   . (angleFormat (-a / 0.9))
  , ": x"       . toString (sx - 100)
  , ": y"       . toString (sy - 100)
  ]

(.) = (,)

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
