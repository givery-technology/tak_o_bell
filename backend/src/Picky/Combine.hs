import Control.Monad
import Data.List
import Data.Ord
import System.Environment
import System.IO
import System.Process

main :: IO ()
main = runCmd . getPoints . map readPoint . lines =<< getContents

data Points = Points
  { topLeft     :: Point
  , bottomLeft  :: Point
  , bottomRight :: Point
  , topRight    :: Point
  } deriving (Eq, Read, Show)

-- showCmd :: Points -> String
-- showCmd (Points tl bl br tr) = unlines . map show $ [tl, bl, br, tr]

runCmd :: Points -> IO ()
runCmd (Points tl bl br tr) = do
  args <- getArgs
  handleArgs args
 where
  handleArgs [img,out] = do
    (_, Just hout,_,p1) <-
      createProcess ( proc "identify" [img]){ std_out = CreatePipe }
    l <- hGetLine hout
    hClose hout
    let
      (_:_:size:_) = words l
      (sWidth, (_:sHeight)) = break (=='x') size

    handleArgs [img,out,sWidth,sHeight]
  handleArgs [img,out,sWidth,sHeight] = do
    (_,_,_,p2) <- createProcess ( proc "convert"
        [ img
        , "-matte"
        , "-virtual-pixel"
        , "transparent"
        , "-distort"
        , "Perspective"
        , dims
        , out
        ])
    void $ waitForProcess p2
   where
    (width, height) = (read sWidth, read sHeight)
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
  handleArgs _ = error $ unlines
    [ "Usage:"
    , "./this_program INPUT_PATH OUTPUT_PATH"
    , "./this_program INPUT_PATH OUTPUT_PATH OUTPUT_WIDTH OUTPUT_HEIGHT"
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

