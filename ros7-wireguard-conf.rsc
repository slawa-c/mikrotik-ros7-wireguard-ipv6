# Description
# this confix is intendet to use as example to configure wireguard vpn
# Mikrotik HAP AC with ros 7.x and tested on v7.4 
### configure wireguard client

### variables description section
:global RouteTableName "useWG";
:global WireGuardClienPrivateKey "xxxx=";
:global WireGuardServerPublicKey "yyyyy=";
:global IPv4SubnetP2P "10.200.200.0/24";
:global IPv4WireGuardClientAddress "10.200.200.10";
:global IPv4WireGuardClientNetwork "10.200.200.10";
:global IPv4SubnetLocal "192.168.11.0/24";
:global IPv4WireGuardBridgeAddress "192.168.11.1/24";
:global IPv4WireGuardBridgeNetwork "192.168.11.0";
:global IPv6SubnetLocalPrivate "fd00:c8::/64";
:global IPv6SubnetLocalPublic "2a02:ccdd:1122:3344::/64";
:global IPv6WireGuardBridgeAddress "2a02:ccdd:1122:3344::1:10/64";
:global IPv6WireGuardClientAddress "2a02:ccdd:1122:3344::20/64";
:global BridgeName "loopback0";
:global WireGuardClientInterfaceName "wireguard-client";
:global IPv4DnsServer "8.8.8.8";
:global IPv6DnsServer "2001:4860:4860::8888,2001:4860:4860::8844";
:global IPv4WireGuardServerEndpointAddress "12.34.56.78";
:global IPv4WireGuardServerEndpointPort "52180";
:global IPv4WireGuardClientListenPort "13232";

### config

/routing table
add fib name=$RouteTableName
/routing rule
add action=lookup-only-in-table disabled=no src-address=$IPv4SubnetP2P table=$RouteTableName
add action=lookup-only-in-table disabled=no src-address=$IPv4SubnetLocal table=$RouteTableName
add action=lookup-only-in-table disabled=no src-address=$IPv6SubnetLocalPrivate table=$RouteTableName
add action=lookup-only-in-table disabled=no src-address=$IPv6SubnetLocalPublic table=$RouteTableName

/interface wireguard
add listen-port=$IPv4WireGuardClientListenPort mtu=1420 name=$WireGuardClientInterfaceName private-key=$WireGuardClienPrivateKey
/interface wireguard peers
add allowed-address=$IPv4SubnetP2P,$IPv6SubnetLocalPrivate,$IPv6SubnetLocalPublic,$IPv4SubnetLocal,192.168.1.0/24,0.0.0.0/0,::/0 endpoint-address=$IPv4WireGuardServerEndpointAddress \
    endpoint-port=$IPv4WireGuardServerEndpointPort interface=$WireGuardClientInterfaceName persistent-keepalive=15s public-key=$WireGuardServerPublicKey

/interface bridge
add name=$BridgeName protocol-mode=none

/interface bridge port
add bridge=$BridgeName interface=ether5
add bridge=$BridgeName ingress-filtering=no interface=wlan2
/ip address
add address=$IPv4WireGuardClientAddress interface=$WireGuardClientInterfaceName network=$IPv4WireGuardClientNetwork
add address=$IPv4WireGuardBridgeAddress interface=$BridgeName network=$IPv4WireGuardBridgeNetwork
/ip route
add dst-address=$IPv4SubnetP2P gateway=$WireGuardClientInterfaceName
add dst-address=0.0.0.0/0 gateway=$WireGuardClientInterfaceName routing-table=$RouteTableName

/ip firewall filter
add action=accept chain=input comment="Accept established,related" connection-state=established,related
add action=accept chain=input dst-port=$IPv4WireGuardClientListenPort protocol=udp
add action=drop chain=input comment="Drop invalid" connection-state=invalid
add action=accept chain=forward comment="Accept established,related" connection-state=established,related
add action=drop chain=forward comment="Drop invalid" connection-state=invalid
add action=accept chain=forward out-interface=$WireGuardClientInterfaceName src-address=$IPv4SubnetLocal
/ip firewall nat
add action=masquerade chain=srcnat out-interface=$WireGuardClientInterfaceName src-address=$IPv4SubnetP2P
add action=masquerade chain=srcnat out-interface=$WireGuardClientInterfaceName src-address=$IPv4SubnetLocal

/ip dhcp-server
add address-pool=dhcp_pool2 interface=$BridgeName lease-time=4h name=dhcp3
/ip dhcp-server network
add address=$IPv4SubnetLocal dns-server=8.8.8.8 gateway=192.168.11.1 netmask=24

/ipv6 address
add address=$IPv6WireGuardClientAddress advertise=no interface=$WireGuardClientInterfaceName
add address=$IPv6WireGuardBridgeAddress interface=$BridgeName

/ipv6 route
add dst-address=fd00:c8::1/128 gateway=$WireGuardClientInterfaceName
add dst-address=::/0 gateway=$WireGuardClientInterfaceName routing-table=$RouteTableName

/ipv6 nd
set [ find default=yes ] dns=$IPv6DnsServer

/ipv6 firewall filter
add action=accept chain=input comment="Accept established,related" connection-state=established,related
add action=drop chain=input comment="Drop invalid" connection-state=invalid
add action=accept chain=forward comment="Accept established,related" connection-state=established,related
add action=drop chain=forward comment="Drop invalid" connection-state=invalid
