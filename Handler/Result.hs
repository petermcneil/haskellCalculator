{-# LANGUAGE OverloadedStrings, QuasiQuotes, TemplateHaskell, TypeFamilies #-}

module Handler.Result where

import Foundation

import Yesod.Core

getResultR :: Int ->  Handler Html
getResultR x = defaultLayout $ do
       setTitle "Haskell Calculator - Results"
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
                <h3> Your result is #{x}
             <div class="page-header">
                <footer>
                  Peter McNeil 2017 - 15848156
       |]
