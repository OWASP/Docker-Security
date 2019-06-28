# D04 - Secure Defaults and Hardening

While D03 - Network Separation and Firewalling aims for providing an an extra layer of protection for any network based services on the host and the containers and the orchestration tool: it doesn't address the root cause. It mitigates often the symptom. If there's a network service started which is not needed at all you should rather not start it in the first place. If there's a service started which is needed you should lock it down properly.

## Threat Scenarios

Basically there are three "domains" where services can be attacked:

* Interfaces from the orchestration tool. Typically: dashboard, etcd, API
* Interfaces from the Host. Typically: RPC services, OpenSSHD, avahi, network based systemd-services
* Interfaces within the container, either from the microservice (e.g. spring-boot) or from the distribution.


## How Do I prevent?

### Orchestration / Host

For your orchestration tool it is crucial to know what service is running and whether it is protected properly or has a weak default configuration.

For your host the first step is picking the right distribution: A standard Ubuntu system is a standard Ubuntu system. There are distributions specialized on hosting containers, you should rather consider this. In any case install a minimal distribution -- think of a minimal bare metal system. And if you rather opted for a standard distribution: Desktop applications, compiler environments or any server applications have no business here. They all add an attack surface to a crucial system in your environment.

Support lifetime is another topic: When you pick an OS for the host, find out the EOL date.

In general you need to make sure you know what services are offered from each component in your LAN. Then you need to decide what do with each:

* Can it be stopped/disabled without affecting the operation?
* Can it be started only on the localhost interface or any other network interface?
* Is authentication configured for this service?
* Can a tcpwrapper (host) or any other config option narrow down the access to this service?
* Are there any known design flaws? Did you review the documentation in terms of security?

For services which cannot be turned off, reconfigured or hardened: This is where the network based protection (D03) should at least provide one layer of defense.

Also: If your host OS hiccups because of AppArmor or SELinux rules, never switch those additional protections off. Find the root causes in the system log file with the tools provided and relax those rule only.

### Container

Also for the containers, best practice is: do no install unnecessary packages [1]. Alpine Linux has a smaller footprint and has per default less binaries on board. It still comes with a set of binaries like `wget` and `netcat` (provided by busybox) though. In a case of an application breakout into the container those binaries could help an attacker "phoning home". So if you want to put the bar higher you should look into "distroless" [2] images.

There are a couple of further options you should look into. What can affect the security of the host kernel are defective syscalls. In a worst case this can lead to a privilege escalation from a container as a user to root on the host. So-called capabilities are a superset from the syscalls.

Here are some defenses:

* Disable SUID/SGID bits (`--security-opt no-new-privileges`): even if you run as a user, SUID binaries could elevate privileges. Or use `--cap-drop=setuid --cap-drop=setgid` when applying the following.
* Drop more capabilities (`--cap-drop`): Docker restricts the so-called capabilities of a container from 38 (see `/usr/include/linux/capability.h`) to 14 (see ``man 7 capabilities`` and [3]). Likely you can drop a few like `net_bind_service`, `net_raw` and more, see [4]. `pscap` is your tool on the host to list capabilities.  Never use `--cap-add=all`.
* If you need finer grained controls as the capabilities can provide you can control each of the >300 syscalls with seccomp with a profile in JSON  (`--security-opt seccomp=mysecure.json`), see [5]. About 44 syscalls are already disabled by default. Do not use `unconfined` or `apparmor=unconfined` here.

Best practise is to settle which of the above you chose. Better do not mix capabilities setting and seccomp profiles.


## How can I find out?

* You can always scan the system from the same network to see what is exposed in this LAN. In D03 it is described how to do that.
* Better is to look into the system.
    * Host: Log into it with administrative privileges and see what's running using `netstat -tulpn | grep -v ESTABLISHED` or `lsof -i -Pn| grep -v ESTABLISHED`. This won't return the network sockets from the containers though. 
    * In a container you can use those commands as well if `netstat` or `lsof` is supplied by the image.
* Any services might also be protected by the host-based firewall. What rules will be applied via default varies from host OS to host OS. As just reading the output from `iptables -t nat -L -nv` and  `iptables -L -nv` becomes in larger container environments quickly a tedious task, it's a good idea to also scan the LAN.

#####FIXME: --> CIS


## References

* [1] Docker's [Best Practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
* [2] Google's FLOSS project [distroless](https://github.com/GoogleContainerTools/distroless)
* [3] Docker Documentation: [Runtime privilege and Linux capabilities](https://docs.docker.com/engine/reference/run/#runtime-privilege-and-linux-capabilities)
* [5] [Docker Documentation, Seccomp security profiles for Docker](https://docs.docker.com/engine/security/seccomp/)

### Commercial

* [6] [Secure your Container: One weird trick](https://www.redhat.com/en/blog/secure-your-containers-one-weird-trick)



