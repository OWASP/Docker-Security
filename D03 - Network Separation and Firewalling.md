# D03 - Network Separation and Firewalling

In the old world one had a secured DMZ managed by an infrastructure or network team which made sure that the frontend server's service was in a locked down fashion reachable from the internet and e.g. can talk securely to the middleware and backend -- and to nothing else. Management interfaces from a serial console or a baseband management controller were put to a dedicated LAN with strict access controls.

This should be bascially your starting point when planning a network for your microservices.

## Threat Scenarios

The container world changed the networking. The network is not necessarily divided into zones with strict firewall/routing rules. Without precautions it maybe even flat and every microservice is basically able to talk to all microservices, including interfaces of the management backplane - your orchestration tool or e.g. the host's services.

The paradigm having one microservice per containers makes matters not easier, as some microservices need to talk to each other while others should definitely not from the security standpoint.

Threats:

* Internet exposed management frontends/APIs from orchestration tool <sup>1)</sup>
* LAN/DMZ exposed management frontends/APIs from orchestration tool <sup>1)</sup>
* LAN/DMZ unnecessarily exposed microservices in the LAN from same application ( token,)
* LAN/DMZ unnecessarily exposed classical services (NFS/Samba, CI/CD appliance, DBs)
* No 100% network separation between tenants as they share the same network
* Access to host network from a microservice

Except the first scenario: The threats are that an attacker got access to the local network (LAN/DMZ), e.g. though your compromised frontend service (internet) and moves from there around in this network.


## How Do I prevent?

In one line: Have a mulitlayer network defense like in the old world and allow only a white-list based communication.

Do proper network planning:

* Choose the right network driver for your environment
* Segment your DMZ appropriately
* Muliple tenants should not share the same network
* Define necessary communication
* Protect management frontends/APIs. Never ever expose them in the internet.
* Also don't expose them in the DMZ. This is your management backplane. It needs strict white-list based network protection
* Protect the host via white-list


## How can I find out?

If the network is segmented and not flat it is quite a task. Network information is best to request beforehand.

Just reading the output from host-based firewalls like `iptables -t nat -L -nv` and  `iptables -L -nv` becomes a tedious task. _The_ tool for network scanning and discovery is nmap [1]. If the network is not flat you probably want to scan from different source IPs. That could be hosts and/or a specially crafted docker container containing nmap. Depending on the capabilities preconfigured and whether TCP connect scans suffice you maybe need to allow nmap in a container to send raw packets (`cap_net_raw`).


## References

[1] [https://nmap.org/](https://nmap.org)


----

<sup>1)</sup> That can be ones which require credentials or even not. Examples for both: etcd, dashboards, kubelet, ...