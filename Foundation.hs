{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell   #-}
{-# LANGUAGE TypeFamilies      #-}
{-# LANGUAGE ViewPatterns      #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE EmptyDataDecls #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE QuasiQuotes #-}
module Foundation where

import Yesod
import Data.Text
import Database.Persist.Sqlite
import Data.Time

data App = App ConnectionPool

mkYesodData "App" $(parseRoutesFile "routes")

instance Yesod App

{- Creates runDB function -}
instance YesodPersist App where
    type YesodPersistBackend App = SqlBackend

    runDB action = do
        App master <- getYesod
        runSqlPool action master

{- Calculation data declaration and instancing-}
data Calculation = Calculation
       {  firstNum  :: Double
       ,  operator  :: Text
       ,  secondNum :: Double
       }
       deriving (Show)

{- Required for running forms -}
instance RenderMessage App FormMessage where
  renderMessage _ _ = defaultFormMessage

{- Makes, allows tables to be migrateable-}
share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persistLowerCase|
User
    username String
    name String
    email String Maybe
    password String
    UniqueUsername username
    deriving Show
Result
    firstnum  Int
    operator  String
    secondnum Int
    datecreated UTCTime default=CURRENT_TIME
    userID UserId Maybe
    deriving Show
|]

{-UserResult
    userId UserId Maybe
    resultId ResultId
    UnqiueUserResult userId resultId
    deriving Show-}
