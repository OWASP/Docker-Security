# D07 - Resource Protection

## Threat Scenarios

Depending on the host OS there's no restriction at all for a container in terms of CPU, memory -- or network and disk I/O. The threat is that either due to a software failure or due to a deliberate cause by an attacker one of those resources runs short which affects physical resources of the underlying host and all other containers.

Also if a container has been contained by default security measures imposed by e.g. docker it still shares physical resources with other containers and the host, i.e. mostly CPU and memory. So if other containers use those resources extensively, there won't be much left for your container.

The network is also a shared medium and most likely when data is being read or written, it is the same resource.

For the memory it is important to understand that there's a so called OOM [1] killer in the host's Linux kernel. The OOM killer kicks in when the kernel is short of memory. Then it starts - using some algorithms [2] - to "free" memory so that the host and kernel itself can still survive. The processes being killed are not necessarily the ones to blame for the extensive memory consumption (OOM score see [3]) and often the host's RAM is oversubscribed [3].


## How Do I prevent?

The best is first for containers to impose reasonable upper limits in terms of memory and CPU. By reaching those limits the container won't be able to allocate more memory or consume more CPU.

For memory there are two main variables for setting a hard limit ``-memory`` and ``--memory-swap``. Soft limits can exceed the value specified. They would be set with ``--memory-reservation``. For a more complete description see the docker documentation [4]. To protect processes in the container you can also set ``--oom-kill-disable``. The container daemons have a lower OOM score and won't normally be killed).
 
## How can I find out?

* Configured: ``docker inspect``
* Live: ``docker stats``, including what's configure
* Details memory: ``/sys/fs/cgroup/memory/docker/$CONTAINERID/*

## References

* [1] OOM stands for Out of Memory Management
* [2] https://www.kernel.org/doc/gorman/html/understand/understand016.html
* [3] https://lwn.net/Articles/317814/
* [4] https://docs.docker.com/config/containers/resource_constraints/
