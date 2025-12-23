module Dofgen.Ui.Main where

import Control.Monad.Trans
import Graphics.QML.Engine

import Paths_dofgen

main :: IO ()
main = do
  runEventLoop do
    mainqml <- liftIO $ getDataFileName "app/Dofgen/Ui/main.qml"

    let engine = defaultEngineConfig { initialDocument = fileDocument mainqml }
    runEngine engine
