{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TypeFamilies      #-}

module Handler.History where

import Foundation
import Yesod.Core
import Yesod.Persist
import Yesod.Auth

getHistoryR :: Handler Html
getHistoryR = do
      maid <- maybeAuthId
      listOfResults <- runDB $ selectList [] [Desc ResultId, LimitTo 10]
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
                     <li>
                       <a href=@{HomeR}>Home
                     <li class="active">
                       <a href=@{HistoryR}>Latest Results
          <div class="container">
             $maybe u <- maid
                <p> You are logged in as #{u}
                <p><a href="@{AuthR LogoutR}">Logout</a>
             $nothing
                <p>Please visit the <a href="@{AuthR LoginR}">login page</a>
                
             <div class="container">
               <div>
                   <h2> Last 10 results
                   <table class="table table-condensed">
                      <thead>
                         <td> First Number
                         <td> Operation
                         <td> Second Number
                         <td> Answer
                      $forall Entity resultId result <- listOfResults
                          <tr>
                             <td>#{resultFirstnum result}
                             <td>#{resultOperation result}
                             <td>#{resultSecondnum result}
                             <td>#{resultAnswer result}
             <footer class="footer">
                  Peter McNeil 2017 - 15848156
       |]
