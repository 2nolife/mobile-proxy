# Mobile Proxy 

A small unit providing proxy services over mobile 3G network. 
Does not need connection to a router. All traffic goes in and out through mobile network.

Unit comes configured with all software installed and accounts created. 
Insert a SIM card, plug into a power supply, ready to go! Proxy services await client connection
on a server. Connect to the server SOCKS5 port and the unit will take you out to the Internet 
via SOCKS5 proxy, connect to the VNP port and the unit will use its VNP server. Public IP address
can be changed on demand.    

```
  [website] <-------------> [website]          
             proxy |  VPN   
                   |                  
 ______         (( o ))               ________              ________
| unit | ----->   /_\   -----------> | server | <--------- | client |
|______|   3G    /\_/\   SSH tunnel  |________|  services  |________|
```

## Services 
  * SSH access
  * HTTP proxy
  * SOCKS proxy
  * VPN
  * IP changing

## Hardware parts

* RaspberryPI board (Pi Model B or better)
* Huawei 3G modem (E3372 or E8372)
* SD memory card (4GB or better)
* Power supply (5V 1A or better)

# How to? 

You can find your configuration on the unit slip. 
Assuming the unit was configured for:
  * ports starting from `3000` 
  * server `example.org`
  * password `secret`

## SSH

* Host `pi@example.org`
* Password `secret`

### Login to the unit

`ssh -p 3000 pi@example.org`

### Upload or download a file to the unit

```
scp -P 3000 file_to_upload pi@example.org~/
scp -P 3000 pi@example.org~/file_to_download .
```

### Reboot or shut down

Do not just unplug it from the power supply. 
  * Login to the unit
  * Reboot `sudo reboot`
  * Shut down `sudo shutdown -h now`

### Change password

To change the password for SSH, Control Panel and Proxy: 
  * Login to the unit
  * `cd ~/mobile-proxy/unit`
  * `./change-pwd.sh new_password`

### Re-configure for a new server account

Be careful, the unit will not come online after reboot if: 
  * The server did not accept a new key 
  * Invalid new account was used
  * Invalid port was used
  * Any other technical fault

It is better to leave the existing key or to have the unit connected with an 
ethernet cable just in case if something goes wrong.

To re-configure:  
  * Login to the unit
  * `cd ~/mobile-proxy/bin`
  * `python3 setup.py new_user new_port`
  * `cd ~/mobile-proxy/unit`
  * `./change-key.sh`
  * Reboot for changes to take effect `sudo reboot` 

### Enable or disable services

By default all services are enabled.
VPN and SOCKS services do not support authentication, disable if not using.  

Valid service names: 
  * `http`
  * `socks`
  * `vpn`

To enable or disable a service:
  * Login to the unit
  * `cd ~/mobile-proxy/unit`
  * `./service.sh enable service_name`
  * `./service.sh disable service_name`
  * Reboot for changes to take effect `sudo reboot`

## Control Panel

http://example.org:3001

Use `admin / secret` to authenticate when prompted.

### Change public IP address

* Login to Control Panel `Modem` section.
* Click `My IP` to display the current IP address.
* Click `Reconnect` and wait for one minute (the connection will go down).
* Refresh the page and click `My IP` again. If the new IP is the same then this SIM
  card does not support IP changing via reconnect. Click `Reboot` and wait for one minute 
  until the connection is restored. Public IP should be changed for sure.   

## HTTP proxy

Use from within a browser.

Proxy configuration:
  * Type `HTTP`
  * Host `example.org`
  * Port `3002`
  * Authentication `proxy / secret`

## SOCKS5 proxy

Use from within a browser.

Proxy configuration:
  * Type `SOCKS5`
  * Host `example.org`
  * Port `3003`
  * Authentication not supported

## VPN

* Install [OnenVPN](https://openvpn.net/download-open-vpn/) client
* Download setup from the unit:
    ```
    scp -P 3000 pi@example.org:~/mobile-proxy/unit/mp.ovpn .
    ```
* Use this `OVPN` file to configure the client:
  * Give profile a proper name such as `Mobile Proxy`
  * Edit the profile and type `example.org` into `Server Override`

VPN configuration:
  * Host `example.org`
  * Port `3004`
  * Authentication not supported

# Testing

## Proxy 

Setup your environment to use one of the proxy services. 
  * Query [Browser Leaks](https://browserleaks.com/ip) for more details
  * Speed test with [Broadband Speed Checker](https://www.broadbandspeedchecker.co.uk)

## Unit

Login to the unit.
* SSH tunnels `ps aux | grep ssh`
* Open ports `netstat -an | grep LISTEN`
* Control Panel log `tail -f ~/mobile-proxy/change-ip/output/weblet.log`

## License ##

This code is open source software licensed under the [GNU Lesser General Public License v3](http://www.gnu.org/licenses/lgpl-3.0.en.html).
