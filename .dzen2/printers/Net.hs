module Net(main) where
import System.Process(readProcess)
import System.Environment (getEnv)
import Control.Concurrent (threadDelay)
import Control.Monad (forever)
import Data.Maybe (listToMaybe)
import TextRows (textRows)
import ClickAction (clickAction)
import Utils (padL, chompAll, regexFirstGroup, lineBuffering)

width = 9

cmd home = wscanCmd ++ " | " ++ popupCmd ++ dzenArgs
  where wscanCmd = home ++ "/.dzen2/printers/ghcprinter WScan"
        popupCmd = home ++ "/.dzen2/launchers/popup"
        dzenArgs = " 500 24 -fn inconsolata-14 "

data WStatus = Wlan | Wired | PPP | Tethering | None | Unknown deriving(Eq)

readWStatus :: IO WStatus
readWStatus = do 
  wstatus <- readProcess "wstatus" [] ""
  case wstatus of
    "wlan\n"       -> return Wlan
    "eth\n"        -> return Wired
    "ppp\n"        -> return PPP
    "tethering\n"  -> return Tethering
    "none\n"       -> return None
    otherwise      -> return Unknown


main = do
  lineBuffering
  home <- getEnv "HOME"
  forever $ do
    wstatus <- readWStatus
    text <- case wstatus of
      Wlan      -> wifi
      Wired     -> return "wired"
      PPP       -> return "pewpewpew"
      Tethering -> return "tethering"
      None      -> return "no wabs"
      Unknown   -> return "???"
    putStrLn $ clickAction 1 (cmd home) text
    threadDelay $ 1*10^6

wifi = do
  wlan <- fmap chompAll $ readProcess "ifdev" ["wlan"] ""
  s <- readProcess "iwconfig" [wlan] ""
  let ssid = regexFirstGroup "ESSID:\"(.*)\"" s
  let freq = regexFirstGroup "Frequency:(\\d+(\\.\\d+)?) GHz" s
  let qTop = regexFirstGroup "Link Quality=(\\d+)/\\d+" s
  let qBot = regexFirstGroup "Link Quality=\\d+/(\\d+)" s
  let rate = regexFirstGroup "Bit Rate=(\\d+) Mb/s" s
  let q = quality qTop qBot
  let f = frequency freq
  let top = (padtrim (width-6) rate ++ "m") ++ "|" ++ (quality qTop qBot)
  let bot = (padtrim width ssid)
  return $ textRows top bot

i = read :: String -> Integer
d = read :: String -> Double

padtrim len (Just s) = padL ' ' len $ take len $ s
padtrim len Nothing = take len $ repeat '?'

frequency (Just f) = show $ round $ (1000.0 * (d f))
frequency Nothing = "????"

quality (Just top) (Just bot) = padL ' ' 4 (per ++ "%")
  where per = show $ 100 * (i top) `div` (i bot)
quality _ _ = "???%"
