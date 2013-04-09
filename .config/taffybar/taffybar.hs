import Widgets(label)
import MonitorMem(monitorMemW)
import MonitorCpu(monitorCpuW)
import Ekiga(ekigaW)
import TPBattStat(tpBattStatW)
import PidginPipe(pidginPipeW)
import Thunderbird(thunderbirdW)
import Volume(volumeW)
import Mic(micW)
import Brightness(brightnessW)
import Openvpn(openvpnW)
import Fcrondyn(fcrondynW)
import Net(netW)
import NetStats(netStatsW)
import PingMonitor(pingMonitorW)
import Klomp(klompW)
import Fan(fanW)
import CpuFreqs(cpuFreqsW)
import CpuScaling(cpuScalingW)
import System.Taffybar

import System.Taffybar.Systray
import System.Taffybar.XMonadLog
import System.Taffybar.SimpleClock
import System.Taffybar.FreedesktopNotifications
import System.Taffybar.Weather
import System.Taffybar.MPRIS
import System.Taffybar.Battery

import System.Taffybar.Widgets.PollingBar
import System.Taffybar.Widgets.PollingGraph
import System.Taffybar.Widgets.PollingLabel

import System.Taffybar.Widgets.VerticalBar


main = do
  let height = 40
  let start =
            [ xmonadLogNew
            ]
  let end = reverse
          [ monitorCpuW
          , monitorMemW
          , netStatsW $ label 1
          , netW $ label 1
          , fcrondynW $ label 1
          , klompW $ label 1
          , volumeW
          , micW
          , pidginPipeW
          , thunderbirdW
          , ekigaW
          , cpuScalingW $ label 1
          , cpuFreqsW $ label 1
          , fanW $ label 1
          , brightnessW
          , pingMonitorW (label 1) "www.google.com" "G" 1
          , openvpnW $ label 1
          , pingMonitorW (label 1) "source.escribe.com" "E" 1
          , tpBattStatW
          , textClockNew Nothing "%a %b %d\n%H:%M:%S" 1
          ]

  defaultTaffybar defaultTaffybarConfig {
    barHeight=height, startWidgets=start, endWidgets=end}
