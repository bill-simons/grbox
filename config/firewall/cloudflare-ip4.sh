#!/bin/sh
#sudo ipset destroy cloudflare
#sudo ipset destroy cloudflare-ip4
#sudo ipset destroy cloudflare-ip6
#sudo ipset create cloudflare-ip4 hash:net family inet hashsize 1024
#sudo ipset create cloudflare-ip6 hash:net family inet6 hashsize 1024
#sudo ipset create cloudflare list:set
#sudo ipset add cloudflare cloudflare-ip4
#sudo ipset add cloudflare cloudflare-ip6

ipset add cloudflare-ip4 103.21.244.0/22
ipset add cloudflare-ip4 103.22.200.0/22
ipset add cloudflare-ip4 103.31.4.0/22
ipset add cloudflare-ip4 104.16.0.0/12
ipset add cloudflare-ip4 108.162.192.0/18
ipset add cloudflare-ip4 127.0.0.1
ipset add cloudflare-ip4 131.0.72.0/22
ipset add cloudflare-ip4 141.101.64.0/18
ipset add cloudflare-ip4 162.158.0.0/15
ipset add cloudflare-ip4 172.64.0.0/13
ipset add cloudflare-ip4 173.245.48.0/20
ipset add cloudflare-ip4 188.114.96.0/20
ipset add cloudflare-ip4 190.93.240.0/20
ipset add cloudflare-ip4 197.234.240.0/22
ipset add cloudflare-ip4 198.41.128.0/17

