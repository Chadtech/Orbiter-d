module ReadOut exposing (readOut)

import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)
import Types            exposing (..)
import Components       exposing (..)
import List             exposing (unzip, map)
import String           exposing (slice, length)


readOut : Ship -> Html Msg
readOut s =
  let
    (keys, values) = content s
  in
  div
  [ class "read-out-container" ]
  [ point "READ OUT"
  , column (map point keys)
  , column (map point values)
  ]

column : List (Html Msg) -> Html Msg
column list =
  div [ class "read-out-column" ] list

content : Ship -> (List String, List String)
content s =
  let 
    (x,y)    = s.global 
    (sx, sy) = s.sector
    (a, va)  = s.angle
    (vx, vy) = s.velocity
  in
  unzip
  [ "--------"  . "--------"
  , "STATUS"    . "NOMINAL"
  , "--------"  . "--------"
  , "FUEL"      . ((nf 6 (oneDecimal s.fuel))   ++ "l")
  , "AIR"       . ((nf 6 (oneDecimal s.oxygen)) ++ "l")
  , "POWER"     . "unavaila"
  , "MASS"      . ((nf 6 (oneDecimal s.weight)) ++ " yH")
  , "--------"  . "--------"
  , "rpms "     . (nf 4 (-va * (10/9)))
  --, "speed"     . nf 8 ((sqrt (vx^2 + vy^2))/10)
  , "dir"       . (angleFormat (s.dir / pi * 200))
  , "POSITION"  . "--------"
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
