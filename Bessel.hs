{-# LINE 1 "Bessel.hsc" #-}
{-# LANGUAGE CPP, ForeignFunctionInterface #-}
{-# LINE 2 "Bessel.hsc" #-}

module Bessel where
  
import Foreign
import Foreign.Ptr
import System.IO.Unsafe (unsafePerformIO)
import Foreign.C.String
import Foreign.C.Types


{-# LINE 12 "Bessel.hsc" #-}

-- Ref : https://en.wikibooks.org/wiki/Haskell/FFI
-- working with C structures. We will be working with the function 

data GslSfResult = GslSfResult {
  gslVal :: CDouble,
  gslErr :: CDouble
} deriving (Show)

instance Storable GslSfResult where
  sizeOf _ = ((16))
{-# LINE 23 "Bessel.hsc" #-}
  alignment _ = alignment ( undefined :: CDouble )
  peek ptr = do
    val <- ((\hsc_ptr -> peekByteOff hsc_ptr 0)) ptr
{-# LINE 26 "Bessel.hsc" #-}
    err <- ((\hsc_ptr -> peekByteOff hsc_ptr 8)) ptr
{-# LINE 27 "Bessel.hsc" #-}
    return $ GslSfResult { gslVal = val, gslErr = err }
  poke ptr r@GslSfResult{ gslVal = val, gslErr = err } = do
    ((\hsc_ptr -> pokeByteOff hsc_ptr 0)) ptr val
{-# LINE 30 "Bessel.hsc" #-}
    ((\hsc_ptr -> pokeByteOff hsc_ptr 8)) ptr err
{-# LINE 31 "Bessel.hsc" #-}
      

foreign import ccall unsafe "gsl/gsl_bessel.h gsl_sf_bessel_Jn_e"
   c_besselJn :: CInt -> CDouble -> Ptr GslSfResult -> IO CInt

foreign import ccall unsafe "gsl/gsl_errno.h gsl_set_error_handler_off"
   c_deactivate_gsl_error_handler :: IO ()

foreign import ccall unsafe "gsl/gsl_errno.h gsl_strerror"
    c_error_string :: CInt -> IO CString
