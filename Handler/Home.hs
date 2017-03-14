{-# LANGUAGE OverloadedStrings, QuasiQuotes, TemplateHaskell, TypeFamilies
    , MultiParamTypeClasses #-}
module Handler.Home where

import Foundation
import Yesod.Core
import Yesod.Form
import Yesod.Form.Bootstrap3
import Control.Applicative ((<$>), (<*>))
import Data.Text

instance RenderMessage App FormMessage where
  renderMessage _ _ = defaultFormMessage

data Calculation = Calculation
       {  firstNum  :: Text
       ,  operator  :: Text
       ,  secondNum :: Text
       }
       deriving (Show)

calcForm :: AForm Handler Calculation
calcForm = Calculation
      <$> areq textField (bfs ("firstNum"  :: Text)) Nothing
      <*> areq textField (bfs ("operator"  :: Text)) Nothing
      <*> areq textField (bfs ("secondNum" :: Text)) Nothing

getHomeR :: Handler Html
getHomeR = do
     (widget, enctype) <- generateFormPost $ renderBootstrap3 BootstrapBasicForm calcForm
     defaultLayout
      [whamlet|
              <p> Hello mate,
              <form role=form method=post action=@{ResultsR} enctype=#{enctype}>
                ^{widget}
                <button type="submit" .btn .btn-default>Submit
      |]
