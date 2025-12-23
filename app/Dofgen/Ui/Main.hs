module Dofgen.Ui.Main where

import Graphics.QML.Engine

import Paths_dofgen

main :: IO ()
main = do
  mainqml <- getDataFileName "app/Dofgen/Ui/main.qml"
  runEventLoop do
    let engine = defaultEngineConfig { initialDocument = fileDocument mainqml }
    runEngine engine
