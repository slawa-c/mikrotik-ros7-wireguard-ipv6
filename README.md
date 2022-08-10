# mikrotik-ros7-wireguard-ipv6
Mikrotik ros7 wireguard configuration command example

## Configuration section

```
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
```