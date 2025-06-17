# jun/17/2025 18:18:23 by RouterOS 6.49.18
# software id = 91XQ-9UAD
#
# model = CCR2004-1G-12S+2XS
# serial number = -----
/interface bridge
add name=lan-bridge
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip pool
add name=lan-pool ranges=10.10.0.100-10.10.0.200
/ip dhcp-server
add address-pool=lan-pool interface=lan-bridge lease-time=1d name=dhcp-lan
/interface bridge port
add bridge=lan-bridge interface=ether1
/ip address
add address=192.168.88.1/24 comment=defconf interface=ether1 network=\
    192.168.88.0
add address=10.0.0.150/24 comment=WAN interface=sfp-sfpplus12 network=\
    10.0.0.0
add address=10.10.0.1/24 comment=LAN-gateway interface=lan-bridge network=\
    10.10.0.0
/ip dhcp-server network
add address=10.10.0.0/24 dns-server=10.10.0.1 gateway=10.10.0.1
/ip dns
set allow-remote-requests=yes servers=1.1.1.1,8.8.8.8
/ip firewall filter
add action=accept chain=input comment="Allow DHCP for LAN" dst-port=67,68 \
    in-interface=lan-bridge protocol=udp
/ip firewall nat
add action=masquerade chain=srcnat comment="NAT for LAN" out-interface=\
    sfp-sfpplus12
/ip route
add distance=1 gateway=10.0.0.1
/system clock
set time-zone-name=Europe/Warsaw
