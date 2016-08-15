module CollisionHandle exposing (collisionsHandle)

import Collision   exposing (..)
import Types       exposing (..)
import SpaceObject exposing (..)
import Game        exposing (Model)
import List        exposing (maximum, map, map2, concat, filter, isEmpty, foldr, append)
import Dict        exposing (get, insert, union, values, fromList)
import Maybe       exposing (withDefault)
import Debug exposing (log)


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

getObjectsPolygon : Float -> Pt -> Pt -> SpaceObject -> List Pt
getObjectsPolygon dt (svx, svy) (sgx, sgy) t =
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
    (a + (va * dt))
    (gx - sgx + vx' - svx, gy - sgy + vy' - svy)
    (vx' - svx, vy' - svy)
    [ (w/2, h/2)
    , (w/2, -h/2)
    , (-w/2, -h/2)
    , (-w/2, h/2)
    ]

getPlayersPolygon : Time -> Player -> List Pt
getPlayersPolygon dt {angle, dimensions} =
  let 
    (w', h') = dimensions 
    w = toFloat w'
    h = toFloat h'
    (a, va) = angle
  in
  rotatePoints (a + (va * dt))
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

didCollide : Time -> Player -> SpaceObject -> (Bool, SpaceObject)
didCollide dt player object =
  if player.uuid == object.uuid then (False, object)
  else
    let
      (svx, svy) = player.velocity

      collided =
        let
          objectsPolygon = 
            getObjectsPolygon
              dt
              (svx * dt, svy * dt)
              player.global
              object

          playersPolygon =
            getPlayersPolygon dt player
        in 
        collision 10 
          (objectsPolygon, polySupport)
          (playersPolygon, polySupport)

    in (collided, object)

appendIfNotCollided : (Bool, SpaceObject) -> SpaceObjects -> SpaceObjects
appendIfNotCollided (b, t) objects =
  if b then objects
  else t :: objects

applyCollisions : Time -> UUID -> SpaceObjects -> SpaceObjects
applyCollisions dt playersId objects =
  let
    player =
      getPlayer playersId objects

    collisionsCheck =
      map (didCollide dt player) objects

    collidedObjects =
      filter fst collisionsCheck |> map snd

    player' =
      foldr onCollision player collidedObjects
  in
    player' :: (map markRemove collidedObjects)
    |>foldr insertObject objects

markRemove : SpaceObject -> SpaceObject
markRemove object = { object | remove = True }

getPlayer : UUID -> SpaceObjects -> Player
getPlayer uuid objects =
  objects
  |>map bundle
  |>fromList
  |>get uuid
  |>withDefault dummyShip

insertObject : SpaceObject -> SpaceObjects -> SpaceObjects
insertObject object =
  let {uuid} = object in
  map bundle >> fromList >> insert uuid object >> values

bundle : SpaceObject -> (UUID, SpaceObject)
bundle object = (object.uuid, object)

onCollision : SpaceObject -> Player -> Player
onCollision object player = 
  let
    relativeVelocity =
      log "RV!!" <|
      let 
        (ovx, ovy) = object.velocity
        (pvx, pvy) = player.velocity
      in
      sqrt ((pvx - ovx)^2 + (pvy - ovy)^2)
  in 
  if relativeVelocity > 45 then
    log "BLOWN UP" player
  else
    case object.type' of
      AirTank ->
        { player | air = player.air + 150 }
      FuelTank ->
        { player | fuel = player.fuel + 762.2}
      _ -> player

collisionsHandle : Time -> Model -> Model
collisionsHandle dt model =
  let
    objects = 
      union model.localObjects model.remoteObjects
      |>values

    craft =
      objects
      |>filter (.type' >> (==) Ship)
      |>map .uuid

    objects' =
      foldr (applyCollisions dt) objects craft
      |>filter (.remove >> not)

    isLocal' = 
      isLocal model.playerId

  in
    { model
    | localObjects = dictOutput isLocal' objects'
    , remoteObjects = dictOutput (isLocal' >> not) objects' 
    }

dictOutput : (SpaceObject -> Bool) -> SpaceObjects ->  SpaceObjectDict
dictOutput filter' objects =
  fromList <| map bundle <| filter filter' objects

isLocal : UUID -> SpaceObject -> Bool
isLocal playersId object =
  playersId == object.owner










