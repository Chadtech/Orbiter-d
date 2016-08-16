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

init : Model -> Model
init model =
  let
    (playerId, seed) = 
      makeUUID model.seed

    (localObjects, seed') =
      initLocalObjects
        seed
        playerId
  in
  { model
  | ready = True
  , playerId = playerId
  , focusOn = playerId
  , playerName = 
      get playerId localObjects
      |>withDefault dummyShip
      |> .name
  , localObjects = localObjects
  , seed = seed'
  }


initLocalObjects : Seed -> UUID -> (SpaceObjectDict, Seed)
initLocalObjects seed uuid =
  let
    (player, seed') = 
      makePlayer seed uuid

    (objects, seed'') =
      foldr 
        (always (addSpaceObject uuid)) 
        ([], seed')
        --[]
        [0..15]
  in
    --{player | uuid = "40!", global = (30000, 30000)} :: [player]
    (map bundle (player :: objects) |> fromList, seed')


bundle : SpaceObject -> (UUID, SpaceObject)
bundle object = (object.uuid, object)

makePlayer : Seed -> UUID -> (Player, Seed)
makePlayer seed uuid =
  let
    r     = getFloat 7000 55000 seed
    angle = getFloat 0 359 (snd r)
    va    = getFloat -70 70 (snd angle)

    cartesianCoordinates =
      let (x, y) = fromPolar ((fst r), degrees (fst angle)) in
      (x + 60000, y + 60000)

    vx' = getFloat -70 70 (snd va)
    vy' = getFloat -70 70 (snd vx')

    clockwiseOrbit = 
      (fst (getFloat 0 1 (snd vy'))) > 0.5

    (vx, vy) =
      let 
        r' = 
          if clockwiseOrbit then
            (600 / (sqrt ((fst r) / 7000)))
          else
            (600 / -(sqrt ((fst r) / 7000)))

        angle' = (degrees (fst angle)) + (pi / 2)
      in
      fromPolar (r', angle')

    sector = 
      let (x, y) = cartesianCoordinates in
      (floor (x / 600), floor (y / 600))

    (seed', playersName) =
      let 
        length' = length randomNames 
        (nameIndex, seed') =
          getFloat 0 (toFloat length') (snd vy')
      in
        map2 (,) [ 0..length' ] randomNames
        |>fromList
        |>get (floor nameIndex)
        |>withDefault "Kripke"
        |>(,) seed'
  in
  (,)
  { angle       = (0, 0)
  , local       = cartesianCoordinates
  , global      = cartesianCoordinates
  , velocity    = (vx + (fst vx'), (vy + (fst vy')) )
  , sector      = sector
  , direction   = 0
  , dimensions  = (34, 29)
  , fuel        = 1010.2
  , air         = 159
  , mass        = 852
  , missiles    = 5
  , type'       = Ship
  , name        = playersName
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
    { src        = "ship/ship-1"
    , dimensions = (47, 47)
    , area       = (138, 138)
    , position   = (0,0)
    }
  , remove       = False
  , explode      = False
  }
  seed'

addSpaceObject : UUID -> (SpaceObjects, Seed) -> (SpaceObjects, Seed)
addSpaceObject owner (objects, seed) =
  let
    r     = getFloat 7000 55000 seed
    angle = getFloat 0 359 (snd r)
    va    = getFloat -70 70 (snd angle)

    cartesianCoordinates =
      let (x, y) = fromPolar ((fst r), degrees (fst angle)) in
      (x + 60000, y + 60000)

    vx' = getFloat -70 70 (snd va)
    vy' = getFloat -70 70 (snd vx')

    clockwiseOrbit = 
      (fst (getFloat 0 1 (snd vy'))) > 0.5

    (vx, vy) =
      let 
        r' = 
          if clockwiseOrbit then
            (600 / (sqrt ((fst r) / 7000)))
          else
            (600 / -(sqrt ((fst r) / 7000)))

        angle' = (degrees (fst angle)) + (pi / 2)
      in
      fromPolar (r', angle')



    sector =
      let (x, y) = cartesianCoordinates in
      (floor (x / 600), floor (y / 600))

    uuid' = makeUUID (snd vy')
    uuid  = fst uuid'

    (type', seed') = getFloat 0 1 (snd uuid')

    type'' = 
      if type' > 0.5 then AirTank
      else FuelTank


  in
    (,)
    (
    { angle    = (0, (fst va))
    , global   = cartesianCoordinates
    , local    = cartesianCoordinates
    , velocity    = (vx + (fst vx'), (vy + (fst vy')) )
    , sector   = sector
    , direction = 0
    , dimensions =
        case type'' of
          AirTank -> (20, 20)
          FuelTank -> (10, 20)
          _       -> (400, 10)
    , fuel     = 0
    , air      = 0
    , mass     = 1
    , missiles = 0
    , type'    = type''
    , name     = 
        case type'' of
          AirTank -> "air tank"
          FuelTank -> "fuel tank"
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
        case type'' of
          AirTank ->
          { src        = "stuff/oxygen-tank"
          , dimensions = (20, 20)
          , area       = (20, 20)
          , position   = (0,0)
          }
          FuelTank ->
          { src        = "stuff/fuel-tank"
          , dimensions = (10, 22)
          , area       = (10, 22)
          , position   = (0,0)
          }
          _ ->
          { src        = "stuff/oxygen-tank"
          , dimensions = (400, 10)
          , area       = (20, 20)
          , position   = (0,0)
          }
    , remove = False
    , explode = False
    } :: objects
    )
    <|seed'

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

randomNames : List String
randomNames =
  [ "Russell"
  , "Ramsey"
  , "Anscombe"
  , "Moore"
  , "Harvie"
  , "Reich"
  , "Lang"
  , "Partch"
  , "Hamilton"
  , "Newhaus"
  , "Wolfe"
  , "Hess"
  , "Holmes"
  , "Jackson"
  , "Roberts"
  , "Marshall"
  ]

