{-# LANGUAGE ForeignFunctionInterface #-}

module Gsl where
  
import Foreign
import Foreign.C.Types
import Foreign.Ptr
import Foreign.C.String (peekCString)
import System.IO.Unsafe (unsafePerformIO)
import Bessel

foreign import ccall unsafe "gsl/gsl_math.h gsl_frexp"
  c_gsl_frexp :: CDouble -> Ptr CInt -> IO CDouble
  
-- allocate output pointer for result
frexp :: Double -> (Double, Int)
frexp x = unsafePerformIO $ do
  alloca $ \i_ptr -> do
    f <- c_gsl_frexp (realToFrac x) i_ptr
    e <- peek i_ptr
    return (realToFrac f, fromIntegral e)
  
besselJn :: Int -> Double -> Either String GslSfResult
besselJn n x = unsafePerformIO $
  alloca $ \gslSfPtr -> do
    c_deactivate_gsl_error_handler
    status <- c_besselJn (fromIntegral n) (realToFrac x) gslSfPtr
    if status == 0
      then peek gslSfPtr >>= return . Right
      else c_error_string status >>= peekCString >>= return . Left . ("GSL Err: " ++ )
