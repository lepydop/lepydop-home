module PidginPipe(pidginPipeW) where
import Clickable (clickable)
import Image (imageW)
import System.Environment (getEnv)
import Data.Char (toLower)
import Utils (imageDir, chompAll, isRunning, chompFile)

clickL = Just "pkill -0 pidgin && wmctrl -s 1 || pidgin"
clickM = Nothing
clickR = Just "pkill pidgin"

pidginPipeW h = clickable clickL clickM clickR =<< imageW (getImage h)

getImage h = do
  home <- getEnv "HOME"
  let pipeFile = home ++ "/.purple/plugins/pipe"

  pipe <- chompFile pipeFile
  let status = if null pipe then "off" else map toLower pipe

  pidginRunning <- if status == "off" then return False else isRunning "pidgin"

  dir <- imageDir h
  let img = if pidginRunning then imgName status else imgName "off"
  return $ dir ++ "/pidgin/" ++ img ++ ".png"

imgName status = case status of
  "off"            -> "not-running"
  "new message"    -> "pidgin-tray-pending"
  "available"      -> "pidgin-tray-available"
  "away"           -> "pidgin-tray-away"
  "do not disturb" -> "pidgin-tray-busy"
  "invisible"      -> "pidgin-tray-invisible"
  "offline"        -> "pidgin-tray-offline"
  _                -> "pidgin-tray-xa"

