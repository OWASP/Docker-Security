# D04 - Secure Defaults and Hardening

While D03 - Network Separation and Firewalling for sure provides at least can an extra layer of protection for any network based services on the e.g. host, the orchestration tool and other places: it doesn't address the root cause. It mitigates the symptom. Best practice though is not to start any service which is not needed. And those services which are needed need to be locked down properly.

## Threat Scenarios

Basically there are three "domains" where services can be attacked:

* Interfaces from the orchestration tool. Typically: dashboard, etcd, API
* Interfaces from the Host. Typically: RPC services, OpenSSHD, avahi, systemd-services
* Interfaces within the container, either from the microservice (e.g. spring-boot) or from the distribution.


## How Do I prevent?

For your orchestration tool it is crucial to know what service is running and whether it is protected properly or has a weak default configuration.

For your host the first step is picking the right distribution. E.g. -- a standard Ubuntu system is a standard Ubuntu system. There might be other distributions more specialised on hosting containers. Then install a minimal distribution. Desktop applications, compiler environments or any server applications have no business here. They all add an attack surface. Think of a minimal bare metal system. When you pick an OS for the host,
find out the support time left (EOL).

Also for the container, best practise is: do no install unnecessary packages [1]. Alpine Linux has a smaller footprint and has per default less binaries on board.

In general you need to make sure you know what services are offered from each component in your LAN. Then you need to decided what do with each:

* Can it be stopped/disabled without affecting the operation?
* Can it be started only on the localhost interface or any other network interface?
* Is proper authentication needed for this service?
* Can a tcpwrapper (host) or any other config option narrow down the access to this service?
* Are there any known design flaws? Did you review the documention in terms of security?

For services which cannot be turned off, reconfigured or hardended: This is where the network based protection (D03) should at least provide one layer of defense.

Also: If your host OS hiccups because of AppArmor or SELinux rules, do not switch those technologies off. Find the root causes in the system log file and relax those rule only.


## How can I find out?

* System: Log into it with administrative privileges and see what's running using `netstat -tulp` or `lsof -i -Pn| grep -v ESTABLISHED`. This won't return the network sockets from the containers though.
* Container: Please note that `docker inspect` returns deliberately exposed ports only. #FIXME# `nmap -sTU -p1-65535 $(docker inspect $(docker ps -q) --format '{{.NetworkSettings.IPAddress}}')`
* As in D03 scanning the network would be another one option, albeit probably not as effective.


## References

[1] [Docker Best Practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)

