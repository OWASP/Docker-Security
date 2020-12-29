# D03 - Network Segmentation and Firewalling

In the old world one had a secured DMZ (demilitarized zone) managed by an infrastructure or network team which made sure that only the frontend server's service was reachable from the internet. And on the other side this server was able to talk securely to the middleware and backend - and to nothing else. Management interfaces from a serial console or a baseband management controller were put to a dedicated management LAN with strict access controls.

This is basically what network engineers call network segmentation and firewalling. That should be basically your idea when planning a network for your microservices.

## Threat Scenarios

The container world changed also the networking. Without precautions the network where your containers are deployed within is not necessarily divided into segments with strict firewall/routing rules. In a worst case it maybe even flat and any microservice is basically able to talk to all other microservices, including interfaces of the management backplane - your orchestration tool or e.g. the host's services.

The paradigm having one microservice per container makes matters from the network security standpoint not easier, as some microservices need to talk to each other while others, from a security point of view, should definitely not.

__Asking for the biggest trouble is exposing your management interfaces of your orchestration tool in the internet__. There have been researches for it [1] and a couple of surprising discoveries [2]. Please note that also if it is being protected by a login, it means only one step for an attacker getting control over your whole environment.


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
* In an orchestrated environment make sure that you have
  * first a proper ingress network and routing policy
  * secondly a proper egress network policy (restrict downloads from the internet as much as possible)
  * then decide for which container intercommunication is needed and may posed a threat


## How can I find out?

First you should check whether any of the orchestration tool's management interfaces is exposed in the internet. Scan yourself from a random internet IP [3] to make sure this isn't the case. If your environment is volatile it also can't hurt to do regular scanning from the outside to make sure that never happens. Or at least when it happens, you will get notified and can take immediate action.

Secondly you should view this from an attacker perspective: If that one has gotten complete control over a container, what can he/she do? Make sure that from the container he can't reach a) the orchestration management interfaces b) anything else which could be of value for him (e.g. file servers in the LAN or any other container he doesn't need to "speak" to). A poor man's solution is exec into the container and use netcat/nc to check. Another option is a manually crafted docker container containing nmap.

The prerequisite is to understand the network. If you didn't build the network yourself in nowadays orchestration environments that is often not easy. Either you ask somebody who set this up or you need to get a picture yourself. There's not a straightforward method. You should understand first what the external and internal network interfaces from the host are and in which network they are `ip a / tp ro` is your friend. The same or similar you can do for your containers, either by exec'ing those commands in the container or by just listing that from the host like `for n in $(docker network ls --format="{{.ID}}"); do docker inspect $n; done`.

You probably want to scan from different networks. The first choice is from the same LAN as from the host. On the host targeting the containers might be a good idea (e.g.`nmap -sTV -p1-65535 $(docker inspect $(docker ps -q) --format '{{.NetworkSettings.IPAddress}}')`. Repeating the same from a container might be also a good idea to check what is in reach of an attacker. 



## References

   * [3]  _The_ tool for network scanning and discovery is [nmap](https://nmap.org).

### Commercial:
   * [1] [Containers at Risk](https://www.lacework.com/containers-at-risk-a-review-of-21000-cloud-environments/)
   * [2] RedLock: [Lessons from the Cryptojacking Attack at Tesla](https://redlock.io/blog/cryptojacking-tesla), Arstechnica: Tesla cloud resources are [hacked to run cryptocurrency-mining malware](https://arstechnica.com/information-technology/2018/02/tesla-cloud-resources-are-hacked-to-run-cryptocurrency-mining-malware/).

----

<sup>1)</sup> That can be ones which require credentials or even not. Examples for both: etcd, dashboards, kubelet, ...
