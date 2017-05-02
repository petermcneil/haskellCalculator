{-# LANGUAGE OverloadedStrings, QuasiQuotes, TemplateHaskell, TypeFamilies #-}

module Handler.Calc where

import Foundation
import Handler.Home

import Yesod.Core
import Yesod.Form


postCalcR :: Handler ()
postCalcR = do
  ((results, widget), enctype) <- runFormPost calcForm
  case results of
    FormSuccess calculation -> do
      let x = genResult calculation
      resultId <- runDB $ insert $ x
      redirect $ ResultR resultId
    _ -> redirect HomeR

genResult :: Calculation -> Result
genResult (Calculation x op y) =
  case op of
    Just Add -> addNum x y
    Just Subtract -> subNum x y
    Just Multiply -> multiNum x y
    Just Divide -> divNum x y
    _ -> undefined

addNum :: Double -> Double -> Result
addNum x y = (Result x y "+" z)
  where
    z = x + y

subNum :: Double -> Double -> Result
subNum x y = (Result x y "-" z)
  where
    z = x - y

multiNum :: Double -> Double -> Result
multiNum x y = (Result x y "*" z)
  where
    z = x * y

divNum :: Double -> Double -> Result
divNum x y = (Result x y "/" z)
  where
    z =
      case y of
        0 -> 0
        _ -> x/y
