#!/usr/bin/env python3
"""
    Statusbar Module for Battery

    Dependencies (on Debian, use 'apt'):
        -> python3-gi
        -> python3-pydbus
        -> fonts-font-awesome
"""

import json
import os
import sys
# import errno
import signal

from threading import Thread
from gi.repository.GLib import MainLoop
from pydbus import SystemBus


IFACE = "org.freedesktop.UPower"
IFACE_PATH = "/org/freedesktop/UPower"

BAT_WARNING = 30
BAT_CRITICAL = 10

BAT_STATE = {
    0: [' ', "unknown"],
    1: [' ', "charging"],
    2: ['',   "discharging"],
    3: [' ', "empty"],
    4: [' ', "full"],
    5: ['',   "pending_charge"],
    6: ['',   "pending_discharge"]
}

BAT_LEVEL = {
    4:   "▏  ▏",
    8:   "▎  ▏",
    12:  "▍  ▏",
    16:  "▌  ▏",
    20:  "▋  ▏",
    24:  "▊  ▏",
    28:  "▉  ▏",
    32:  "█  ▏",
    36:  "█▏ ▏",
    40:  "█▎ ▏",
    44:  "█▍ ▏",
    48:  "█▌ ▏",
    52:  "█▋ ▏",
    56:  "█▊ ▏",
    60:  "█▉ ▏",
    64:  "██ ▏",
    68:  "██▏▏",
    72:  "██▎▏",
    76:  "██▍▏",
    80:  "██▌▏",
    84:  "██▋▏",
    88:  "██▊▏",
    92:  "██▉▏",
    100: "███▏"
}


class BatteryMonitor:
    """ Class for Battery Monitoring """
    def __init__(self, batn):
        self.use_design_capacity = 1
        self.bat_path = f"{IFACE_PATH}/devices/battery_BAT{batn}"
        self.pipe = f"{os.getenv('XDG_RUNTIME_DIR')}/bar-BAT{batn}-pipe"
        self.upower = self.bus = self.bat = self.loop = None

    def run(self):
        """ Runs event loop """
        self.loop = MainLoop()
        self.bus = SystemBus()
        self.upower = self.bus.get(IFACE, IFACE_PATH)

        if self.bat_path in self.upower.EnumerateDevices():
            self.add_battery()
        else:
            self.upower.onDeviceAdded = self.add_battery

        signal.signal(signal.SIGTERM, self.end_loop)
        signal.signal(signal.SIGINT, self.end_loop)

        os.mkfifo(self.pipe, 0o600)
        Thread(target=self.read_pipe).start()

        self.loop.run()
        return 0

    def end_loop(self, signal_num=None, frame=None):
        """ End event loop """
        del signal_num, frame
        with open(self.pipe, 'w') as pipe:
            pipe.write("exit\n")

    def read_pipe(self):
        """ Read FIFO file """
        mes = None
        while mes != "exit":
            with open(self.pipe) as pipe:
                mes = (pipe.read()).rstrip('\n')

            if mes == "toggle":
                self.use_design_capacity = (self.use_design_capacity + 1) % 2
                self.update_battery()

        os.remove(self.pipe)
        self.loop.quit()

    def add_battery(self, dev_path=None):
        """ Add the battery when the battery exists """
        if (dev_path is None) or (dev_path == self.bat_path):
            self.upower.onDeviceRemoved = self.remove_battery
            if self.upower.onDeviceAdded is not None:
                self.upower.onDeviceAdded = None

            self.bat = self.bus.get(IFACE, self.bat_path)
            self.bat.onPropertiesChanged = self.update_battery
            self.update_battery()

    def remove_battery(self, dev_path):
        """ Remove the battery when the battery not exists """
        if dev_path == self.bat_path:
            self.upower.onDeviceAdded = self.add_battery
            self.upower.onDeviceRemoved = None

            self.bat.onPropertiesChanged = None
            self.bat = None
            self.update_battery()

    def update_battery(self, ifname=None, changed_props=None, invalid_props=None):
        """ Print the updated battery info """
        del ifname, invalid_props
        if (changed_props is None) or (('Energy' in changed_props) or ("State" in changed_props)):
            output = {"text": '', "class": []}

            if self.bat is not None:
                bat_state = BAT_STATE[self.bat.State]
                bat_energy_empty = self.bat.EnergyEmpty
                bat_energy_full = self.bat.EnergyFullDesign if \
                                self.use_design_capacity else self.bat.EnergyFull

                bat_capacity = 100 * (self.bat.Energy - bat_energy_empty) \
                                / (bat_energy_full - bat_energy_empty)

                for capacity in BAT_LEVEL:
                    if bat_capacity <= capacity:
                        break

                output["text"] = f"{bat_state[0]}{BAT_LEVEL[capacity]}{bat_capacity:.2f}%"
                output["class"].append(bat_state[1])

                if bat_state[1] == BAT_STATE[2][1]:
                    if bat_capacity <= BAT_CRITICAL:
                        output["class"].append("critical")
                    elif bat_capacity <= BAT_WARNING:
                        output["class"].append("warning")

            print(json.dumps(output), flush=True)


if __name__ == "__main__":
    argv = sys.argv
    if len(argv) != 2 or not argv[1].isdigit():
        sys.stderr.write(f"Usage: {argv[0]} <N in '/sys/class/power_supply/BAT[N]'>\n")
        sys.exit(os.EX_USAGE)

    sys.exit(BatteryMonitor(argv[1]).run())
