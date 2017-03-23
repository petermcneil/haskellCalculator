{-# LANGUAGE OverloadedStrings, QuasiQuotes, TemplateHaskell, TypeFamilies
    , MultiParamTypeClasses #-}
module Handler.Home where

import Foundation
import Yesod.Core
import Yesod.Form
import Control.Applicative ((<$>), (<*>))

calcForm :: Html -> MForm Handler (FormResult Calculation, Widget)
calcForm = renderTable $ Calculation
      <$> areq doubleField  "First Number "   Nothing
      <*> areq textField " Operation "     (Just "+")
      <*> areq doubleField  " Second Number " Nothing

getHomeR :: Handler Html
getHomeR = do
     (widget, enctype) <- generateFormPost calcForm
     defaultLayout
      [whamlet|
              <p> This is a calculator. It has 4 functions: add +, subtract -, multiply *, and divide /. Have fun with this exiciting and brave new world we live in.
              <br>
              <form method=post action=@{ResultsR} enctype=#{enctype}>
                ^{widget}
                <button>Submit
      |]
