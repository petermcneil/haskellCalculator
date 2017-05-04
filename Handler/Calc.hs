{-# LANGUAGE OverloadedStrings, QuasiQuotes, TemplateHaskell, TypeFamilies #-}

module Handler.Calc where

import Foundation
import Handler.Home

import Yesod.Core
import Yesod.Form
import Yesod.Persist
import Yesod.Auth

postCalcR :: Handler ()
postCalcR = do
  maid <- maybeAuthId
  ((results, _), _) <- runFormPost calcForm
  case results of
    FormSuccess calculation -> do
      let (Result a b c d _) = genResult calculation
      resultId <- runDB $ insert $ (Result a b c d maid)
      redirect $ ResultR resultId
    _ -> redirect HomeR

genResult :: Calculation -> Result
genResult (Calculation x op y) =
  case op of
    Just CAdd -> addNum x y
    Just CSubtract -> subNum x y 
    Just CMultiply -> multiNum x y
    Just CDivide -> divNum x y
    _ -> undefined

addNum :: Double -> Double -> Result
addNum x y = (Result x y "+" z Nothing)
  where
    z = x + y
    
subNum :: Double -> Double -> Result
subNum x y = (Result x y "-" z Nothing)
  where
    z = x - y

multiNum :: Double -> Double -> Result
multiNum x y = (Result x y "*" z Nothing)
  where
    z = x * y

divNum :: Double -> Double -> Result
divNum x y = (Result x y "/" z Nothing)
  where
    z =
      case y of
        0 -> 0
        _ -> x / y
