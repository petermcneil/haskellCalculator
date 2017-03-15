{-# LANGUAGE OverloadedStrings, QuasiQuotes, TemplateHaskell, TypeFamilies #-}

module Handler.Results where

import Foundation
import Yesod.Core
import Yesod.Form
import Data.Text
import Handler.Home


getResultsR :: Handler Html
getResultsR = defaultLayout [whamlet| <p> Hi |]

getResultsIdR :: Int -> Text -> Int -> Handler TypedContent
getResultsIdR x y z = calculateResult x y z

-- /results/#Int/#Text/#Int      ResultsIdR GET

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

calculateResult :: Int -> Text -> Int -> Handler TypedContent
calculateResult x op y =
        case op of
          "+" -> addInt x y
          "-" -> subInt x y
          "*" -> multiInt x y
          "d" -> divInt $ toFloat x y
          "/" -> divInt $ toFloat x y
          _   -> selectRep $ do
               provideRep $ defaultLayout $ do
               [whamlet|<h1> This operation is not supported|]

-- Calculations (maybe change all to handle floats?)
addInt :: Int -> Int -> Handler TypedContent
addInt x y = selectRep $ do
    provideRep $ defaultLayout $ do
        [whamlet|#{x} + #{y} = #{z}|]
    provideJson $ object ["result" .= z]
  where
    z = x + y


multiInt :: Int -> Int -> Handler TypedContent
multiInt x y = selectRep $ do
    provideRep $ defaultLayout $ do
        [whamlet|#{x} * #{y} = #{z}|]
    provideJson $ object ["result" .= z]
  where
    z = x * y


subInt :: Int -> Int -> Handler TypedContent
subInt x y = selectRep $ do
    provideRep $ defaultLayout $ do
        [whamlet|#{x} - #{y} = #{z}|]
    provideJson $ object ["result" .= z]
  where
    z = x - y

divInt :: (Float, Float) -> Handler TypedContent
divInt (x, y) =
  case y of
    0 -> selectRep $ do
               provideRep $ defaultLayout $ do
               [whamlet|<h1> You cannot divide by 0.|]
    _ -> selectRep $ do
        provideRep $ defaultLayout $ do
           [whamlet|#{x} / #{y} = #{z}|]
        provideJson $ object ["result" .= z]
      where
        z = x / y

toFloat :: Int -> Int -> (Float, Float)
toFloat x y = (fromIntegral(x), fromIntegral(y))
