Firewall configuration files using Ubuntu 17.04 ufw "uncomplicated firewall" 

* drop blacklist -- prevent persistent attackers (listed in ipset "blacklist" list) from connecting to any services
* throttle ssh probes -- recipe from the Internet to force a delay (here 60 seconds) between ssh login attempts
* require http from proxy -- disallow connections to local web server except from traffic being redirected from Cloudflare service (or local network)


ipv6 rules are simpler because I don't allow ssh connections over ipv6 (configured in router firewall).



Also attached are current ipset lists (blacklists and cloudflare IP lists) and scripts to generate cloudlfare ipset lists.   A major flaw in this scheme is that the st of valid cloudflare IPs may change and there is currently no monitoring for a changed set of valid IPs.   An alternative would be to use Cloudflare's "Authenticated origin pulls" that 

> allow you to cryptographically verify that requests to your origin 
> server have come from Cloudflare using a TLS client certificate. This 
> prevents clients from sending requests directly to your origin, 
> bypassing security measures provided by Cloudflare, such as IP and Web 
> Application Firewalls, logging, and encryption.

But this requires web server configuration (and I learned about this feature after setting up the firewall rules).



<u>before.rules</u>

```sh
##############################################################################
#
# Filter out bad actors 
#
:zzz_drop_blacklist - [0:0]
:zzz_throttle_ssh_probes - [0:0]
:zzz_require_http_from_proxy - [0:0]

# prevent all previously-identified egregious attackers from connecting
-A zzz_drop_blacklist -m set --match-set blacklist src -j LOG --log-prefix "MY-FIREWALL-BLACKLIST: "
-A zzz_drop_blacklist -m set --match-set blacklist src -j DROP

# lock out persistent ssh probes
-A zzz_throttle_ssh_probes -p tcp -m tcp --dport 22 -m state --state NEW -m recent --update --seconds 60 --name DEFAULT --mask 255.255.255.255 --rsource -m limit --limit 3/min --limit-burst 10 -j LOG --log-prefix "MY-FIREWALL-THROTTLE: "
-A zzz_throttle_ssh_probes -p tcp -m tcp --dport 22 -m state --state NEW -m recent --update --seconds 60 --name DEFAULT --mask 255.255.255.255 --rsource -j DROP
-A zzz_throttle_ssh_probes -p tcp -m tcp --dport 22 -m state --state NEW -m recent --set --name DEFAULT --mask 255.255.255.255 --rsource

# allow http traffic only from cloudflare reverse proxy 
-A zzz_require_http_from_proxy -p tcp -m tcp --dport 80  -m set ! --match-set cloudflare src -m limit --limit 3/min --limit-burst 10 -j LOG --log-prefix "MY-FIREWALL-HTTP: "
-A zzz_require_http_from_proxy -p tcp -m tcp --dport 80  -m set ! --match-set cloudflare src -j DROP
-A zzz_require_http_from_proxy -p tcp -m tcp --dport 443 -m set ! --match-set cloudflare src -m limit --limit 3/min --limit-burst 10 -j LOG --log-prefix "MY-FIREWALL-HTTPS: "
-A zzz_require_http_from_proxy -p tcp -m tcp --dport 443 -m set ! --match-set cloudflare src -j DROP

-A ufw-before-input -j zzz_drop_blacklist
-A ufw-before-input -j zzz_throttle_ssh_probes
-A ufw-before-input -j zzz_require_http_from_proxy
##############################################################################
```


<u>before6.rules</u>  (ipv6 rules)

```sh
# allow http traffic only from cloudflare reverse proxy
:zzzzzz_req_http_from_proxy - [0:0]
-A zzzzzz_req_http_from_proxy -p tcp -m tcp --dport 80  -m set ! --match-set cloudflare src -m limit --limit 3/min --limit-burst 10 -j LOG --log-prefix "MY-FIREWALL-HTTP: "
-A zzzzzz_req_http_from_proxy -p tcp -m tcp --dport 80  -m set ! --match-set cloudflare src -j DROP
-A zzzzzz_req_http_from_proxy -p tcp -m tcp --dport 443 -m set ! --match-set cloudflare src -m limit --limit 3/min --limit-burst 10 -j LOG --log-prefix "MY-FIREWALL-HTTPS: "
-A zzzzzz_req_http_from_proxy -p tcp -m tcp --dport 443 -m set ! --match-set cloudflare src -j DROP
-A ufw6-before-input -j zzzzzz_req_http_from_proxy
```