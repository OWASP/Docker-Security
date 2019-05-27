# D04 - Secure Defaults and Hardening

While D03 - Network Separation and Firewalling for sure provides at least can an extra layer of protection for any network based services on the e.g. host, the orchestration tool and other places: it doesn't address the root cause. It mitigates the symptom. Best practice though is not to start any service not needed in the first place. And those  which are needed need to be locked down properly.

## Threat Scenarios

Basically there are three "domains" where services can be attacked:

* Interfaces from the orchestration tool. Typically: dashboard, etcd, API
* Interfaces from the Host. Typically: RPC services, OpenSSHD, avahi, systemd-services
* Interfaces within the container, either from the microservice (e.g. spring-boot) or from the distribution.


## How Do I prevent?

### Orchestration / Host

For your orchestration tool it is crucial to know what service is running and whether it is protected properly or has a weak default configuration.

For your host the first step is picking the right distribution. E.g. -- a standard Ubuntu system is a standard Ubuntu system. There are distributions more specialised on hosting containers. Then install a minimal distribution. Think of a minimal bare metal system. Especially for standard distributions: Desktop applications, compiler environments or any server applications have no business here. They all add an attack surface. When you pick an OS for the host,
find out the support time left (EOL).

In general you need to make sure you know what services are offered from each component in your LAN. Then you need to decided what do with each:

* Can it be stopped/disabled without affecting the operation?
* Can it be started only on the localhost interface or any other network interface?
* Is proper authentication needed for this service?
* Can a tcpwrapper (host) or any other config option narrow down the access to this service?
* Are there any known design flaws? Did you review the documention in terms of security?

For services which cannot be turned off, reconfigured or hardended: This is where the network based protection (D03) should at least provide one layer of defense.

Also: If your host OS hiccups because of AppArmor or SELinux rules, do not switch those technologies off. Find the root causes in the system log file and relax those rule only.

### Container

Also for the containers, best practise is: do no install unnecessary packages [1]. Alpine Linux has a smaller footprint and has per default less binaries on board.

There are a couple of further options you should look into. What can affect the security of the host kernel are defective syscalls. In a worst case this can lead to a privilege escalation from a container as a user to root on the host. So-called capabilities are a superset from the syscalls.

Here are some defenses:

* Disable SUID/SGID bits (`--security-opt no-new-privileges`): even if you run as a user, SUID binaries could elevate privileges. Or use `--cap-drop=setuid --cap-drop=setgid` when applying the following.
* Drop more capabilities (`--cap-drop`): Docker restricts the so-called capabilities of a container from 38 (see `/usr/include/linux/capability.h`) to 14 (see ``man 7 capabilities`` and [2]). Likely you can drop a few like `net_bind_service`, `net_raw` and more, see [3]. `pscap` is your tool on the host to list capabilities.  Do not use `--cap-add=all`.
* If you need finer grained controls as the capabilities can provide you can control each of the >300 syscalls with seccomp with a profile in JSON  (`--security-opt seccomp=mysecure.json`), see [4]. About 44 syscalls are already disabled by default. Do not use `unconfined` or `apparmor=unconfined` here.

Best practise is to settle which of the above you chose. Better do not mix capabilities setting and seccomp profiles.


## How can I find out?

* System: Log into it with administrative privileges and see what's running using `netstat -tulp` or `lsof -i -Pn| grep -v ESTABLISHED`. This won't return the network sockets from the containers though.
* Container: Please note that `docker inspect` returns deliberately exposed ports only. `nmap -sTU -p1-65535 $(docker inspect $(docker ps -q) --format '{{.NetworkSettings.IPAddress}}')`
* As in D03 scanning the network would be another one option, albeit probably not as effective.

#####FIXME: --> CIS


## References

* [1] [Docker Best Practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
* [2] [Docker Documentation, Runtime privilege and Linux capabilities](https://docs.docker.com/engine/reference/run/#runtime-privilege-and-linux-capabilities)
* [4] [Docker Documentation, Seccomp security profiles for Docker](https://docs.docker.com/engine/security/seccomp/)

### Commercial

* [3] [Secure your Container: One weird trick](https://www.redhat.com/en/blog/secure-your-containers-one-weird-trick)



