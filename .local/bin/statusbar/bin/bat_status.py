#!/usr/bin/env python3
"""
    Battery module for statusbar

    Dependencies (on Debian, use 'apt'):
        -> python3-gi
        -> python3-pydbus
        -> fonts-font-awesome

    NOTE: Only one process (per session) of this script is allowed!
"""

import os
import sys
import signal

from gi.repository.GLib import MainLoop
from pydbus import SystemBus


IFACE = "org.freedesktop.UPower"
IFACE_PATH = "/org/freedesktop/UPower"
RUNTIME_DIR = f"{os.getenv('XDG_RUNTIME_DIR')}/statusbar-modules-{os.getenv('XDG_SESSION_ID')}"

BAT_DISCHARGE_STATUS = [[10, "critical"], [30, "warning"]]

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
    def __init__(self, batn, design):
        self.use_design_capacity = design
        self.bat_path = f"{IFACE_PATH}/devices/battery_BAT{batn}"
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

        self.loop.run()

    def end_loop(self, signal_num=None, frame=None):
        """ End event loop """
        del signal_num, frame
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
            text = ''
            css_class = ''

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

                if bat_state[1] == BAT_STATE[2][1]:
                    if bat_capacity <= BAT_DISCHARGE_STATUS[0][0]:
                        css_class = BAT_DISCHARGE_STATUS[0][1]
                    elif bat_capacity <= BAT_DISCHARGE_STATUS[1][0]:
                        css_class = BAT_DISCHARGE_STATUS[1][1]

                if css_class == '':
                    css_class = bat_state[1]

                text = f"{bat_state[0]}{BAT_LEVEL[capacity]}{bat_capacity:.2f}%"

            print(f'{{"text": "{text}", "class": "{css_class}"}}', flush=True)


if __name__ == "__main__":
    arg = sys.argv[1:]

    if not ((len(arg) == 1 or (len(arg) == 2 and arg[1] == '--design')) and arg[0].isdigit()):
        sys.stderr.write("Usage: bat_status.py <battery number> [--design]\n")
        sys.exit(1)

    BatteryMonitor(arg[0], 1 if len(arg) == 2 else 0).run()
