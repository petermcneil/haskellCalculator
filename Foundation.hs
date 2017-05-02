{-# LANGUAGE EmptyDataDecls             #-}
{-# LANGUAGE FlexibleContexts           #-}
{-# LANGUAGE GADTs                      #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE QuasiQuotes                #-}
{-# LANGUAGE TemplateHaskell            #-}
{-# LANGUAGE TypeFamilies               #-}
{-# LANGUAGE ViewPatterns               #-}

module Foundation where

import Yesod
import Database.Persist.Sqlite

data Operation = Add | Subtract | Multiply | Divide
  deriving (Show, Eq)

data Calculation = Calculation
       {  firstNum  :: Double
       ,  operator  :: Maybe Operation
       ,  secondNum :: Double
       }
       deriving (Show)

share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persistLowerCase|
Result
   firstnum Double
   secondnum Double
   operation String
   answer Double
   deriving Show
|]
  
data App = App ConnectionPool

mkYesodData "App" $(parseRoutesFile "routes")

instance RenderMessage App FormMessage where
  renderMessage _ _ = defaultFormMessage
 
instance Yesod App

instance YesodPersist App where
  type YesodPersistBackend App = SqlBackend

  runDB action = do
    App pool <- getYesod
    runSqlPool action pool
