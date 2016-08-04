module Init exposing (..)

import Types exposing (..)
import Keyboard.Extra   as Keyboard
import List exposing (map)
import Debug exposing (log)


initModel : Model
initModel = 
  { ship   = frege
  , keys   = fst Keyboard.init
  , things = 
    [ fuelTank (10000, 60000) (0, -150) -35
    , o2box (10000, 60000) (1, -218) 3
    , o2box (15000, 60000) (5, -238) 11
    , o2box (10000, 60000) (-2, 218) 6
    , fuelTank (9900, 58000) (3, -218) 3
    , fuelTank (14000, 58000) (4, -238) 11
    , fuelTank (99000, 58000) (-3, 218) 6
    , fuelTank (10000, 60000) (-2, 148) 40
    , o2box (50000, 108000) (-200, -5) 73
    , fuelTank (50000, 103000) (-230, -10) 110
    , fuelTank (60000, 10000) (140, -10) 30
    , o2box (30000, 60000) (0, 290) 5
    , fuelTank (44900, 59900) (0, -400) 60
    , o2box (44900, 60100) (0, -400) 64
    , fuelTank (44800, 60000) (0, -400) -34
    , o2box (45050, 60000) (0, -400) -10
    , fuelTank (30000, 55000) (50, -250) -60
    , o2box (30000, 55000) (57, -250) -30
    , o2box (30000, 60000) (57, -250) -30
    , fuelTank (30000, 60000) (61, 250) 25
    , o2box (30000, 60000) (-44, -248) 55
    , fuelTank (30000, 60000) (50, 251) -87
    , o2box (30000, 60000) (33, 250)  -3
    , fuelTank (30000, 60000) (100, 250) 11
    ]
  , paused = False
  , died   = False
  , deathMsg = ""
  }

o2box : (Float, Float) -> (Float, Float) -> Float -> Thing
o2box (gx, gy) (vx, vy) va =
  let
    gx' = floor gx
    gy' = floor gy
    lx  = (toFloat (gx' % 600))
    ly  = (toFloat (gy' % 600))
    dimensions = (20, 20)
  in
  { angle    = (0, va)
  , velocity = (vx, vy)
  , local    = (lx,ly)
  , global   = (gx, gy)
  , sector   = (gx' // 600, gy' // 600)

  , dimensions = dimensions

  , onCollision = giveOxygen

  , sprite = 
    { dimensions = dimensions
    , src  = "stuff/oxygen-tank"
    }
  }

fuelTank : (Float, Float) -> (Float, Float) -> Float -> Thing
fuelTank (gx, gy) (vx, vy) va =
  let
    gx' = floor gx
    gy' = floor gy
    lx  = (toFloat (gx' % 600))
    ly  = (toFloat (gy' % 600))
    dimensions = (20, 30)
  in
  { angle    = (0, va)
  , velocity = (vx, vy)
  , local    = (lx,ly)
  , global   = (gx, gy)
  , sector   = (gx' // 600, gy' // 600)

  , dimensions = dimensions

  , onCollision = giveFuel

  , sprite = 
    { dimensions = dimensions
    , src  = "stuff/fuel-tank"
    }
  }

giveFuel : Ship -> Ship
giveFuel s = 
  { s | fuel = s.fuel + 762.2 }

giveOxygen : Ship -> Ship
giveOxygen s = 
  { s | oxygen = s.oxygen + 150 }

setSector : Float -> Int
setSector f = (floor (f / 600))

frege : Ship
frege = 
  let
    gx = 44900
    gy = 60000

    x =
      if gx > 600 then gx - 600
      else gx

    y =
      if gy > 600 then gy - 600
      else gy

  in
  { angle      = (0, 0)
  , local      = (x, y)
  , global     = (gx, gy)
  , velocity   = (0, -400)

  , sector     = (setSector gx, setSector gy)
  , quadrant   = C

  , dir        = 0

  , dimensions = (34, 29)

  , fuel       = 505.1
  , oxygen     = 63
  , weight     = 852

  , thrusters  =
    { leftFront  = 0
    , leftSide   = 0
    , leftBack   = 0
    , main       = 0
    , rightFront = 0
    , rightSide  = 0
    , rightBack  = 0
    , boost      = False
    }
  }