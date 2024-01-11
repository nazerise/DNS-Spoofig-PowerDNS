# DNS-Spoofig-PowerDNS
This LUA script checks domains status and if the domains are not reachable from PowerDNS machine resolves the doamin to custome IP( ex. 192.168.1.100 ) instead of its real IP.

The Custome IP can be your VPN machine where the domain is reachable from there, thus the client can open the website.

Add this LUA script to PowerDNS server.
