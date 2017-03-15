{-#LANGUAGE OverloadedStrings #-}
import Application () -- for YesodDispatch instance
import Foundation
import Yesod.Core
import Database.SQLite.Simple

data TestField = TestField Int String deriving (Show)

instance FromRow TestField where
  fromRow = TestField <$> field <*> field

instance ToRow TestField where
  toRow (TestField id_ str) = toRow (id_, str)

main :: IO ()
main = do
  conn <- open "test.db"
  execute conn "INSERT INTO test (str) VALUES (?)"
    ( Only ("test string 2" :: String))
  r <- query_ conn "SELECT * from test" :: IO [TestField]
  mapM_ print r
  warp 3000 App
  close conn
