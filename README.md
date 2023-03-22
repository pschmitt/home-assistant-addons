# home-assistant-addons

[![Build](https://github.com/pschmitt/home-assistant-addons/workflows/Build/badge.svg)](https://github.com/pschmitt/home-assistant-addons/actions?query=workflow%3ABuild)

Home Assistant addons by Philipp Schmitt

Add to Home Assistant using the repository url: 
https://github.com/pschmitt/home-assistant-addons

## flicd

React to flic button presses on the Raspberry Pi.

### Installation

The flicd server needs a bluetooth controller. If you are running [Hass.io based on HassOS](https://www.home-assistant.io/blog/2018/07/11/hassio-images/), you can use the built-in controller. If you are running the older [Hass.io based on ResinOS](https://www.home-assistant.io/blog/2018/07/11/hassio-images/), you'll need to install the [Bluetooth BCM43xx](https://www.home-assistant.io/addons/bluetooth_bcm43xx/) add-on.

```
Available HCI devices found:
hci0
Trying hci0
hci0 is busy, shutting down and retrying...
Successfully bound HCI socket
Flic server is now up and running!
Initialization of Bluetooth controller done!
```

By default, flicd is going to use `hci0` bluetooth controller. If you have multiple bluetooth controllers you can configure flicd to use another controller by specifying it in `hci_dev` configuration setting of the add-on.

```
{
  "hci_dev": "hci1"
}
```

After starting the flicd add-on, you might need to restart Home Assistant.
Your flic buttons should be detected automatically if you keep pressing the button.

For more information, check the Home Assistant Forum at https://community.home-assistant.io/search?q=flicd or check the other community support channels at https://www.home-assistant.io/help/

### Usage

Check the [flic component page at home-assistant.io](https://www.home-assistant.io/components/binary_sensor.flic/).

## avahi-reflector

avahi-reflector to bridge mDNS.

## keepalived

[osixia/docker-keepalived](https://github.com/osixia/docker-keepalived) packaged
as a Home Assistant addon.

## picamera

Expose your raspicam.

## pilight

**⚠️ DEPRECATED** Please use [another addon](https://github.com/philipp-luettecke/hassio-addons/) (or fork)

## Tailscale

[Tailscale](https://tailscale.com) VPN service. This addon was originally published [here](https://github.com/tsujamin/hass-addons/tree/main/tailscale).

## zabbix-agent{,2}

Zabbix agent{,2}.

