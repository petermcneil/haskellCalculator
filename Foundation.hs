{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE Strict #-}
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
{-# LANGUAGE DeriveGeneric #-}
module Foundation where

import Yesod
import Database.SQLite.Simple
import Data.Text.Read
import qualified Data.Text as T

data App = App 

mkYesodData "App" $(parseRoutesFile "routes")

instance RenderMessage App FormMessage where
  renderMessage _ _ = defaultFormMessage
 
instance Yesod App

data Operation = Add | Subtract | Multiply | Divide
  deriving (Show, Eq)

data Calculation = Calculation
       {  firstNum  :: Double
       ,  operator  :: Maybe Operation
       ,  secondNum :: Double
       }
       deriving (Show)

data Result = Result
  { firstnum  :: Double
  , secondnum :: Double
  , operation :: String
  , answer    :: Double
  }
  deriving (Show, Eq, Read)

instance FromRow Result where
  fromRow = Result <$> field <*> field <*> field <*> field

instance PathPiece Double where
    fromPathPiece s = 
        case Data.Text.Read.double s of
            Right (i, _) -> Just i
            Left _ -> Nothing
    toPathPiece = T.pack . show

{-
{- Creates runDB function -}
instance YesodPersist App where
    type YesodPersistBackend App = SqlBackend

    runDB action = do
        App pool <- getYesod
        runSqlPool action pool

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
    firstnum  Double
    secondnum Double
    operator  String
    answer    Double
    deriving Show
|]
-}
