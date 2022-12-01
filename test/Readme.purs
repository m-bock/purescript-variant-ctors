-- # purescript-variant-ctors
--
-- Generate constructors for Variant types.
--
-- ## Usage

module Test.Readme where

import Prelude

import Data.Variant (Variant)
import Data.Variant as V
import Data.Variant.Ctors (class Ctors, ctors)
import Type.Proxy (Proxy(..))

-- Say we've defined the following Variant type:

type MyVariant = Variant
  ( foo :: Int
  , bar :: String
  , baz :: Unit
  )

-- Unfortunately it's a bit wordy to inject a value into the variant.

x'1 :: MyVariant
x'1 = V.inj (Proxy :: Proxy "foo") 97

-- We can do a little better by using a wildcard for the `Proxy` type constructor:

x'2 :: MyVariant
x'2 = V.inj (Proxy :: _ "foo") 97

-- But it's still noisy.
--
-- With this library you can generate constructors like so:

myVariant :: forall c. Ctors MyVariant c => c
myVariant = ctors (Proxy :: _ MyVariant)

-- Now we can just use them like:

x'3 :: MyVariant
x'3 = myVariant.foo 1

x'4 :: MyVariant
x'4 = myVariant.bar ""

x'5 :: MyVariant
x'5 = myVariant.baz unit

