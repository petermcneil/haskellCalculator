{-#LANGUAGE OverloadedStrings, EmptyDataDecls, FlexibleContexts, GADTs
   , GeneralizedNewtypeDeriving, MultiParamTypeClasses, QuasiQuotes, TemplateHaskell
   , TypeFamilies #-}

import Application () -- for YesodDispatch instance
import Foundation
import Yesod.Core
import Database.Persist.Sqlite
import Control.Monad.Trans.Resource (runResourceT)
import Control.Monad.Logger (runStdoutLoggingT, runStderrLoggingT)

openConnectionCount :: Int
openConnectionCount = 10

main :: IO ()
main = {-runStderrLoggingT $ withSqlitePool "db/haskCalc.db" openConnectionCount $ \pool -> liftIO $ do
    runResourceT $ flip runSqlPool pool $ do
        runMigration migrate
-}
    warp 3000 App


  {-  pool <- runStdoutLoggingT $ createSqlitePool "db/haskCalc" 10
  runSqlPersistMPool (runMigration migrateAll) pool
  
  warp 3000 App
-}
