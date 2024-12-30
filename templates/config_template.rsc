### Custom configuration for {{ params['call'] }} at {{ params['location'] }}
### Generated {{ params['date'] }}
###
### Put your device on your local LAN with internet access.
###
### 1. Find the commented lines for ntp and uncomment the line for your RouterOS version
###
### 2. Connect to the device using Winbox using the MAC address to reference the device
###
### 3. OPTIONAL: Do these three steps manually first, as they will do reboots
### /system package update install
### /system routerboard upgrade
###
### 4. /system reset-configuration no-defaults=yes
###
### 6. Upload your personalized .rsc file using the Files menu
### 7. Open a terminal window (New Terminal)
### 8. Type "/import verbose=yes file=name-of-imported-file.rsc"  (you can autocomplete the filename using TAB key)
###
### Basic device configuration
/ip dhcp-client add add-default-route=yes dhcp-options=hostname,clientid disabled=no interface=ether1
/ping count=5 8.8.8.8
/interface wireless
set 0 country=no_country_set
/system clock set time-zone-name=America/Los_Angeles
/user
add group=full name=KD7DK password={{ params['random_password'] }}
add group=full name=KK7LZM password={{ params['random_password'] }}
add group=full name=NQ1E password={{ params['random_password'] }}
add group=full name=dylan password={{ params['random_password'] }}
add group=full name=eo password={{ params['random_password'] }}
add group=full name=kc7aad password={{ params['random_password'] }}
add group=full name=kennyr password={{ params['random_password'] }}
add group=full name=nigel password={{ params['random_password'] }}
add group=full name=nr3o password={{ params['random_password'] }}
add group=full name=osburn password={{ params['random_password'] }}
add group=full name=tom password={{ params['random_password'] }}
add group=full name=va7dbi password={{ params['random_password'] }}
add group=full name=ve7alb password={{ params['random_password'] }}
add group=read name=monitoring password={{ params['random_password'] }}
/console clear-history
/tool fetch url="https://monitoring.hamwan.net/keys/KD7DK.key"
/tool fetch url="https://monitoring.hamwan.net/keys/KK7LZM.key"
/tool fetch url="https://monitoring.hamwan.net/keys/NQ1E.key"
/tool fetch url="https://monitoring.hamwan.net/keys/dylan.key"
/tool fetch url="https://monitoring.hamwan.net/keys/eo.key"
/tool fetch url="https://monitoring.hamwan.net/keys/kc7aad.key"
/tool fetch url="https://monitoring.hamwan.net/keys/kennyr.key"
/tool fetch url="https://monitoring.hamwan.net/keys/monitoring.key"
/tool fetch url="https://monitoring.hamwan.net/keys/nigel.key"
/tool fetch url="https://monitoring.hamwan.net/keys/nr3o.key"
/tool fetch url="https://monitoring.hamwan.net/keys/osburn.key"
/tool fetch url="https://monitoring.hamwan.net/keys/tom.key"
/tool fetch url="https://monitoring.hamwan.net/keys/va7dbi.key"
/tool fetch url="https://monitoring.hamwan.net/keys/ve7alb.key"
# Delay here?
/ ping count=3 8.8.8.8
/user ssh-keys
import public-key-file=KD7DK.key user=KD7DK
import public-key-file=KK7LZM.key user=KK7LZM
import public-key-file=NQ1E.key user=NQ1E
import public-key-file=dylan.key user=dylan
import public-key-file=eo.key user=eo
import public-key-file=kc7aad.key user=kc7aad
import public-key-file=kennyr.key user=kennyr
import public-key-file=monitoring.key user=monitoring
import public-key-file=nigel.key user=nigel
import public-key-file=nr3o.key user=nr3o
import public-key-file=osburn.key user=osburn
import public-key-file=tom.key user=tom
import public-key-file=va7dbi.key user=va7dbi
import public-key-file=ve7alb.key user=ve7alb
/system routerboard settings set boot-device=try-ethernet-once-then-nand auto-upgrade=yes
/system logging action set 3 bsd-syslog=no name=remote remote=44.25.0.8 remote-port=514 src-address=0.0.0.0 syslog-facility=daemon syslog-severity=auto target=remote
/system logging add action=remote disabled=no prefix="" topics=info
/system logging add action=remote disabled=no prefix="" topics=warning
/system logging add action=remote disabled=no prefix="" topics=error
/snmp
set enabled=yes contact="#hamwan-support on libera.chat"
/snmp community
set name=hamwan addresses=44.24.240.0/20,44.25.0.0/16 read-access=yes write-access=no numbers=0

