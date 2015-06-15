{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Main where

import Control.Applicative
import Control.Monad.IO.Class
import Data.Time.Clock
import System.Directory
import Network.HTTP.Types.Status
import Web.Spock.Safe

import qualified Data.HashMap.Strict as HM
import qualified Data.Text as T

import Picky.Combine

main :: IO ()
main = runSpock 7070 $ spockT id $
  do get root $
       text "Hello World!"
     post "test" $ do
--      post "test" $ 
--        file "image/png" "/home/picky/sample.jpg"
--      post ("convert" <//> var) $ \(n::Int) -> do
       fs <- files
       let muf = HM.lookup "image" fs
       case muf of
        Nothing -> do
          setStatus status500
          text $ T.pack "No image uploaded by the name \"image\""
        Just uf -> do
          out <- liftIO getTmpFp
          liftIO $ copyFile (uf_tempLocation uf) "./sub.jpg"
          let
            pp = defaultPP
              { ppInputFP = uf_tempLocation uf
              , ppOutputFP = out
              }
          _ <- liftIO $ getPickyImg pp
          file "image/png" out


getTmpFp :: IO FilePath
getTmpFp = ("tmp/" ++) . (++ ".jpg") . show . utctDayTime  <$> getCurrentTime
