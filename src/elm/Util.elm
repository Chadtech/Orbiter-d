module Util exposing (..)

import Random
import List
import Dict        exposing (insert, Dict)
import Char  
import String
import Types       exposing (..)
import SpaceObject exposing (..)
import Collage     exposing (..)
import Element     exposing (..)
import Transform   exposing (..)
import Maybe

--RANDOM

getFloat : Float -> Float -> Random.Seed -> (Float, Random.Seed)
getFloat i j seed = 
  Random.step (Random.float i j) seed

addToUUID : (List Float, Random.Seed) -> (List Float, Random.Seed)
addToUUID (floats, seed) =
  let (thisFloat, seed') = getFloat 0 15 seed in
  (thisFloat :: floats, seed')

makeUUID : Random.Seed -> (String, Random.Seed)
makeUUID seed =
  let
    floats =
      List.foldr (always addToUUID) ([], seed) [0..15]
  in
    (floatsToString (fst floats), snd floats)

floatsToString : List Float -> String
floatsToString list =
  list
  |>List.map (String.fromChar << Char.fromCode << floor << (+) 65)
  |>List.foldr (++) ""

getInt : Int -> Int -> Random.Seed -> (Int, Random.Seed)
getInt i j seed =
  Random.step (Random.int i j) seed


--POSITIONING

getSector : Float -> Int
getSector f = floor (f / 600)

modulo : Float -> Float
modulo f =
  let f' = floor f in
  (toFloat (f' % 600)) + (f - (toFloat f'))

moduloAngle : Angle -> Angle
moduloAngle a =
  let a' = floor a in
  (toFloat (a' % 360)) + (a - (toFloat a'))


--SPACE OBJECT DICT / LIST MANIPULATION

elseDummy : Maybe SpaceObject -> SpaceObject
elseDummy =
  Maybe.withDefault dummyShip

isLocal : UUID -> SpaceObject -> Bool
isLocal playersId object =
  playersId == object.owner

addObject : SpaceObject -> Dict String SpaceObject -> Dict String SpaceObject
addObject newObject objects =
  insert newObject.uuid newObject objects

bundle : SpaceObject -> (UUID, SpaceObject)
bundle object = (object.uuid, object)


-- RENDERING

layerer : List Form -> Form
layerer = toForm << collage 1200 1200

image' : Int -> Int -> String -> Form
image' w h = root >> image w h >> toForm


-- SOURCES AND DIRECTORIES

root : String -> String
root s = root' ++ s ++ ".png"

root' : String
root' = "./"
