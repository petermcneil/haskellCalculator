{-# LANGUAGE GADTs                      #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE QuasiQuotes                #-}
{-# LANGUAGE TemplateHaskell            #-}
{-# LANGUAGE TypeFamilies               #-}
{-# LANGUAGE ViewPatterns               #-}
{-# LANGUAGE EmptyDataDecls             #-}
{-# LANGUAGE FlexibleInstances          #-}
module Foundation where


import Yesod
import Database.Persist.Sqlite

import Data.Text (Text)
import Data.ByteString (ByteString)

import Yesod.Auth
import Yesod.Auth.Account

data Operation = CAdd | CSubtract | CMultiply | CDivide
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
   user Username Maybe
   deriving Show
User
    username Text
    UniqueUsername username
    password ByteString
    emailAddress Text
    verified Bool
    verifyKey Text
    resetPasswordKey Text
    deriving Show
|]

instance PersistUserCredentials User where
    userUsernameF = UserUsername
    userPasswordHashF = UserPassword
    userEmailF = UserEmailAddress
    userEmailVerifiedF = UserVerified
    userEmailVerifyKeyF = UserVerifyKey
    userResetPwdKeyF = UserResetPasswordKey
    uniqueUsername = UniqueUsername

    userCreate name email key pwd = User name pwd email False key ""
  
newtype App = App ConnectionPool

mkYesodData "App" $(parseRoutesFile "routes")

instance RenderMessage App FormMessage where
  renderMessage _ _ = defaultFormMessage
 
instance Yesod App 

instance YesodPersist App where
  type YesodPersistBackend App = SqlBackend

  runDB action = do
    App pool <- getYesod
    runSqlPool action pool

instance YesodAuth App where
    type AuthId App = Username
    getAuthId = return . Just . credsIdent
    loginDest _ = HomeR
    logoutDest _ = HomeR
    authPlugins _ = [accountPlugin]
    authHttpManager _ = error "No manager needed"
    onLogin = return ()
    maybeAuthId = lookupSession credsKey

instance AccountSendEmail App

instance YesodAuthAccount (AccountPersistDB App User) App where
    runAccountDB = runAccountPersistDB
