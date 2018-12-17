
# Threat Modeling

There are often misunderstandings of what the benefit of using Docker is or the additional threats are supposed to me when using Docker.

The perspective from a developer is different from networking engineer and the system engineer might also put up another round of arguments.

Fact is, in a containerized environment a lot has change not only how deployments are done but also how hardware and network resources are used.


## Shift in Paradigm: new vectors

Any containment technology doesn't solve application security problems. It doesn't help doing input validation and it doesn't provide protecting against SQL injection. For application security risks OWASP provides a lot of other useful documents starting from the OWASP Top 10 over the [https://www.owasp.org/index.php/OWASP_Proactive_Controls OWASP Proactive Controls] to the [https://www.owasp.org/index.php/Category:OWASP_Application_Security_Verification_Standard_Project OWASP Application Security Verification standard] -- just to name a few.

Container Security is mostly about system and network security and a secure design of the architectures involved.

Looking at a container environment from the perspective of the classic world especially in system and network areas are big changes. Those changes are opening up new potential attack surfaces.

Apart from the technology one needs to be careful in respect to two other soft points:

* Docker with its 5 years is a relatively new technology -- subtracting the time for maturing and adoption the time span is even shorter. Every new technology needs time until the knowledge of the technology and their best practices becomes common knowledge. This document contributes to this.
* While container solutions might offer benefits for the developer, the technology is not simple. Not being simple is what makes security more difficult, a.k.a. _complexity kills security_ or: the _KISS principle_ -- keep it simple and stupid.


## Vectors / Threats

As said above Docker doesn't address application security problems. But it also doesn't cause new application security problems. But special care has to be taken so that no _new network and system_ security problems arise.

### Threat 1: Container escape (System)

In this scenario the application is insecure in a way that some kind of shell access is possible. So the attacker managed e.g. from the internet to successfully stage an attack in which he has managed to escape the application and ended up to be in the container. The container is as the name indicates supposed to contain him.

In a second stage he would try to escape the container, either as the container user from a view of the host or with a kernel exploit. In the first scenario he would just end up with user privileges on the host. In the second scenario he would be root on the host system which gives him control over all containers running on that host.

### Threat 2: Other Containers via Network

This scenario has the same first stage as the previous one. The attacker has also shell access but then he chooses to attack another container through the network. That could either be from the same application, a different application from the same customer, or in a multi-tenant environment one from another customer.

### Threat 3: Attacking the Orchestration Tool via Network

This scenario has the same first vector as the previous two. The attacker has shell access within the container but he chooses to attack the management interfaces or other attacks surfaces of the orchestration tool -- the management back-plane. In 2018 almost every tool has had a weakness here which was a default open management interface. "Open" means in the worst case an open port without authentication. (citations needed).

### Threat 4: Attacking the Host via Network

This again has the same first vector as the one mentioned before. With his shell access he attacks an open port from the host. If it is weakly protected or not at all he get's user - or worse - root access to the host.

### Threat 5: Attacking other Resources via Network

This is basically a threat which collects all remaining network-based threats into one bucket.

This again has the same first vector as the one mentioned before. With his shell access he finds e.g. an unprotected network-based file system which is shared among the containers where he could read or even modify data. Another possibility would be resources like an Active or LDAP Directory. Yet another resource could be e.g. a Jenkins which has somebody configured too open and is accessible from the container.

(clarification needed because of ARP spoofing & switch): Also it could be possible that the attacker installs a network sniffer into the container he hijacked so that he might be able to read traffic from other containers

### Threat 6: Resource Starvation

The underlying vector is due to a security condition from another container
running on the same host. The security condition could be either to the
fact that the other container is eating up resources which could be CPU cycles,
RAM, network or disk-I/O.

It could also be that the container has a host file system mounted which the
attacker has been filling up which causes problem on the host which in turn
affects other containers.

### Threat 7: Host compromise

Whereas the previous threat the attacker managed indirectly over the host to affect
another / other containers, here the attacker has compromised the host -- either through
another container or through the network.


### Threat 8: Integrity of Images

The CD pipeline could involve several hops where the mini operating system image is
been passed from one step to the next until it reaches the deployment.

Every hop is a potential attack surface for the attacker. If an attacker manages
to get foot into one step and there's no integrity check whether what will be
deployed is what should be deployed there is the threat that on behalf of the
attacker images with his malicious payloads are being deployed.








