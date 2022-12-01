module Data.Variant.Ctors where

import Prelude

import Data.Symbol (class IsSymbol)
import Data.Variant (Variant)
import Data.Variant as V
import Prim.Row as Row
import Prim.RowList (class RowToList, RowList)
import Prim.RowList as RL
import Record as Record
import Type.Proxy (Proxy(..))

--- Ctors
class Ctors (v :: Type) (c :: Type) | v -> c where
  ctors :: Proxy v -> c

instance (RowToList v vrl, CtorsRL vrl v c) => Ctors (Variant v) (Record c) where
  ctors _ = ctorsRL (Proxy :: _ vrl) (Proxy :: _ v)

--- CtorsRL

class
  CtorsRL
    (rl :: RowList Type)
    (r :: Row Type)
    (c :: Row Type)
  | r rl -> c
  where
  ctorsRL :: Proxy rl -> Proxy r -> Record c

instance CtorsRL RL.Nil r () where
  ctorsRL _ _ = {}

instance
  ( CtorsRL rl r c'
  , Row.Cons sym a rX r
  , Row.Cons sym (a -> Variant r) c' c
  , Row.Lacks sym c'
  , IsSymbol sym
  ) =>
  CtorsRL (RL.Cons sym a rl) r c where
  ctorsRL _ r = Record.insert prxSym (V.inj prxSym) $ ctorsRL prxRL r
    where
    prxSym = Proxy :: _ sym
    prxRL = Proxy :: _ rl

