# D03 - Network Segmentation and Firewalling

In the old world one had a secured DMZ (demilitarized zone) managed by an infrastructure or network team which made sure that only the frontend server's service was reachable from the internet. And on the other side this server was able to talk securely to the middleware and backend - and to nothing else. Management interfaces from a serial console or a baseband management controller were put to a dedicated management LAN with strict access controls.

This is basically what network engineers call network segmentation and firewalling. That should be basically your idea when planning a network for your microservices.

## Threat Scenarios

The container world changed also the networking. Without precautions the network where your containers are deployed within is not necessarily divided into segments with strict firewall/routing rules. In a worst case it maybe even flat and any microservice is basically able to talk to all oether microservices, including interfaces of the management backplane - your orchestration tool or e.g. the host's services.

The paradigm having one microservice per containers makes matters from the network security standpoint not easier, as some microservices need to talk to each other while others, from a security point of view, should definitely not.

Asking for the biggest trouble is exposing your management interfaces of your orchestration tool in the internet. There have been researches for it [1] and a couple of surprising discoveries [2]. Please note that also if it is being protected by a login, it means only one step for an attacker getting control over your whole environment.


Threats:

* Internet exposed management frontends/APIs from orchestration tool <sup>1)</sup>
* LAN/DMZ exposed management frontends/APIs from orchestration tool <sup>1)</sup>
* Access to the host's services from a microservice
* LAN/DMZ unnecessarily exposed microservices in the LAN from same application ( token,)
* LAN/DMZ unnecessarily exposed classical services (NFS/Samba, CI/CD appliance, DBs)
* No 100% network separation between tenants as they share the same network

Except the first scenario: The threats are that an attacker got access to the local network (LAN/DMZ), e.g. though your compromised frontend service (internet) and moves from there around in this network.


## How Do I prevent?

In a nutshell: Have a multilayer network defense like in the old world and allow only a white-list based communication. Expose to any networks only the ports you need. This includes especially management and host services.

Do proper network planning upfront:

* Choose the right network driver for your environment
* Segment your DMZ appropriately
* Multiple tenants should not share the same network
* Define necessary communication
* Protect management frontends/APIs. Never ever expose them in the internet. If you really, really need to, only allow the trusted IPs necessary.
* Also don't expose them in the DMZ. This is your management backplane. It needs strict white-list based network protection
* Protect the host services in the same manner.


## How can I find out?

First you should check whether any of the orchestration tool's management interfaces is exposed in the internet. Scan yourself from a random internet IP [3] to make sure this isn't the case.

In the DMZ: If the network is segmented and not flat scanning will be quite a task. Network information is best to request beforehand. If this is not possible you can also get an idea by logging into the host(s) and do an `ifconfig` / `ip a ls` and inspect the docker interfaces. Using docker commands you can also list the networks like `for n in $(docker network ls --format="{{.ID}}"); do docker inspect $n; done`.

If the network is not flat you probably want to scan from different networks. The first choice is the host (e.g. with `nmap -sTV -p1-65535 $(docker inspect $(docker ps -q) --format '{{.NetworkSettings.IPAddress}}')`. Another option is a specially crafted docker container containing nmap. Depending on the capabilities preconfigured and whether TCP connect scans suffice you maybe need to allow nmap in a container to send raw packets (`cap_net_raw`). Find out especially whether your host(s) or your orchestration tool have the necessary protection from the deployed microservices on a network layer.



## References

   * [3]  _The_ tool for network scanning and discovery is [nmap](https://nmap.org).

### Commercial:
   * [1] [Containers at Risk](https://www.lacework.com/containers-at-risk-a-review-of-21000-cloud-environments/)
   * [2] https://redlock.io/blog/cryptojacking-tesla

----

<sup>1)</sup> That can be ones which require credentials or even not. Examples for both: etcd, dashboards, kubelet, ...