{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}

module Handler.Results where

import Foundation
import Yesod.Core


getResultsR :: Handler Html
getResultsR = defaultLayout [whamlet| <p> Hi |]

getResultsIdR :: Int -> String -> Int -> Handler TypedContent
getResultsIdR x op y = 
        case op of 
          "+" -> addInt x y
          "-" -> subInt x y
          "*" -> multiInt x y
          _ -> selectRep $ do
            provideRep $ defaultLayout $ do
            [whamlet|<h1> Something else|]



addInt :: Int -> Int -> Handler TypedContent
addInt x y = selectRep $ do
    provideRep $ defaultLayout $ do
        setTitle "Addition"
        [whamlet|#{x} + #{y} = #{z}|]
    provideJson $ object ["result" .= z]
  where
    z = x + y


multiInt :: Int -> Int -> Handler TypedContent
multiInt x y = selectRep $ do
    provideRep $ defaultLayout $ do
        setTitle "Addition"
        [whamlet|#{x} * #{y} = #{z}|]
    provideJson $ object ["result" .= z]
  where
    z = x * y


subInt :: Int -> Int -> Handler TypedContent
subInt x y = selectRep $ do
    provideRep $ defaultLayout $ do
        setTitle "Addition"
        [whamlet|#{x} - #{y} = #{z}|]
    provideJson $ object ["result" .= z]
  where
    z = x - y

{-getResultsIdR :: Int -> Handler Html
getResultsIdR x = defaultLayout $ do
    setTitle "Minimal Multifile"
    [whamlet|
        <p>
            <a href=@{AddR 5 7}>HTML addition #{x}
        <p>
            <a href=@{AddR 5 7}?_accept=application/json>JSON addition
        <p>
            <a href=@{SubR 5 7}>HTML subtraction
        <p>
            <a href=@{MultiR 5 7}>HTML multiplication
    |]
-}
