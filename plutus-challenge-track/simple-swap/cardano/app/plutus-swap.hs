import           Cardano.Api   hiding (TxId)
import           Cardano.Swap
import           Cardano.Token
import           Prelude


main :: IO ()
main = do
       result <- writeFileTextEnvelope "swap.plutus" Nothing apiSwapScript
       result' <- writeFileTextEnvelope "free-token.plutus" Nothing apiTokenScript
       case (result, result') of
         (Right _, Right _) -> putStrLn $ "wrote script to file "
         _                  -> putStrLn "error"

