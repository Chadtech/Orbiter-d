module CollisionHandle exposing (collisionsHandle)

import Collision exposing (..)
import Types     exposing (..)
import List      exposing (maximum, map, map2, concat, filter, isEmpty, foldr, append)
import Maybe     exposing (withDefault)


dot : Pt -> Pt -> Float
dot (x1,y1) (x2,y2) = (x1*x2) + (y1*y2)

polySupport : List Pt -> Pt -> Pt
polySupport list d =
  let
    dotList = map (dot d) list
    decorated = map2 (,) dotList list
    (m, point) = 
      maximum decorated
      |>withDefault (0,(0,0))
  in point

smear : Pt -> Pt -> List Pt
smear (x', y') (x, y) = 
  [ (x, y), (x + x', y + y') ]

place : Pt -> Pt -> Pt
place (gx, gy) (x, y) =
  (x + gx, y + gy)

travel : Float -> Pt -> (Pt -> List Pt)
travel a dest =
  toPolar
  >>rotatePoint a
  >>fromPolar
  >>smear dest

toPolygon : Float -> Pt -> Pt -> List Pt -> List Pt
toPolygon angle center destination points =
  points
  |>map (travel angle destination) 
  |>concat
  |>map (place center)

getThingsPolygon : Float -> Pt -> Pt -> Thing -> List Pt
getThingsPolygon dt (svx, svy) (sgx, sgy) t =
  let 
    (w', h') = t.dimensions 
    w = toFloat w'
    h = toFloat h'
    (gx, gy) = t.global
    (a, va) = t.angle
    (vx, vy) = t.velocity
    vx' = dt * vx
    vy' = dt * vy
  in
  toPolygon
  (a + va)
  (gx - sgx + vx' - svx, gy - sgy + vy' - svy)
  (vx' - svx, vy' - svy)
  [ (w/2, h/2)
  , (w/2, -h/2)
  , (-w/2, -h/2)
  , (-w/2, h/2)
  ]

getShipsPolygon : Ship -> List Pt
getShipsPolygon {angle, dimensions} =
  let 
    (w', h') = dimensions 
    w = toFloat w'
    h = toFloat h'
    (a, va) = angle
  in
  rotatePoints (a + va)
  [ (w/2, h/2)
  , (w/2, -h/2)
  , (-w/2, -h/2)
  , (-w/2, h/2)
  ]

rotatePoint : Angle -> (Float, Angle) -> (Float, Angle)
rotatePoint a' (r, a) = (r, a + a')

rotatePoints : Angle -> List Pt -> List Coordinate
rotatePoints a' =
  map (toPolar >> rotatePoint a' >> fromPolar)

didCollide : Time -> Ship -> Thing -> (Bool, Thing)
didCollide dt ship thing = 
  let
    (svx, svy) = ship.velocity

    collided =
      let
        thingsPolygon = 
          getThingsPolygon
            dt
            (svx * dt, svy * dt)
            ship.global
            thing

        shipsPolygon =
          getShipsPolygon ship
      in 
      collision 10 
        (thingsPolygon, polySupport)
        (shipsPolygon, polySupport)

  in (collided, thing)

appendIfNotCollided : (Bool, Thing) -> Things -> Things
appendIfNotCollided (b, t) things =
  if b then things
  else append things [t]

justThings : (Bool, Thing) -> Bool
justThings (b, t) = b

collisionsHandle : Time -> Model -> Model
collisionsHandle dt model =
  let
    {ship, things} = model
    collisionCheck = 
      map (didCollide dt ship) things 

    collidedThings = 
      filter justThings collisionCheck
  in
  if isEmpty collidedThings then model
  else
  { model
  | ship = 
      foldr
        .onCollision
        ship
        (map snd collidedThings)
  , things =
      foldr
        appendIfNotCollided
        []
        collisionCheck
  }










