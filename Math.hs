{-# LANGUAGE ForeignFunctionInterface #-}

module Math where

import Foreign
import Foreign.C.Types

foreign import ccall unsafe "math.h sin"
  cSin :: CDouble -> CDouble

hSin :: Double -> Double
hSin = realToFrac . cSin . realToFrac