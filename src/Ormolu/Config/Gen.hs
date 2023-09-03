{- FOURMOLU_DISABLE -}
{- ***** DO NOT EDIT: This module is autogenerated ***** -}

{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RankNTypes #-}

module Ormolu.Config.Gen
  ( PrinterOpts (..)
  , CommaStyle (..)
  , FunctionArrowsStyle (..)
  , HaddockPrintStyle (..)
  , HaddockPrintStyleModule (..)
  , ImportExportStyle (..)
  , LetStyle (..)
  , InStyle (..)
  , Unicode (..)
  , SingleConstraintParens (..)
  , ColumnLimit (..)
  , emptyPrinterOpts
  , defaultPrinterOpts
  , defaultPrinterOptsYaml
  , fillMissingPrinterOpts
  , parseFourmoluOptsCLI
  , parsePrinterOptsJSON
  , parseFourmoluConfigType
  )
where

import qualified Data.Aeson as Aeson
import qualified Data.Aeson.Types as Aeson
import Data.Functor.Identity (Identity)
import Data.Scientific (floatingOrInteger)
import qualified Data.Text as Text
import GHC.Generics (Generic)
import Text.Read (readEither, readMaybe)

-- | Options controlling formatting output.
data PrinterOpts f =
  PrinterOpts
    { -- | Number of spaces per indentation step
      poIndentation :: f Int
    , -- | Max line length for automatic line breaking
      poColumnLimit :: f ColumnLimit
    , -- | Styling of arrows in type signatures
      poFunctionArrows :: f FunctionArrowsStyle
    , -- | How to place commas in multi-line lists, records, etc.
      poCommaStyle :: f CommaStyle
    , -- | Styling of import/export lists
      poImportExportStyle :: f ImportExportStyle
    , -- | Whether to full-indent or half-indent 'where' bindings past the preceding body
      poIndentWheres :: f Bool
    , -- | Whether to leave a space before an opening record brace
      poRecordBraceSpace :: f Bool
    , -- | Number of spaces between top-level declarations
      poNewlinesBetweenDecls :: f Int
    , -- | How to print Haddock comments
      poHaddockStyle :: f HaddockPrintStyle
    , -- | How to print module docstring
      poHaddockStyleModule :: f HaddockPrintStyleModule
    , -- | Styling of let blocks
      poLetStyle :: f LetStyle
    , -- | How to align the 'in' keyword with respect to the 'let' keyword
      poInStyle :: f InStyle
    , -- | Whether to put parentheses around a single constraint
      poSingleConstraintParens :: f SingleConstraintParens
    , -- | Output Unicode syntax
      poUnicode :: f Unicode
    , -- | Give the programmer more choice on where to insert blank lines
      poRespectful :: f Bool
    }
  deriving (Generic)

emptyPrinterOpts :: PrinterOpts Maybe
emptyPrinterOpts =
  PrinterOpts
    { poIndentation = Nothing
    , poColumnLimit = Nothing
    , poFunctionArrows = Nothing
    , poCommaStyle = Nothing
    , poImportExportStyle = Nothing
    , poIndentWheres = Nothing
    , poRecordBraceSpace = Nothing
    , poNewlinesBetweenDecls = Nothing
    , poHaddockStyle = Nothing
    , poHaddockStyleModule = Nothing
    , poLetStyle = Nothing
    , poInStyle = Nothing
    , poSingleConstraintParens = Nothing
    , poUnicode = Nothing
    , poRespectful = Nothing
    }

defaultPrinterOpts :: PrinterOpts Identity
defaultPrinterOpts =
  PrinterOpts
    { poIndentation = pure 4
    , poColumnLimit = pure NoLimit
    , poFunctionArrows = pure TrailingArrows
    , poCommaStyle = pure Leading
    , poImportExportStyle = pure ImportExportDiffFriendly
    , poIndentWheres = pure False
    , poRecordBraceSpace = pure False
    , poNewlinesBetweenDecls = pure 1
    , poHaddockStyle = pure HaddockMultiLine
    , poHaddockStyleModule = pure PrintStyleInherit
    , poLetStyle = pure LetAuto
    , poInStyle = pure InRightAlign
    , poSingleConstraintParens = pure ConstraintAlways
    , poUnicode = pure UnicodeNever
    , poRespectful = pure True
    }

-- | Fill the field values that are 'Nothing' in the first argument
-- with the values of the corresponding fields of the second argument.
fillMissingPrinterOpts ::
  forall f.
  Applicative f =>
  PrinterOpts Maybe ->
  PrinterOpts f ->
  PrinterOpts f
fillMissingPrinterOpts p1 p2 =
  PrinterOpts
    { poIndentation = maybe (poIndentation p2) pure (poIndentation p1)
    , poColumnLimit = maybe (poColumnLimit p2) pure (poColumnLimit p1)
    , poFunctionArrows = maybe (poFunctionArrows p2) pure (poFunctionArrows p1)
    , poCommaStyle = maybe (poCommaStyle p2) pure (poCommaStyle p1)
    , poImportExportStyle = maybe (poImportExportStyle p2) pure (poImportExportStyle p1)
    , poIndentWheres = maybe (poIndentWheres p2) pure (poIndentWheres p1)
    , poRecordBraceSpace = maybe (poRecordBraceSpace p2) pure (poRecordBraceSpace p1)
    , poNewlinesBetweenDecls = maybe (poNewlinesBetweenDecls p2) pure (poNewlinesBetweenDecls p1)
    , poHaddockStyle = maybe (poHaddockStyle p2) pure (poHaddockStyle p1)
    , poHaddockStyleModule = maybe (poHaddockStyleModule p2) pure (poHaddockStyleModule p1)
    , poLetStyle = maybe (poLetStyle p2) pure (poLetStyle p1)
    , poInStyle = maybe (poInStyle p2) pure (poInStyle p1)
    , poSingleConstraintParens = maybe (poSingleConstraintParens p2) pure (poSingleConstraintParens p1)
    , poUnicode = maybe (poUnicode p2) pure (poUnicode p1)
    , poRespectful = maybe (poRespectful p2) pure (poRespectful p1)
    }

parseFourmoluOptsCLI ::
  Applicative f =>
  (PrinterOpts Maybe -> a) ->
  (forall opt. FourmoluConfigType opt => String -> String -> String -> f (Maybe opt)) ->
  f a
parseFourmoluOptsCLI toResult mkOption =
  toResult
    <$> parsePrinterOptsCLI
  where
    parsePrinterOptsCLI =
      pure PrinterOpts
        <*> mkOption
          "indentation"
          "Number of spaces per indentation step (default: 4)"
          "INT"
        <*> mkOption
          "column-limit"
          "Max line length for automatic line breaking (default: none)"
          "OPTION"
        <*> mkOption
          "function-arrows"
          "Styling of arrows in type signatures (choices: \"trailing\", \"leading\", or \"leading-args\") (default: trailing)"
          "OPTION"
        <*> mkOption
          "comma-style"
          "How to place commas in multi-line lists, records, etc. (choices: \"leading\" or \"trailing\") (default: leading)"
          "OPTION"
        <*> mkOption
          "import-export-style"
          "Styling of import/export lists (choices: \"leading\", \"trailing\", or \"diff-friendly\") (default: diff-friendly)"
          "OPTION"
        <*> mkOption
          "indent-wheres"
          "Whether to full-indent or half-indent 'where' bindings past the preceding body (default: false)"
          "BOOL"
        <*> mkOption
          "record-brace-space"
          "Whether to leave a space before an opening record brace (default: false)"
          "BOOL"
        <*> mkOption
          "newlines-between-decls"
          "Number of spaces between top-level declarations (default: 1)"
          "INT"
        <*> mkOption
          "haddock-style"
          "How to print Haddock comments (choices: \"single-line\", \"multi-line\", or \"multi-line-compact\") (default: multi-line)"
          "OPTION"
        <*> mkOption
          "haddock-style-module"
          "How to print module docstring (default: same as 'haddock-style')"
          "OPTION"
        <*> mkOption
          "let-style"
          "Styling of let blocks (choices: \"auto\", \"inline\", \"newline\", or \"mixed\") (default: auto)"
          "OPTION"
        <*> mkOption
          "in-style"
          "How to align the 'in' keyword with respect to the 'let' keyword (choices: \"left-align\", \"right-align\", or \"no-space\") (default: right-align)"
          "OPTION"
        <*> mkOption
          "single-constraint-parens"
          "Whether to put parentheses around a single constraint (choices: \"auto\", \"always\", or \"never\") (default: always)"
          "OPTION"
        <*> mkOption
          "unicode"
          "Output Unicode syntax (choices: \"detect\", \"always\", or \"never\") (default: never)"
          "OPTION"
        <*> mkOption
          "respectful"
          "Give the programmer more choice on where to insert blank lines (default: true)"
          "BOOL"

parsePrinterOptsJSON ::
  Applicative f =>
  (forall a. FourmoluConfigType a => String -> f (Maybe a)) ->
  f (PrinterOpts Maybe)
parsePrinterOptsJSON f =
  pure PrinterOpts
    <*> f "indentation"
    <*> f "column-limit"
    <*> f "function-arrows"
    <*> f "comma-style"
    <*> f "import-export-style"
    <*> f "indent-wheres"
    <*> f "record-brace-space"
    <*> f "newlines-between-decls"
    <*> f "haddock-style"
    <*> f "haddock-style-module"
    <*> f "let-style"
    <*> f "in-style"
    <*> f "single-constraint-parens"
    <*> f "unicode"
    <*> f "respectful"

{---------- PrinterOpts field types ----------}

class Aeson.FromJSON a => FourmoluConfigType a where
  parseFourmoluConfigType :: String -> Either String a

instance FourmoluConfigType Int where
  parseFourmoluConfigType = readEither

instance FourmoluConfigType Bool where
  parseFourmoluConfigType s =
    case s of
      "false" -> Right False
      "true" -> Right True
      _ ->
        Left . unlines $
          [ "unknown value: " <> show s,
            "Valid values are: \"false\" or \"true\""
          ]

data CommaStyle
  = Leading
  | Trailing
  deriving (Eq, Show, Enum, Bounded)

data FunctionArrowsStyle
  = TrailingArrows
  | LeadingArrows
  | LeadingArgsArrows
  deriving (Eq, Show, Enum, Bounded)

data HaddockPrintStyle
  = HaddockSingleLine
  | HaddockMultiLine
  | HaddockMultiLineCompact
  deriving (Eq, Show, Enum, Bounded)

data HaddockPrintStyleModule
  = PrintStyleInherit
  | PrintStyleOverride HaddockPrintStyle
  deriving (Eq, Show)

data ImportExportStyle
  = ImportExportLeading
  | ImportExportTrailing
  | ImportExportDiffFriendly
  deriving (Eq, Show, Enum, Bounded)

data LetStyle
  = LetAuto
  | LetInline
  | LetNewline
  | LetMixed
  deriving (Eq, Show, Enum, Bounded)

data InStyle
  = InLeftAlign
  | InRightAlign
  | InNoSpace
  deriving (Eq, Show, Enum, Bounded)

data Unicode
  = UnicodeDetect
  | UnicodeAlways
  | UnicodeNever
  deriving (Eq, Show, Enum, Bounded)

data SingleConstraintParens
  = ConstraintAuto
  | ConstraintAlways
  | ConstraintNever
  deriving (Eq, Show, Enum, Bounded)

data ColumnLimit
  = NoLimit
  | ColumnLimit Int
  deriving (Eq, Show)

instance Aeson.FromJSON CommaStyle where
  parseJSON =
    Aeson.withText "CommaStyle" $ \s ->
      either Aeson.parseFail pure $
        parseFourmoluConfigType (Text.unpack s)

instance FourmoluConfigType CommaStyle where
  parseFourmoluConfigType s =
    case s of
      "leading" -> Right Leading
      "trailing" -> Right Trailing
      _ ->
        Left . unlines $
          [ "unknown value: " <> show s
          , "Valid values are: \"leading\" or \"trailing\""
          ]

instance Aeson.FromJSON FunctionArrowsStyle where
  parseJSON =
    Aeson.withText "FunctionArrowsStyle" $ \s ->
      either Aeson.parseFail pure $
        parseFourmoluConfigType (Text.unpack s)

instance FourmoluConfigType FunctionArrowsStyle where
  parseFourmoluConfigType s =
    case s of
      "trailing" -> Right TrailingArrows
      "leading" -> Right LeadingArrows
      "leading-args" -> Right LeadingArgsArrows
      _ ->
        Left . unlines $
          [ "unknown value: " <> show s
          , "Valid values are: \"trailing\", \"leading\", or \"leading-args\""
          ]

instance Aeson.FromJSON HaddockPrintStyle where
  parseJSON =
    Aeson.withText "HaddockPrintStyle" $ \s ->
      either Aeson.parseFail pure $
        parseFourmoluConfigType (Text.unpack s)

instance FourmoluConfigType HaddockPrintStyle where
  parseFourmoluConfigType s =
    case s of
      "single-line" -> Right HaddockSingleLine
      "multi-line" -> Right HaddockMultiLine
      "multi-line-compact" -> Right HaddockMultiLineCompact
      _ ->
        Left . unlines $
          [ "unknown value: " <> show s
          , "Valid values are: \"single-line\", \"multi-line\", or \"multi-line-compact\""
          ]

instance Aeson.FromJSON HaddockPrintStyleModule where
  parseJSON =
    \v -> case v of
      Aeson.Null -> pure PrintStyleInherit
      Aeson.String "" -> pure PrintStyleInherit
      _ -> PrintStyleOverride <$> Aeson.parseJSON v

instance FourmoluConfigType HaddockPrintStyleModule where
  parseFourmoluConfigType =
    \s -> case s of
      "" -> pure PrintStyleInherit
      _ -> PrintStyleOverride <$> parseFourmoluConfigType s

instance Aeson.FromJSON ImportExportStyle where
  parseJSON =
    Aeson.withText "ImportExportStyle" $ \s ->
      either Aeson.parseFail pure $
        parseFourmoluConfigType (Text.unpack s)

instance FourmoluConfigType ImportExportStyle where
  parseFourmoluConfigType s =
    case s of
      "leading" -> Right ImportExportLeading
      "trailing" -> Right ImportExportTrailing
      "diff-friendly" -> Right ImportExportDiffFriendly
      _ ->
        Left . unlines $
          [ "unknown value: " <> show s
          , "Valid values are: \"leading\", \"trailing\", or \"diff-friendly\""
          ]

instance Aeson.FromJSON LetStyle where
  parseJSON =
    Aeson.withText "LetStyle" $ \s ->
      either Aeson.parseFail pure $
        parseFourmoluConfigType (Text.unpack s)

instance FourmoluConfigType LetStyle where
  parseFourmoluConfigType s =
    case s of
      "auto" -> Right LetAuto
      "inline" -> Right LetInline
      "newline" -> Right LetNewline
      "mixed" -> Right LetMixed
      _ ->
        Left . unlines $
          [ "unknown value: " <> show s
          , "Valid values are: \"auto\", \"inline\", \"newline\", or \"mixed\""
          ]

instance Aeson.FromJSON InStyle where
  parseJSON =
    Aeson.withText "InStyle" $ \s ->
      either Aeson.parseFail pure $
        parseFourmoluConfigType (Text.unpack s)

instance FourmoluConfigType InStyle where
  parseFourmoluConfigType s =
    case s of
      "left-align" -> Right InLeftAlign
      "right-align" -> Right InRightAlign
      "no-space" -> Right InNoSpace
      _ ->
        Left . unlines $
          [ "unknown value: " <> show s
          , "Valid values are: \"left-align\", \"right-align\", or \"no-space\""
          ]

instance Aeson.FromJSON Unicode where
  parseJSON =
    Aeson.withText "Unicode" $ \s ->
      either Aeson.parseFail pure $
        parseFourmoluConfigType (Text.unpack s)

instance FourmoluConfigType Unicode where
  parseFourmoluConfigType s =
    case s of
      "detect" -> Right UnicodeDetect
      "always" -> Right UnicodeAlways
      "never" -> Right UnicodeNever
      _ ->
        Left . unlines $
          [ "unknown value: " <> show s
          , "Valid values are: \"detect\", \"always\", or \"never\""
          ]

instance Aeson.FromJSON SingleConstraintParens where
  parseJSON =
    Aeson.withText "SingleConstraintParens" $ \s ->
      either Aeson.parseFail pure $
        parseFourmoluConfigType (Text.unpack s)

instance FourmoluConfigType SingleConstraintParens where
  parseFourmoluConfigType s =
    case s of
      "auto" -> Right ConstraintAuto
      "always" -> Right ConstraintAlways
      "never" -> Right ConstraintNever
      _ ->
        Left . unlines $
          [ "unknown value: " <> show s
          , "Valid values are: \"auto\", \"always\", or \"never\""
          ]

instance Aeson.FromJSON ColumnLimit where
  parseJSON =
    \case
       Aeson.String "none" ->
         pure NoLimit
       Aeson.Number x
         | Right x' <- (floatingOrInteger x :: Either Double Int) ->
             pure $ ColumnLimit x'
       s ->
         fail . unlines $
           [ "unknown value: " <> show s,
             "Valid values are: \"none\", or an integer"
           ]

instance FourmoluConfigType ColumnLimit where
  parseFourmoluConfigType =
    \s ->
      case s of
        "none" -> Right NoLimit
        _
          | Just someInt <- readMaybe s ->
              Right . ColumnLimit $ someInt
        _ ->
          Left . unlines $
            [ "unknown value: " <> show s,
              "Valid values are: \"none\", or an integer"
            ]

defaultPrinterOptsYaml :: String
defaultPrinterOptsYaml =
  unlines
    [ "# Number of spaces per indentation step"
    , "indentation: 4"
    , ""
    , "# Max line length for automatic line breaking"
    , "column-limit: none"
    , ""
    , "# Styling of arrows in type signatures (choices: trailing, leading, or leading-args)"
    , "function-arrows: trailing"
    , ""
    , "# How to place commas in multi-line lists, records, etc. (choices: leading or trailing)"
    , "comma-style: leading"
    , ""
    , "# Styling of import/export lists (choices: leading, trailing, or diff-friendly)"
    , "import-export-style: diff-friendly"
    , ""
    , "# Whether to full-indent or half-indent 'where' bindings past the preceding body"
    , "indent-wheres: false"
    , ""
    , "# Whether to leave a space before an opening record brace"
    , "record-brace-space: false"
    , ""
    , "# Number of spaces between top-level declarations"
    , "newlines-between-decls: 1"
    , ""
    , "# How to print Haddock comments (choices: single-line, multi-line, or multi-line-compact)"
    , "haddock-style: multi-line"
    , ""
    , "# How to print module docstring"
    , "haddock-style-module: null"
    , ""
    , "# Styling of let blocks (choices: auto, inline, newline, or mixed)"
    , "let-style: auto"
    , ""
    , "# How to align the 'in' keyword with respect to the 'let' keyword (choices: left-align, right-align, or no-space)"
    , "in-style: right-align"
    , ""
    , "# Whether to put parentheses around a single constraint (choices: auto, always, or never)"
    , "single-constraint-parens: always"
    , ""
    , "# Output Unicode syntax (choices: detect, always, or never)"
    , "unicode: never"
    , ""
    , "# Give the programmer more choice on where to insert blank lines"
    , "respectful: true"
    , ""
    , "# Fixity information for operators"
    , "fixities: []"
    , ""
    , "# Module reexports Fourmolu should know about"
    , "reexports: []"
    ]
