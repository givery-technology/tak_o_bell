{-# OPTIONS_GHC -fno-warn-type-defaults #-}

module Picky.Combine where

import Control.Monad
import Data.List
import Data.Ord
import System.IO
import System.Process

data PickyParams = PickyParams
  { ppWidth     :: Double   -- ^ width of output image
  , ppHeight    :: Double   -- ^ height of output image
  , ppCannyTS   :: Int      -- ^ Canny Threshold
  , ppAccumTS   :: Int      -- ^ Accumulator Threshold
  , ppInputFP   :: FilePath -- ^ Input file path
  , ppOutputFP  :: FilePath -- ^ Output file path
  , ppTemplateFP  :: FilePath -- ^ file path of template image
  }

getPickyImg :: PickyParams -> IO ()
getPickyImg pp = do
  correctImg pp . getPoints =<< detectMarkers pp
  combineImg pp

data Points = Points
  { topLeft     :: Point
  , bottomLeft  :: Point
  , bottomRight :: Point
  , topRight    :: Point
  } deriving (Eq, Read, Show)

getImgSize :: FilePath -> IO (Double, Double)
getImgSize img = do
  (_, Just hout,_,_) <-
    createProcess ( proc "identify" [img]){ std_out = CreatePipe }
  l <- hGetLine hout
  hClose hout
  let
    (_:_:size:_) = words l
    (sWidth, _:sHeight) = break (=='x') size
  return (read sWidth, read sHeight)

combineImg :: PickyParams -> IO ()
combineImg pp = do
  (_,_,_,p2) <- createProcess ( proc "composite"
      [ ppTemplateFP pp
      , ppOutputFP pp
      , ppOutputFP pp
      ])
  void $ waitForProcess p2

correctImg :: PickyParams -> Points -> IO ()
correctImg pp (Points tl bl br tr) = do
  (_,_,_,p2) <- createProcess ( proc "convert"
      [ ppInputFP pp
      , "-matte"
      , "-virtual-pixel"
      , "transparent"
      , "-distort"
      , "Perspective"
      , dims
      , ppOutputFP pp
      ])
  void $ waitForProcess p2
 where
  width  = ppWidth pp
  height = ppHeight pp
  dims = unwords . map show $
    [ tl
    , Point 0 0
    , bl
    , Point 0 height
    , br
    , Point width height
    , tr
    , Point width 0
    ]

data Point = Point Double Double deriving (Eq, Read)

instance Show Point where
  show (Point a b) = show a ++ "," ++ show b

instance Ord Point where
  compare (Point a1 b1) (Point a2 b2) = compare (a1 + b1) (a2 + b2)

distSq :: Point -> Point -> Double
distSq (Point x1 y1) (Point x2 y2) = (x1 - x2)^2 + (y1 - y2)^2

-- | Choose points in `Points` data
-- getPoints [Point 400.5 389.5, Point 422.5 136.5, Point 68.5 367.5, Point 64.5 144.5]
getPoints :: [Point] -> Points
getPoints ps = Points tl bl br tr
 where
   tl@(Point xmin ymin) = minimum ps
   br@(Point xmax ymax) = maximum ps
   tr = minimumBy (comparing $ distSq (Point xmax ymin)) ps
   bl = minimumBy (comparing $ distSq (Point xmin ymax)) ps

-- | Read space separated Float point numbers as Point
-- >>> "34.5 45"
-- Point 34.5 45.0
readPoint :: String -> Point
readPoint str = Point a b
 where
  (a:b:_) = map read . words $ str


detectMarkers :: PickyParams -> IO [Point]
detectMarkers pp = do
  (_, Just hout, Nothing,_) <-
    createProcess ( proc "detectPicky"
      [ ppInputFP pp
      , show . ppCannyTS $ pp
      , show . ppAccumTS $ pp
      ]) { std_out = CreatePipe }
  c <- hGetContents hout
  return . map readPoint . lines $ c

defaultPP = PickyParams
  { ppWidth = 840
  , ppHeight = 1120
  , ppCannyTS = 180
  , ppAccumTS = 30
  , ppInputFP = ""
  , ppOutputFP = ""
  , ppTemplateFP = "/home/picky/template/mask.png"
  }
