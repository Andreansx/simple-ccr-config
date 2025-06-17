<div align="center">
  
# simple-ccr-config
![Static Badge](https://img.shields.io/badge/RouterOS-gray?style=for-the-badge&logo=mikrotik&logoColor=white&logoSize=auto)
</div>

## Here is a very basic, essential configuration for the scenario depicted below.

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
ISP Router IP address is 10.0.0.1/24  
CCR WAN is 10.0.0.150/24  
CCR DHCP LAN is 10.10.0.1/24
LAN DHCP Pool is 10.10.0.2-10.10.0.254
