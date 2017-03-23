{-# LANGUAGE OverloadedStrings, QuasiQuotes, TemplateHaskell, TypeFamilies #-}

module Handler.Results where

import Foundation
import Yesod.Core
import Yesod.Form
import Data.Text
import Handler.Home


getResultsR :: Handler Html
getResultsR = defaultLayout [whamlet| <p> Hi |]

  {- Come back to this later when you have sorted persistance

getResultsIdR :: Int -> Text -> Int -> Handler TypedContent
getResultsIdR x y z = calculateResult x y z
-}

-- Calculation form handling (come back to this)
postResultsR :: Handler TypedContent
postResultsR = do
    ((results, widget), enctype) <- runFormPost calcForm
    case results of
      FormSuccess calculation -> calculateResults calculation
      _ -> selectRep $ do
        provideRep $ defaultLayout $ do
           [whamlet|
              <p> The data wasn't valid, try again.

              <form role=form-inline method=post action=@{ResultsR} enctype=#{enctype}>
                ^{widget}
           |]

calculateResults :: Calculation -> Handler TypedContent
calculateResults  (Calculation x y z) = calculateResult x y z

calculateResult :: Double -> Text -> Double -> Handler TypedContent
calculateResult x op y =
        case op of
          "+" -> addNum x y
          "-" -> subNum x y
          "*" -> multiNum x y
          "d" -> divNum x y
          "/" -> divNum x y
          _   -> selectRep $ do
               provideRep $ defaultLayout $ do
               [whamlet|<h1> This operation is not supported. Please use +, -, *, /|]

-- Calculations (maybe change all to handle floats?)

addNum :: Double -> Double -> Handler TypedContent
addNum x y = selectRep $ do
    provideRep $ defaultLayout $ do
        [whamlet|#{x} + #{y} = #{z}|]
    provideJson $ object ["result" .= z]
  where
    z = x + y


multiNum :: Double -> Double -> Handler TypedContent
multiNum x y = selectRep $ do
    provideRep $ defaultLayout $ do
        [whamlet|<h1>#{x} * #{y} = #{z}|]
    provideJson $ object ["result" .= z]
  where
    z = x * y


subNum :: Double -> Double -> Handler TypedContent
subNum x y = selectRep $ do
    provideRep $ defaultLayout $ do
        [whamlet|<h1>#{x} - #{y} = #{z}|]
    provideJson $ object ["result" .= z]
  where
    z = x - y

divNum :: Double -> Double -> Handler TypedContent
divNum x y =
  case y of
    0 -> selectRep $ do
               provideRep $ defaultLayout $ do
               [whamlet|<h1> You cannot divide by 0.|]
    _ -> selectRep $ do
        provideRep $ defaultLayout $ do
           [whamlet|<h1>#{x} / #{y} = #{z}|]
        provideJson $ object ["result" .= z]
      where
        z = x / y

toDouble :: Int -> Int -> (Double, Double)
toDouble x y = (fromIntegral(x), fromIntegral(y))
