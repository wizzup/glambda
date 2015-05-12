{-# LANGUAGE TemplateHaskell #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}

-----------------------------------------------------------------------------
-- |
-- Module      :  Tests.Util
-- Copyright   :  (C) 2015 Richard Eisenberg
-- License     :  BSD-style (see LICENSE)
-- Maintainer  :  Richard Eisenberg (eir@cis.upenn.edu)
-- Stability   :  experimental
--
-- Utility definnitions for testing glambda
--
----------------------------------------------------------------------------

module Tests.Util (
  module Test.Tasty,
  testCase,
  (@?=), (@=?), (@?) )
  where

import Language.Glambda.Util

import Test.Tasty
import Test.Tasty.HUnit ( testCase, (@?), Assertion )

import Text.PrettyPrint.ANSI.Leijen

import Text.Parsec ( ParseError )

import Data.Function
import Language.Haskell.TH

prettyError :: Pretty a => a -> a -> String
prettyError exp act = (render $ text "Expected" <+> squotes (pretty exp) <> semi <+>
                                text "got" <+> squotes (pretty act))

(@?=) :: (Eq a, Pretty a) => a -> a -> Assertion
act @?= exp = (act == exp) @? prettyError exp act

(@=?) :: (Eq a, Pretty a) => a -> a -> Assertion
exp @=? act = (act == exp) @? prettyError exp act

$( do decs <- reifyInstances ''Eq [ConT ''ParseError]
      case decs of
        [] -> [d| instance Eq ParseError where
                    (==) = (==) `on` show |]
        _  -> return [] )

instance (Pretty a, Pretty b) => Pretty (Either a b) where
  pretty (Left x)  = text "Left" <+> pretty x
  pretty (Right x) = text "Right" <+> pretty x