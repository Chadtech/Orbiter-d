module MiniMap exposing (miniMap)

import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)
import Collage          exposing (..)
import Element          exposing (..)
import Transform        exposing (..)
import Types            exposing (..)
import List             exposing (append, map)
import Pather           exposing (root)

miniMap : Model -> Html Msg
miniMap m =
  let (x, y) = m.ship.global in
  div
  [ class "mini-map-container" ]
  [ append
    [ "celestia/real-stars"
      |>image' 80 63
      |>alpha 0.2
      |>rotate (degrees 0)
      |>move (-50, 0)
    , "markers/ring"
      |>image' 5 5
      |>move (p x, p y)
    , "celestia/planet"
      |>image' 15 15
      |>move (p 60000, p 60000)
    ]
    (map drawThing m.things)
    |>collage 222 222 
    |>toHtml
  ]

drawThing : Thing -> Form
drawThing t =
  let 
    (x,y) = t.global 
    (w,h) = t.sprite.dimensions
    a = fst t.angle
  in
  t.sprite.src
  |>image' (w // 10) (h // 10)
  |>rotate (degrees a)
  |>move (p x, p y)

-- position in map 
p : Float -> Float
p f = (f * 0.00185) - 111

image' : Int -> Int -> String -> Form
image' w h src = 
  root src |> image w h |> toForm