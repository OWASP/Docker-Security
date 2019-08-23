# D05 - Maintain Security Contexts

To have the investment into the powerful hardware pay off, it might sound
appropriate to put as much containers on one single host.

From the security standpoint this is often questionable as different containers
may have different security contexts and also different security statuses.

 A backend container and a frontend container on the same host might be one concern as they have different information security
values.  A bigger issue is mixing production e.g. with a test or development environment. Production systems need to be available and development containers might contain code which isn't really secure. One shouldn't affect the other.

Most thoughts have to be put into multi tenant environments.

## Threat Scenarios

* A student from the university he has a part time job at a company. He just learned PHP programming and deploys
his work into the CD chain of a company. The company
has limited resources and bought only a very few of big iron hosts which serve all containers. The environment has rapidly and historically grown so that nobody had the resources to split production from test environment or the playground area. Unfortunately the student's application contained a remote execution vulnerability which will very soon be found by internet scanning bots which within a fingersnip exploit this vulnerability. As the attacker has broke out from the application he ended up in the container. Through this vulnerability the attacker goes shopping in the network and access
either an insecured etcd or http(s) interface of the orchestration tool. Or he
downloads an exploit as there's a similar vulnerability as Dirty COW [1] which
grants him immediate root access to the big iron machine - including all
containers.

This is a slightly exaggerated scenario. One can exchange the student from the university with an inhouse developer who just did one mistake which is obvious looking at the application from the outside but was not visible to him.

One can also change the company to a different one providing a container service. And the developer to a client of the CaaS (Container as a Service) company. If one client of the CaaS provider does a similar mistake as the student, as a worst case scenario it could affect the whole CaaS environment's availability, confidentiality and integrity.


## How Do I prevent?

Also if some of the threat scenarios might appear deliberately exaggerated, you should
have gotten the picture: 

As a general rule of thumb it's not recommended to mix containers with different security statuses or contexts.

* Put production containers on a separate host system and be careful who has he privilege deploying to this host. There should be no other containers allowed on this host.
* Looking at the information security value of your data you should also considering separating containers according to their contexts. Databases, middleware, authentication services, frontend and master components (cluster’s control plane of e.g. Kubernetes) shouldn't be on the same host.

As indicated in one of the threat scenarions running containers from different
tenants directly on one host is a bad idea. You should at least separate those
containers with another layer by a VM (Virtual Machine). In fact the VM
technologie can also be use for other purposes then separating tenants, i.e. to
provide a better separation for different security contexts.

## How can I find out?

An external which has to audit the system it's the best to get the system's architecture explained.
In addition by logging into the bare metal system you can check whether there are processes running
which look like a VM process (e.g. `qemu-system-x86_64`) or docker processes only.
Qemu processes or `virsh list --all` gives at least a hint that the virtualization KVM is running. What's
inside those VMs is best to analyze when you log into the VM.

In any case it's important to look whether the separation of the system's reflects the security contexts.


## References

[1] Dirty COW, [vulnerability and exploit](https://dirtycow.ninja/) from 2016
