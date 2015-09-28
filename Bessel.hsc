{-# LANGUAGE CPP, ForeignFunctionInterface #-}

module Bessel where
  
import Foreign
import Foreign.Ptr
import System.IO.Unsafe (unsafePerformIO)
import Foreign.C.String
import Foreign.C.Types

#include <gsl/gsl_sf_result.h>

-- Ref : https://en.wikibooks.org/wiki/Haskell/FFI
-- working with C structures. We will be working with the function 

data GslSfResult = GslSfResult {
  gslVal :: CDouble,
  gslErr :: CDouble
} deriving (Show)

instance Storable GslSfResult where
  sizeOf _ = (#size gsl_sf_result)
  alignment _ = alignment ( undefined :: CDouble )
  peek ptr = do
    val <- (#peek gsl_sf_result, val) ptr
    err <- (#peek gsl_sf_result, err) ptr
    return $ GslSfResult { gslVal = val, gslErr = err }
  poke ptr r@GslSfResult{ gslVal = val, gslErr = err } = do
    (#poke gsl_sf_result, val) ptr val
    (#poke gsl_sf_result, err) ptr err
      

foreign import ccall unsafe "gsl/gsl_bessel.h gsl_sf_bessel_Jn_e"
   c_besselJn :: CInt -> CDouble -> Ptr GslSfResult -> IO CInt

foreign import ccall unsafe "gsl/gsl_errno.h gsl_set_error_handler_off"
   c_deactivate_gsl_error_handler :: IO ()

foreign import ccall unsafe "gsl/gsl_errno.h gsl_strerror"
    c_error_string :: CInt -> IO CString
