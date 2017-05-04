{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE ViewPatterns         #-}

{-# OPTIONS_GHC -fno-warn-orphans #-}
module Application where

import Foundation
import Yesod.Core
import Yesod.Auth

import Handler.Home
import Handler.Result
import Handler.History
import Handler.Calc

mkYesodDispatch "App" resourcesApp
