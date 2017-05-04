{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeFamilies      #-}

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
      let result  = genResult calculation
      case result of
        Just x -> do
          let (Result a b c d _) =  x
          resultId <- runDB $ insert $ Result a b c d maid
          redirect $ ResultR resultId
        Nothing -> do
          let msg = "Please choose a valid operation"
          setMessage msg
          redirect HomeR
    _ -> do
      let msg = "Please fill out both fields"
      setMessage msg
      redirect HomeR

genResult :: Calculation -> Maybe Result
genResult (Calculation x op y) =
  case op of
    Just CAdd -> Just $ addNum x y
    Just CSubtract -> Just $ subNum x y 
    Just CMultiply -> Just $ multiNum x y
    Just CDivide -> Just $ divNum x y
    _ -> Nothing

addNum :: Double -> Double -> Result
addNum x y = Result x y "+" z Nothing
  where
    z = x + y
    
subNum :: Double -> Double -> Result
subNum x y = Result x y "-" z Nothing
  where
    z = x - y

multiNum :: Double -> Double -> Result
multiNum x y = Result x y "*" z Nothing
  where
    z = x * y

divNum :: Double -> Double -> Result
divNum x y = Result x y "/" z Nothing
  where
    z =
      case y of
        0 -> 0
        _ -> x / y
