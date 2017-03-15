{-# LANGUAGE OverloadedStrings, QuasiQuotes, TemplateHaskell, TypeFamilies
    , MultiParamTypeClasses #-}
module Handler.Home where

import Foundation
import Yesod.Core
import Yesod.Form
import Control.Applicative ((<$>), (<*>))
import Data.Text

instance RenderMessage App FormMessage where
  renderMessage _ _ = defaultFormMessage

data Calculation = Calculation
       {  firstNum  :: Int
       ,  operator  :: Text
       ,  secondNum :: Int
       }
       deriving (Show)

calcForm :: Html -> MForm Handler (FormResult Calculation, Widget)
calcForm = renderDivs $ Calculation
      <$> areq intField "firstNum" Nothing
      <*> areq textField "operator"  Nothing
      <*> areq intField "secondNum" Nothing

getHomeR :: Handler Html
getHomeR = do
     (widget, enctype) <- generateFormPost calcForm
     defaultLayout
      [whamlet|
              <p> Hello mate,
              <form method=post action=@{ResultsR} enctype=#{enctype}>
                ^{widget}
                <button>Submit
      |]
