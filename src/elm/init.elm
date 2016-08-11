module Init exposing (init)

import Types       exposing (..)
import SpaceObject exposing (..)
import Game        exposing (Model)
import Random      exposing (Seed)
import Engine      exposing (..)
import Char        exposing (fromCode)
import String      exposing (fromChar)
import Dict        exposing (fromList, get, Dict)
import List        exposing (map2, map, foldr, length)
import Maybe       exposing (withDefault)
import Debug       exposing (log)

init : Model -> Seed -> Model
init model seed =
  let
    (playerId, seed') = makeUUID seed
  in
  { model
  | ready = True
  , playerId = playerId
  , localObjects = 
      initLocalObjects
        seed'
        playerId
  }

randomNames : List String
randomNames =
  [ "Russell"
  , "Ramsey"
  , "Anscombe"
  , "Moore"
  , "Wilkinson"
  , "Reich"
  , "Lang"
  , "Partch"
  , "Hamilton"
  , "Newhaus"
  , "Wolfe"
  , "Hess"
  ]

initLocalObjects : Seed -> UUID -> SpaceObjectDict
initLocalObjects seed uuid =
  let
    (player, seed') = 
      makePlayer seed uuid

    (objects, seed'') =
      foldr 
        (always (addSpaceObject uuid AirTank)) 
        ([], seed') 
        [0..10]
  in
    player :: objects
    |>map bundle
    |>fromList

bundle : SpaceObject -> (UUID, SpaceObject)
bundle object = (object.uuid, object)

makePlayer : Seed -> UUID -> (Player, Seed)
makePlayer seed uuid =
  let
    gx = 44850
    gy = 60000

    sector = 
      (floor (gx / 600), floor (gy / 600))

    (seed', playersName) =
      let 
        length' = length randomNames 
        (nameIndex, seed') =
          getFloat 0 (toFloat length') seed 
      in
        map2 (,) [ 0..length' ] randomNames
        |>fromList
        |>get (floor nameIndex)
        |>withDefault "Kripke"
        |>(,) seed'
  in
  (,)
  { angle       = (0, 0)
  , local       = (gx, gy)
  , global      = (gx, gy)
  , velocity    = (10, -400)
  , sector      = sector
  , direction   = 0
  , dimensions  = (34, 29)
  , fuel        = 505.1
  , air         = 63
  , mass        = 852
  , type'       = Craft
  , name        = log "NAME!" playersName
  , uuid        = uuid
  , owner       = uuid
  , engine      =
    { boost     = False
    , thrusters = 
      [ { type' = Main,       firing = 0 }
      , { type' = FrontLeft,  firing = 0 }
      , { type' = FrontRight, firing = 0 }
      , { type' = SideLeft,   firing = 0 }
      , { type' = SideRight,  firing = 0 }
      , { type' = BackLeft,   firing = 0 }
      , { type' = BackRight,  firing = 0 }
      ]
    }
  , sprite =
    { src        = "ship/ship"
    , dimensions = (47, 47)
    , area       = (138, 138)
    , position   = (0,0)
    }
  , remove       = False
  }
  seed'

addSpaceObject : UUID -> SpaceObjectType -> (SpaceObjects, Seed) -> (SpaceObjects, Seed)
addSpaceObject owner type' (objects, seed) =
  let
    (r, seed')      = getFloat 7000 55000 seed
    (angle, seed'') = getFloat 0 359 seed'
    (va, seede' )   = getFloat -70 70 seed''

    cartesianCoordinates =
      let (x, y) = fromPolar (r, degrees angle) in
      (x + 60000, y + 60000)

    (v', seedee) = getFloat -7 7 seede'

    velocity =
      fromPolar ((600 / (sqrt (r / 7000))), (degrees angle) + (pi / 2))
    --clockwiseOrbit = (getFloat seed 0 1) > 0.5

    sector =
      let (x, y) = cartesianCoordinates in
      (floor (x / 600), floor (y / 600))

    (uuid, seede'') = makeUUID seedee

  in
    ({ angle    = (0, va)
    , global   = cartesianCoordinates
    , local    = cartesianCoordinates
    , velocity = velocity
    , sector   = sector
    , direction = 0
    , dimensions =
        case type' of
          AirTank -> (20, 20)
          _       -> (400, 10)
    , fuel     = 0
    , air      = 0
    , mass     = 1
    , type'    = type'
    , name     = 
        case type' of
          AirTank -> "air tank"
          _       -> "Henry"
    , uuid    = uuid
    , owner   = owner
    , engine  = 
        case type' of 
          _ ->
            { boost = False
            , thrusters = []
            }
    , sprite =
        case type' of
          AirTank ->
          { src        = "stuff/oxygen-tank"
          , dimensions = (20, 20)
          , area       = (20, 20)
          , position   = (0,0)
          }
          _ ->
          { src        = "stuff/oxygen-tank"
          , dimensions = (400, 10)
          , area       = (20, 20)
          , position   = (0,0)
          }
    , remove = False
    } :: objects, seede'')

getFloat : Float -> Float -> Seed -> (Float, Seed)
getFloat i j seed = 
  Random.step (Random.float i j) seed

addToUUID : (List Float, Seed) -> (List Float, Seed)
addToUUID (floats, seed) =
  let (thisFloat, seed') = getFloat 0 15 seed in
  (thisFloat :: floats, seed')

makeUUID : Seed -> (String, Seed)
makeUUID seed =
  let
    floats =
      foldr (always addToUUID) ([], seed) [0..15]
  in
    (floatsToString (fst floats), snd floats)


floatsToString : List Float -> String
floatsToString list =
  list
  |>map (fromChar << fromCode << floor << (+) 65)
  |>foldr (++) ""



