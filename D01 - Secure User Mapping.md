# D01 - Secure User Mapping


## Threat Scenarios

The threat is here that a microservice is being offered to run under `root` in the container. If the service contains a weakness the attacker has full privileges within the container. While there's still some default protection left (Linux capabilities, either AppArmor or SELinux profiles) it removes one layer of protection. This extra layer broadens the attack surface. It also violates the least privilege principle [1] and from the OWASP perspective an insecure default.

It should be noted that it is very dangerous for the host and all containers on this host to run a privileged container (`--privileged`) as it removes almost every restriction. Root in a container can access e.g. block devices, the /proc and /sys file system on the host and with a little work it can also load modules on the host [2].


## How Do I prevent?

It is important to run your microservice with the least privilege possible. The good thing is that containers are unprivileged, unless you have configured them explicitly differently (e.g. `docker run --privileged`). However running your microservice under a different user as root requires configuration. You need to configure your mini OS of your container to both contain a user (and maybe a group) and your service needs to make use of this user and group.

Basically there are two choices.

In a simple container scenario if you build your container you have to add `RUN useradd <username>` or `RUN adduser <username>` with the appropriate parameters -- respectively the same applies for group IDs. Then, before you start the microservice, the `USER <username>` [3] switches to this user. Please note that a standard web server wants to use a port like 80 or 443. Configuring a user doesn't let you bind the server on any port below 1024. There's no need at all to bind to a low port for any service. You need to configure a higher port and map this port accordingly with the expose command [4]. Your mileage may vary if you're using an orchestration tool.

The second choice would be using Linux *user namespaces*. Namespaces are a general means to provide to a container a different (faked) view of Linux kernel resources. There are different resources available like User, Network, PID, IPC, see `namespaces(7)`. In the case of *user namespaces* a container could be provided with a his view of a standard root user whereas the host kernel maps this to a different user ID. More, see [5], `cgroup_namespaces(7)` and `user_namespaces(7)`.

The catch using namespaces is that you can only run one namespace at a time. If you run user namespacing you e.g. can't use network namespacing on the same host [6]. Also, all your containers on a host will be defaulted to it, unless you explicitly configure this differently per container. 



## How can I find out?

#### Configuration

Depending on how you start your containers the first place is to have a look into the configuration / build file of your container whether it contains a user.

#### Runtime

Have a look in the process list of the host, or use `docker top` or `docker inspect`.

1) `ps auxwf`

2) `docker top <containerID>` or `for d in $(docker ps -q); do docker top $d; done`

3) Determine the value of the key `Config/User` in `docker inspect <containerID>`. For all running containers: `docker inspect $(docker ps -q) --format='{{.Config.User}}'`

#### User namespaces

The files `/etc/subuid` and `/etc/subgid` do the uid mapping for all containers. If they don't exist and `/var/lib/docker/` doesn't contain
any other entries owned by `root:root` you're not using any uid remapping. On the other hand if those files exist and there are files in that directory you still need to check whether your docker daemon was started with `--userns-remap` or the config file `/etc/docker/daemon.json` was used.




## References
* [1] [OWASP: Security by Design Principles](https://www.owasp.org/index.php/Security_by_Design_Principles#Principle_of_Least_privilege)
* [3] [Docker Docs: USER command](https://docs.docker.com/engine/reference/builder/#user)
* [4] [Docker Docs: EXPOSE command](https://docs.docker.com/engine/reference/builder/#expose)
* [5] [Docker Docs: Isolate containers with a user namespace](https://docs.docker.com/engine/security/userns-remap/)
* [6] [Docker Docs: User namespace known limitations](https://docs.docker.com/engine/security/userns-remap/#user-namespace-known-restrictions)

### Commercial

* [2] [How I Hacked Play-with-Docker and Remotely Ran Code on the Host](https://www.cyberark.com/threat-research-blog/how-i-hacked-play-with-docker-and-remotely-ran-code-on-the-host/)
