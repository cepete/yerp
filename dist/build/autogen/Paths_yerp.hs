module Paths_yerp (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
catchIO = Exception.catch


version :: Version
version = Version {versionBranch = [0,0,0], versionTags = []}
bindir, libdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/home/carl/.cabal/bin"
libdir     = "/home/carl/.cabal/lib/i386-linux-ghc-7.6.3/yerp-0.0.0"
datadir    = "/home/carl/.cabal/share/i386-linux-ghc-7.6.3/yerp-0.0.0"
libexecdir = "/home/carl/.cabal/libexec"
sysconfdir = "/home/carl/.cabal/etc"

getBinDir, getLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "yerp_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "yerp_libdir") (\_ -> return libdir)
getDataDir = catchIO (getEnv "yerp_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "yerp_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "yerp_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
