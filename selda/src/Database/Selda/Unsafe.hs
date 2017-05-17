{-# LANGUAGE ScopedTypeVariables #-}
-- | Unsafe operations giving the user unchecked low-level control over
--   the generated SQL.
module Database.Selda.Unsafe
  ( fun, fun2
  , aggr
  , cast
  , unsafeRowId
  ) where
import Database.Selda.Column
import Database.Selda.Inner (aggr)
import Database.Selda.SqlType
import Data.Text (Text)
import Data.Proxy

-- | Cast a column to another type, using whichever coercion semantics are used
--   by the underlying SQL implementation.
cast :: forall s a b. SqlType b => Col s a -> Col s b
cast = liftC $ Cast (sqlType (Proxy :: Proxy b))

-- | A unary operation. Note that the provided function name is spliced
--   directly into the resulting SQL query. Thus, this function should ONLY
--   be used to implement well-defined functions that are missing from Selda's
--   standard library, and NOT in an ad hoc manner during queries.
fun :: Text -> Col s a -> Col s b
fun f = liftC $ UnOp (Fun f)

-- | Like 'fun', but with two arguments.
fun2 :: Text -> Col s a -> Col s b -> Col s c
fun2 f = liftC2 (Fun2 f)
