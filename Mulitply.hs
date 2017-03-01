{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuest        #-}
module Multiply where

import Foundation
import Yesod.Core

getMultiR :: Int -> Int -> Handler TypedContent
getMultiR x y = selectRep $ do
    provideRep $ defaultLayout $ do
        setTitle "Multiplication"
        [whamlet|#{x} * #{y} = #{z}|]
    provideJson $ object ["result" .= z]
  where
    z = x * y
