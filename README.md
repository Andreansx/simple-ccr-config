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

>[!NOTE]
>Keep in mind that I am **not** using **bridges** here.  

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
nmcli con modify <Connection name> ipv4.gateway ''\
  ipv4.address ''\
  ipv4.method auto
```

# Configuration
### First step is updating the RouterOS software and RouterBOARD firmware
First you should backup your config:
```rsc
/system backup save name=auto-backup
```

```rsc
/system package update check-for-updates
/system package update download
/system reboot
/system routerboard upgrade
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
### Now a very imporant part is adding a masquerade action for NAT
```rsc
/ip firewall nat add chain=srcnat action=masquerade out-interface=sfp-sfpplus12
```
### A good practise is adding DNS servers for the router itself
```rsc
/ip dns set servers=1.1.1.1,8.8.8.8 allow-remote-requests=yes
```
### Also we need to add a default route for the router
```rsc
/ip route add gateway=10.0.0.1
```
### After this, we can ping `google.com` to check if we have a connection to the internet along with DNS functionality
```zsh
ping google.com
PING google.com (142.250.203.206) 56(84) bytes of data.
64 bytes from waw02s22-in-f14.1e100.net (142.250.203.206): icmp_seq=1 ttl=118 time=14.1 ms
64 bytes from waw02s22-in-f14.1e100.net (142.250.203.206): icmp_seq=2 ttl=118 time=14.1 ms
64 bytes from waw02s22-in-f14.1e100.net (142.250.203.206): icmp_seq=3 ttl=118 time=13.8 ms
64 bytes from waw02s22-in-f14.1e100.net (142.250.203.206): icmp_seq=4 ttl=118 time=13.7 ms
^C
--- google.com ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3005ms
rtt min/avg/max/mdev = 13.726/13.914/14.111/0.171 ms
```
