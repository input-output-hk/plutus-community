{-# LANGUAGE DataKinds             #-}
{-# LANGUAGE DeriveAnyClass        #-}
{-# LANGUAGE DeriveGeneric         #-}
{-# LANGUAGE FlexibleContexts      #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE NoImplicitPrelude     #-}
{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE ScopedTypeVariables   #-}
{-# LANGUAGE TemplateHaskell       #-}
{-# LANGUAGE TypeApplications      #-}
{-# LANGUAGE TypeFamilies          #-}
{-# LANGUAGE TypeOperators         #-}

module Cardano.Token where

import           Cardano.Api.Shelley            (PlutusScript (..),
                                                 PlutusScriptV2)
import           Codec.Serialise
import           Data.Aeson                     as A
import qualified Data.ByteString.Lazy           as LBS
import qualified Data.ByteString.Short          as SBS

import qualified Ledger.Typed.Scripts           as Scripts

import qualified Plutus.Script.Utils.V2.Scripts as PSU.V2
import qualified Plutus.V2.Ledger.Api           as PlutusV2
import qualified PlutusTx
import           PlutusTx.Prelude               as P hiding (unless, (.))

import           GHC.Generics                   (Generic)

import qualified Prelude

{-# INLINABLE mkMintingScript #-}
mkMintingScript :: () -> PlutusV2.ScriptContext -> Bool
mkMintingScript () _ = True

policy :: Scripts.MintingPolicy
policy = PlutusV2.mkMintingPolicyScript $
    $$(PlutusTx.compile [|| wrap ||])
  where
    wrap = PSU.V2.mkUntypedMintingPolicy mkMintingScript

plutusScript :: PlutusV2.Script
plutusScript = PlutusV2.unMintingPolicyScript policy

validator :: PlutusV2.Validator
validator = PlutusV2.Validator plutusScript

apiTokenScript :: PlutusScript PlutusScriptV2
apiTokenScript = PlutusScriptSerialised tokenScriptAsShortBs

tokenScriptAsShortBs :: SBS.ShortByteString
tokenScriptAsShortBs = SBS.toShort $ LBS.toStrict $ serialise $ plutusScript
