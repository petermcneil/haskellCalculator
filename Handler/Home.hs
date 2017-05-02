{-# LANGUAGE OverloadedStrings, QuasiQuotes, TemplateHaskell, TypeFamilies
    , MultiParamTypeClasses #-}
module Handler.Home where

import Foundation
import Yesod.Core
import Yesod.Form
import Yesod.Form.Bootstrap3
import Control.Applicative ((<$>), (<*>))
import Data.Text

calculationAForm :: AForm Handler Calculation
calculationAForm  = Calculation
  <$> areq doubleField (bfs ("First Number" :: Text)) Nothing
  <*> aopt (selectFieldList operations)(bfs ("Operation" :: Text)) (Just $ Just Add)
  <*> areq doubleField (bfs ("Second Number" :: Text)) Nothing
  where
   operations :: [(Text, Operation)]
   operations = [("+", Add), ("-", Subtract), ("*", Multiply), ("/", Divide)]

calcForm :: Html -> MForm Handler (FormResult Calculation, Widget)
calcForm = renderBootstrap3 BootstrapBasicForm calculationAForm

getHomeR :: Handler Html
getHomeR = do
     (widget, enctype) <- generateFormPost calcForm
     defaultLayout $ do
       setTitle "Haskell Calculator"
       addStylesheetRemote "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"
       [whamlet|
              <nav class="navbar navbar-inverse navbar-static-top">
               <div class="container">
                 <div class="navbar-header">
                   <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target=".navbar-collapse">
                     <span class="sr-only">Toggle navigation
                     <span class="icon-bar">
                     <span class="icon-bar">
                   <a class="navbar-brand" href=@{HomeR}>Calculator
                 <div class="navbar-collapse collapse">
                   <ul class="nav navbar-nav">
                     <li class="active">
                       <a href=@{HomeR}>Home
                     <li>
                       <a href=@{ResultsR}>Latest Results
          
           <div class="container">
             <div class="jumbotron">
                <p> This is a calculator. It has 4 functions: addition, subtraction, multiplication, and division. It is built using the Yesod framework for Haskell. It has been a wild ride...
             <div class="page-header">
                 <h3> Calculator
             <p>
                <form method=post action=@{CalcR} enctype=#{enctype}>
                    ^{widget}
                    <button type="submit" .btn .btn-default>Submit
             <div class="page-header">
                <footer>
                  Peter McNeil 2017 - 15848156
       |]
