{-# LANGUAGE OverloadedStrings #-}
module Main where

import Data.Monoid
import Web.Spock.Safe

main :: IO ()
main =
    runSpock 7070 $ spockT id $
    do get root $
           text "Hello World!"
       get ("hello" <//> var) $ \name ->
           text ("Hello " <> name <> "!")
