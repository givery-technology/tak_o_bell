{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Main where

import Control.Applicative
import Control.Monad.IO.Class
import Data.Time.Clock
import Network.HTTP.Types.Status
import Web.Spock.Safe

import qualified Data.HashMap.Strict as HM
import qualified Data.Text as T

-- import Picky.Combine

main :: IO ()
main = runSpock 7070 $ spockT id $
  do get root $
       text "Hello World!"
     get "test" $ 
       file "image/png" "/home/me/local/src/spajam/menu_design/menu_breakfast/menu_breakfast_black_blank.png"
     post ("convert" <//> var) $ \n -> do
       fs <- files
       let muf = HM.lookup "image" fs
       case muf of
        Nothing -> do
          setStatus status500
          text $ T.pack "No image uploaded by the name \"image\""
        Just uf -> do
          out <- liftIO getTmpFp
          _ <- liftIO $ getCombinedImg (uf_tempLocation uf) out n
          file "image/png" out

getCombinedImg :: FilePath -> FilePath -> Int -> IO ()
getCombinedImg = undefined

getTmpFp :: IO FilePath
getTmpFp = ("tmp/" ++) . show . utctDayTime  <$> getCurrentTime
