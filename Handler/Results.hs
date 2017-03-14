{-# LANGUAGE OverloadedStrings, QuasiQuotes, TemplateHaskell, TypeFamilies #-}

module Handler.Results where

import Foundation
import Yesod.Core
import Yesod.Form
import Yesod.Form.Bootstrap3
import Handler.Home

postResultsR :: Handler Html
postResultsR = do
    ((results, widget), enctype) <- runFormPost $ renderBootstrap3 BootstrapBasicForm calcForm
    case results of
      FormSuccess calculation -> defaultLayout [whamlet|<p>#{show calculation}|]
      _ -> defaultLayout
           [whamlet|
              <p> Hello mate,
              <form role=form method=post action=@{ResultsR} enctype=#{enctype}>
                ^{widget}
                <button type="submit" .btn .btn-default>Submit
           |]

getResultsR :: Handler Html
getResultsR = defaultLayout [whamlet| <p> Hi |]

getResultsIdR :: Int -> String -> Int -> Handler TypedContent
getResultsIdR x op y =
        case op of
          "+" -> addInt x y
          "-" -> subInt x y
          "*" -> multiInt x y
          "d" -> divInt $ toFloat x y
          _   -> selectRep $ do
               provideRep $ defaultLayout $ do
               [whamlet|<h1> Something else|]

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

toFloat :: Int -> Int -> (Float, Float)
toFloat x y = (fromIntegral(x), fromIntegral(y))

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
