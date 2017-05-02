
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
main = runStderrLoggingT $ withSqlitePool "db/haskCalc.db" openConnectionCount $ runResourceT $ flip runSqlPool pool $ do
     runMigration migrateAll
  warp 3000 $ App pool
