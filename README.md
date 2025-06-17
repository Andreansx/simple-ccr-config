<div align="center">
  
# simple-ccr-config
![Static Badge](https://img.shields.io/badge/RouterOS-gray?style=for-the-badge&logo=mikrotik&logoColor=white&logoSize=auto)
</div>

## Here is a very basic, essential configuration for the scenario depicted below.  

>[!IMPORTANT]
>**Remember to replace my IP addresses, interface numbers and names with ones of your choosing**

### What we want to achieve:
- Internet access on a ThinkPad T450s with Arch Linux using **NetworkManager**
- SSH access for CCR management
- LAN network with **10.10.0.0/24** address
- DHCP server for the LAN Network
- Masquerading the packets from LAN network when accessing internet throught ISP routers network 

### Hardware:
- MikroTik CCR2004-1G-12S+2XS
- Lenovo ThinkPad T450s
- ISP Router
- 1x 1GbE SFP RJ45 plug

## IP addresses
- ISP Router IP address is 10.0.0.1/24  
- CCR WAN is 10.0.0.150/24  
- CCR DHCP LAN is 10.10.0.1/24
- LAN DHCP Pool is 10.10.0.2-10.10.0.254

### Resetting network with NetworkManager
```zsh
nmcli con down <Connection name>
nmcli con up <Connection name>
```
### Switching from static IP to DHCP with `nmcli`
```zsh
nmcli con modiy <Connection name> ipv4.gateway ''\
  ipv4.address ''\
  ipv4.method auto
```

# Configuration
### First step is updating the RouterOS software and RouterBOARD firmware
```rsc
/system package update check-for-updates
/system package update download
/system reboot
```
### Then we need to setup a WAN IP address
```rsc
/ip address add address=10.0.0.150/24 interface=sfp-sfpplus12 name="WAN"
```
### Next let's setup a IP Addresses pool for LAN DHCP
```rsc
/ip pool add name="lan-pool" ranges=10.10.0.2-10.10.0.254
```
### We then need to create the DHCP server
```rsc
/ip dhcp-server add name="lan-dhcp" address-pool="lan-pool" interface="ether1"
```
### Let's create a network for the DHCP LAN
```rsc
/ip dhcp-server network add comment="LAN DHCP network" address=10.10.0.0/24 gateway=10.10.0.1 dns-server=1.1.1.1,8.8.8.8
```
