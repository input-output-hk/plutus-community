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

module Cardano.Swap where

import           Cardano.Api                     (writeFileTextEnvelope)
import           Cardano.Api.Shelley             (PlutusScript (..),
                                                  PlutusScriptV2)
import           Codec.Serialise
import           Data.Aeson                      as A
import qualified Data.ByteString.Lazy            as LBS
import qualified Data.ByteString.Short           as SBS
import           Data.Functor                    (void)
import           Ledger.Ada
import           Ledger.Ada                      as Ada
import           Ledger.Address
import qualified Ledger.Typed.Scripts            as Scripts
import           Ledger.Typed.Scripts.Validators
import           Ledger.Value                    as Value
import qualified Plutus.Script.Utils.V2.Scripts  as PSU.V2
import qualified Plutus.V2.Ledger.Api            as PlutusV2
import qualified Plutus.V2.Ledger.Contexts       as PlutusV2
import           Plutus.V2.Ledger.Tx
import qualified PlutusTx
import           PlutusTx.Prelude                as P hiding (unless, (.))

import           GHC.Generics                    (Generic)

import qualified Prelude

data Bid = Bid
    { bidder :: PlutusV2.PubKeyHash
    , offer  :: Integer
    } deriving (Prelude.Show, Generic, FromJSON, ToJSON, Prelude.Eq, Prelude.Ord)

PlutusTx.unstableMakeIsData ''Bid

{-# INLINABLE mkSwapValidator #-}
mkSwapValidator :: Bid -> () -> PlutusV2.ScriptContext -> Bool
mkSwapValidator bid () ctx = sellerPaid
    where
      info :: PlutusV2.TxInfo
      info = PlutusV2.scriptContextTxInfo ctx

      sellerPaid :: Bool
      sellerPaid = (PlutusV2.valuePaidTo info $ bidder bid) == (lovelaceValueOf $ offer bid)

data Swapping
instance Scripts.ValidatorTypes Swapping where
    type instance DatumType Swapping = Bid
    type instance RedeemerType Swapping = ()

swapValidator :: PlutusV2.Validator
swapValidator = PlutusV2.mkValidatorScript
    $$(PlutusTx.compile [|| wrap ||])
      where
        wrap = PSU.V2.mkUntypedValidator mkSwapValidator

swapScript :: PlutusV2.Script
swapScript = PlutusV2.unValidatorScript swapValidator

swapScriptAsShortBs :: SBS.ShortByteString
swapScriptAsShortBs = SBS.toShort $ LBS.toStrict $ serialise  swapScript

apiSwapScript :: PlutusScript PlutusScriptV2
apiSwapScript = PlutusScriptSerialised swapScriptAsShortBs