# For RouterOS 6.x uncomment this line
#/system ntp client set enabled=yes primary-ntp=44.25.0.4 secondary-ntp=44.24.245.4
# For RouterOS 7.x uncomment this line
#/system ntp client set enabled=yes servers=44.25.0.4,44.24.245.4

/ip firewall filter remove [find dynamic=no]
/ip firewall mangle add action=change-mss chain=output new-mss=1378 protocol=tcp tcp-flags=syn tcp-mss=!0-1378
/ip firewall mangle add action=change-mss chain=forward new-mss=1378 protocol=tcp tcp-flags=syn tcp-mss=!0-1378

# clear out pre-existing entries we don't want
/ip dhcp-server remove [find]
/ip dhcp-server network remove [find]
/ip address remove [find interface~"^wlan1"]

# This wants to be renaming lo interface on ROS7
/interface bridge add fast-forward=no name=loopback0

# Disable most services for added security.  We recommend disabling winbox and using SSH as the primary access method.
# You can re-enable winbox when you need it for maintenance.
/ip service disable telnet,ftp,www,api,api-ssl
###/ip service disable winbox
/ip service set ssh port=222
/ip dns set servers=44.25.0.1,44.25.1.1
/ip dns set allow-remote-requests=no

# Wireless configuration, first the channels in a list, and then the interface itself which uses that list.
/interface wireless channels
add band=5ghz-onlyn comment="Cell sites radiate this at 0 degrees (north)" frequency=5920 list=HamWAN name=Sector1-5 width=5
add band=5ghz-onlyn comment="Cell sites radiate this at 120 degrees (south-east)" frequency=5900 list=HamWAN name=Sector2-5 width=5
add band=5ghz-onlyn comment="Cell sites radiate this at 240 degrees (south-west)" frequency=5880 list=HamWAN name=Sector3-5 width=5
add band=5ghz-onlyn comment="Cell sites radiate this at 0 degrees (north)" frequency=5920 list=HamWAN name=Sector1-10 width=10
add band=5ghz-onlyn comment="Cell sites radiate this at 120 degrees (south-east)" frequency=5900 list=HamWAN name=Sector2-10 width=10
add band=5ghz-onlyn comment="Cell sites radiate this at 240 degrees (south-west)" frequency=5880 list=HamWAN name=Sector3-10 width=10

# Special attention may need be needed here for some hardware
/interface wireless
# Configure this line. For example, set 0 radio-name="AE7SJ/Monroe-Paine"
set 0 radio-name="{{ params['call'] }}/{{ params['location'] }}-{{ params['destcell'] }}"
set 0 rx-chains=0,1 tx-chains=0,1
set 0 disabled=no country=no_country_set frequency-mode=superchannel band=5ghz-onlyn mode=station scan-list="HamWAN" ssid=HamWAN wireless-protocol=nv2
/ip dhcp-client add add-default-route=yes dhcp-options=hostname,clientid disabled=no interface=wlan1
{% if request.form['ethernet_config'] == "client" %}
# LAN configuration for DHCP client of another device (e.g. router)
/ip dhcp-client [find interface=ether1] add-default-route=no use-peer-dns=no dhcp-options=hostname,clientid
{% endif %}{% if request.form['ethernet_config'] == "server" %}
# LAN configuration for masquerade firewall config (this device is gateway)
/ip address add address=192.168.88.1/24 interface=ether1
/ip pool add name=dhcp-pool ranges=192.168.88.100-192.168.88.199
/ip dhcp-server network add address=192.168.88.0/24 dns-server=44.25.0.1,44.25.1.1 gateway=192.168.88.1
/ip dhcp-server add address-pool=dhcp-pool interface=ether1 name=dhcp disabled=no
/ip firewall nat add chain=srcnat action=masquerade out-interface=wlan1
{% endif %}
# Final configurations per client
# Set location using decimal degrees notation. For example 47.667678,-122.351328
/snmp set location={{ params['latitude'] }},{{ params['longitude'] }}
# Set identity. For example, AE7SJ-Monroe
/system identity set name="{{ params['call'] }}-{{ params['location'] }}"
/user set admin password={{ params['admin_password'] }}
/console clear-history
