{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuest        #-}
module Subtract where

import Foundation
import Yesod.Core

getSubR :: Int -> Int -> Handler TypedContent
getSubR x y = selectRep $ do
    provideRep $ defaultLayout $ do
        setTitle "Subtraction"
        [whamlet|#{x} - #{y} = #{z}|]
    provideJson $ object ["result" .= z]
  where
    z = x - y
