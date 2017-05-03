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
import Application () -- for YesodDispatch instance
import Foundation

import Yesod.Core
import Database.Persist.Sqlite
import Control.Monad.Logger (runStdoutLoggingT)

main :: IO ()
main = do
  pool <- runStdoutLoggingT $ createSqlitePool "db/haskCalc.db" 10
  runSqlPersistMPool (runMigration migrateAll) pool
  warp 3000 $ App pool
