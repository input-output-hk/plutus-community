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

--import           Cardano.Api                     (writeFileTextEnvelope)
import           Cardano.Api.Shelley            (PlutusScript (..),
                                                 PlutusScriptV2)
import           Codec.Serialise
import           Data.Aeson                     as A
import qualified Data.ByteString.Lazy           as LBS
import qualified Data.ByteString.Short          as SBS
--import           Data.Functor                    (void)
--import           Ledger.Ada
--import           Ledger.Ada                      as Ada
--import           Ledger.Address
import qualified Ledger.Typed.Scripts           as Scripts
--import           Ledger.Typed.Scripts.Validators
--import           Ledger.Value                    as Value
import qualified Plutus.Script.Utils.V2.Scripts as PSU.V2
import qualified Plutus.V2.Ledger.Api           as PlutusV2
--import qualified Plutus.V2.Ledger.Contexts       as PlutusV2
--import           Plutus.V2.Ledger.Tx
import qualified PlutusTx
import           PlutusTx.Prelude               as P hiding (unless, (.))

import           GHC.Generics                   (Generic)

import qualified Prelude

data Bid = Bid
    { bidder :: PlutusV2.PubKeyHash
    , offer  :: Integer
    } deriving (Prelude.Show, Generic, FromJSON, ToJSON, Prelude.Eq, Prelude.Ord)

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
