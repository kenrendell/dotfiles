#!/usr/bin/env python
'''
Get the current battery status

Usage: bat_status.py <battery number> [--design]
Dependencies: python-gobject, python-pydbus
'''

import sys
import signal

from gi.repository.GLib import MainLoop
from pydbus import SystemBus

BAT_STATE = {
    0: { 'label': ' ', 'class': 'unknown' },
    1: { 'label': ' ', 'class': 'charging' },
    3: { 'label': ' ', 'class': 'empty' },
    4: { 'label': ' ', 'class': 'full' },
    5: { 'label': '',   'class': 'pending_charge' },
    6: { 'label': '',   'class': 'pending_discharge' }
}

BAT_STATE[2] = {
    'label': '', 'class': 'discharging',
    'warn': { 'level': 30, 'class': 'warning' },
    'crit': { 'level': 10, 'class': 'critical' }
}

BAT_LEVEL = {
    4:   '▏  ▏', 8:   '▎  ▏', 12:  '▍  ▏', 16:  '▌  ▏',
    20:  '▋  ▏', 24:  '▊  ▏', 28:  '▉  ▏', 32:  '█  ▏',
    36:  '█▏ ▏', 40:  '█▎ ▏', 44:  '█▍ ▏', 48:  '█▌ ▏',
    52:  '█▋ ▏', 56:  '█▊ ▏', 60:  '█▉ ▏', 64:  '██ ▏',
    68:  '██▏▏', 72:  '██▎▏', 76:  '██▍▏', 80:  '██▌▏',
    84:  '██▋▏', 88:  '██▊▏', 92:  '██▉▏', 100: '███▏'
}

class BatteryMonitor:
    ''' Class for Battery Monitoring '''
    def __init__(self, batn, design):
        self.bus = SystemBus()
        self.loop = MainLoop()
        self.bat = self.upower = None
        self.use_design_capacity = design
        self.bat_path = f'/org/freedesktop/UPower/devices/battery_BAT{batn}'

    def run(self):
        ''' Run the event loop '''
        self.upower = self.bus.get('org.freedesktop.UPower', '/org/freedesktop/UPower')

        if self.bat_path in self.upower.EnumerateDevices():
            self.add_battery(self.bat_path)
        else:
            self.upower.onDeviceAdded = self.add_battery

        # Handle SIGTERM and SIGINT signal
        endloop = lambda signum, fname: self.loop.quit()
        signal.signal(signal.SIGINT, endloop)
        signal.signal(signal.SIGTERM, endloop)

        self.loop.run()
        return 0

    def add_battery(self, dev_path):
        ''' Add the battery when the battery exists '''
        if dev_path == self.bat_path:
            self.upower.onDeviceRemoved = self.remove_battery
            if self.upower.onDeviceAdded is not None:
                self.upower.onDeviceAdded = None

            self.bat = self.bus.get('org.freedesktop.UPower', self.bat_path)
            self.bat.onPropertiesChanged = self.update_battery
            self.update_battery()

    def remove_battery(self, dev_path):
        ''' Remove the battery when the battery not exists '''
        if dev_path == self.bat_path:
            self.upower.onDeviceAdded = self.add_battery
            self.upower.onDeviceRemoved = None

            self.bat.onPropertiesChanged = None
            self.bat = None
            self.update_battery()

    def update_battery(self, ifname=None, changed_props=None, invalid_props=None):
        ''' Print the updated battery info '''
        del ifname, invalid_props
        if (changed_props is None) or (('Energy' in changed_props) or ('State' in changed_props)):
            text = ''
            css_class = ''

            if self.bat is not None:
                bat_state = BAT_STATE[self.bat.State]
                bat_energy_empty = self.bat.EnergyEmpty
                bat_energy_full = self.bat.EnergyFullDesign if \
                    self.use_design_capacity else self.bat.EnergyFull

                # Calculate the battery capacity percentage
                bat_capacity = 100 * (self.bat.Energy - bat_energy_empty) \
                    / (bat_energy_full - bat_energy_empty)

                # Find the battery capacity label
                for key, value in BAT_LEVEL.items():
                    if bat_capacity <= key:
                        bat_level = value
                        break

                if bat_state['class'] == BAT_STATE[2]['class']:
                    if bat_capacity <= BAT_STATE[2]['crit']['level']:
                        css_class = BAT_STATE[2]['crit']['class']
                    elif bat_capacity <= BAT_STATE[2]['warn']['level']:
                        css_class = BAT_STATE[2]['warn']['class']

                if css_class == '':
                    css_class = bat_state['class']

                text = f"{bat_state['label']}{bat_level}{bat_capacity:.2f}%"

            print(f'{{"text": "{text}", "class": "{css_class}"}}', flush=True)


if __name__ == '__main__':
    arg = sys.argv[1:]

    # Match the usage restrictions
    if len(arg) != 1 and (len(arg) != 2 or arg[1] != '--design'):
        sys.stderr.write('Usage: bat_status.py <battery number> [--design]\n')
        sys.exit(1)

    sys.exit(BatteryMonitor(arg[0], 1 if len(arg) == 2 else 0).run())
