{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE ViewPatterns         #-}

{-# OPTIONS_GHC -fno-warn-orphans #-}
module Application where

import Foundation
import Yesod.Core

import Handler.Add
import Handler.Subtract
import Handler.Multiply
import Handler.Home
import Handler.Results

mkYesodDispatch "App" resourcesApp
