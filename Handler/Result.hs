{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TypeFamilies      #-}
module Handler.Result where
 
import Foundation

import Yesod.Core
import Yesod.Persist
import Yesod.Auth

getResultR :: ResultId ->  Handler Html
getResultR x = do
  maid <- maybeAuthId
  (Result a b c d _) <- runDB $ get404 x
  defaultLayout $ do
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
                       <a href=@{HistoryR}>Latest Results
          <div class="container">
             $maybe u <- maid
                <p> You are logged in as #{u}
                <p><a href="@{AuthR LogoutR}">Logout</a>
             $nothing
                <p>Please visit the <a href="@{AuthR LoginR}">login page</a>
                
           <div class="container">
             <div class="jumbotron">
                <h2> #{a} #{c} #{b} = #{d}
                
             <div class="page-header">
               <p> If you tried to divide by 0, you will be returned a result of 0. This is due to the fact that dividing by 0 can't be done.
           <footer class="footer">
                  Peter McNeil 2017 - 15848156
       |]


