module Pather exposing (root)

root : String -> String
root s = root' ++ s ++ ".png"

root' : String
root' = "./"