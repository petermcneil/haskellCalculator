{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TypeFamilies      #-}
module Handler.User where
 
import Foundation

import Yesod.Core
import Yesod.Auth
import Yesod.Persist


getUserR :: UserId ->  Handler Html
getUserR x = do
  maid <- maybeAuthId
  case maid of
    Just auth -> do
      loser <- runDB $ selectList [UserId ==. x] []
--      list :: [Entity Result] <- runDB $ selectList [ResultUser ==. ] []
      defaultLayout $ do
       setTitle "User page"
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
                   <ul class="nav navbar-nav navbar-right">
                    $maybe _ <- maid
                       <li><a href="@{AuthR LogoutR}">Logout</a>
                    $nothing
                       <li><a href="@{AuthR LoginR}">Login</a>                 
               
             <div class="container">
               <div class="jumbotron">
               $forall Entity userId user <- loser
                 <h1> Hello #{userUsername user}!
               <div>
                   
             <footer class="footer">
                (c) Peter McNeil 2017 - 15848156
       |]

    Nothing -> 
      defaultLayout
        [whamlet| You are not authorised to see this page. <a href="@{AuthR LoginR}">Login to see it<a> |]
