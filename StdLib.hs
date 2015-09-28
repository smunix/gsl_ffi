{-# LANGUAGE ForeignFunctionInterface #-}

module StdLib where

import Foreign
import Foreign.C.Types

-- generate a pseudo-random  UInt
foreign import ccall unsafe "stdlib.h rand"
  cRand :: IO CUInt
  
-- set pseudo-random generator
foreign import ccall unsafe "stdlib.h srand"
  cSRand :: CUInt -> IO ()
  
