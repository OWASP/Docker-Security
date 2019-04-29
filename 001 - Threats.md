
# Threat modeling

The traditional approach of securing an environment is to look at it from the attacker perspective and enumerate vectors for an attack. This is what this chapter is about.

Those vectors will help you to define what needs to be protected. With this definition, one can put security controls in place to provide a protection baseline and exceed it. This is what the ten controls in the following chapters are about.


### Threat 1: Container escape (System)

In this scenario the application is insecure in a way that provides some kind of shell access. In such a case, an attacker from somewhere (e.g. the internet) managed to successfully stage an attack, escaped the application and ended in the container. As indicated by the name, the container is supposed to contain him.

In a second stage he would try to escape the container, either as the container user from the host perspective or with a kernel exploit. In the first scenario he would just end up with user privileges on the host. In the second scenario he would be root on the host system, which gives him control over all containers running on that host.

### Threat 2: Other containers via network

This scenario has the same first stage as the previous one. The attacker also achieves shell access, but then chooses to attack another container through the network. That could either be from the same application, a different application from the same customer, or one belonging to another customer in a multi-tenant environment.

### Threat 3: Attacking the orchestration tool via network

This scenario has the same first vector as the previous two. The attacker achieves shell access within the container, but chooses to attack the management interfaces or other attack surfaces of the orchestration tool - the management back-plane. In 2018, almost every tool has had a weakness here due to a management interface open by default. "Open" means an open port without authentication in a worst case scenario. (citations needed - [redlock blog on tesla hack?](https://redlock.io/blog/cryptojacking-tesla)).

### Threat 4: Attacking the host via network

This has the same first vector as the one mentioned before, too. With his shell access, the attacker leverages an open port on the host. If it is protected weakly or not at all he get's user - or worse - root access to the host.

### Threat 5: Attacking other resources via network

This is basically a threat which collects all remaining network-based threats into one bucket.

This again has the same first vector as the one mentioned before. With his shell access, the attacker finds e.g. an unprotected network-based file system which is shared among the containers where he could read or even modify data. Another possibility would be resources like an Active or LDAP Directory. Yet another resource could be a Jenkins instance which isn't configured restrictive enough and is accessible from the container.

(clarification needed because of ARP spoofing & switch): Additionally, it could be possible that the attacker installs a network sniffer into the container he hijacked so that he might be able to read traffic from other containers

### Threat 6: Resource starvation

The underlying vector stems from a security condition regarding another container
running on the same host. The security condition is due to the
possibility that the other container is eating up resources like CPU cycles,
RAM, network or disk-I/O.

Another possibility is that the container has a host file system mounted which the
attacker has been filling up, causing problems on the host which in turn
affects other containers.

### Threat 7: Host compromise

Whereas in the previous threat the attacker managed to indirectly affect another / other containers over the host, 
here the attacker has compromised the host - either through another container or through the network.


### Threat 8: Integrity of images

The CD pipeline could involve several hops where the mini operating system image is
being passed from one step to the next until it reaches the deployment.

Every hop is a potential attack surface for the attacker. If an attacker manages
to get a foot into one step and there's no integrity check whether what will be
deployed is what should be deployed, there is the threat that on behalf of the
attacker images with his malicious payloads are being deployed.


