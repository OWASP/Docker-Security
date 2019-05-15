# D01 - Secure User Mapping


## Threat Scenarios

The threat is here that a microservice is being offered to run under `root` in the container. If the service contains a weakness the attacker has full privileges within the container. While there's still some default protection left (Linux capabilities, either AppArmor or SELinux profiles) it removes one layer of protection. This extra layer broadens the attack surface. It also violates the least privilege principle [1] and from the OWASP perspective an insecure default.

For privileged containers (`--privileged`) a breakout from the microservice into the container is almost comparable to run without any container. Privileged containers endanger your whole ost and all other containers.


## How Do I prevent?

It is important to run your microservice with the least privilege possible.

Never use the `--privileged` flag. It gives all so-called capabilities (see D04) to the container and it can access host devices (`/dev`) including disks, and also has access to the `/sys` and `/proc` filesystem. And with a little work the container can even load kernel modules on the host [2]. The good thing is that containers are per default unprivileged. You would have to configure them explicitly to run privileged.

However still running your microservice under a different user as root requires configuration. You need to configure your mini distribution of your container to both contain a user (and maybe a group) and your service needs to make use of this user and group.

Basically there are two choices.

In a simple container scenario if you build your container you have to add `RUN useradd <username>` or `RUN adduser <username>` with the appropriate parameters -- respectively the same applies for group IDs. Then, before you start the microservice, the `USER <username>` [3] switches to this user. Please note that a standard web server wants to use a port like 80 or 443. Configuring a user doesn't let you bind the server on any port below 1024. There's no need at all to bind to a low port for any service. You need to configure a higher port and map this port accordingly with the expose command [4]. Your mileage may vary if you're using an orchestration tool.

The second choice would be using Linux *user namespaces*. Namespaces are a general means to provide to a container a different (faked) view of Linux kernel resources. There are different resources available like User, Network, PID, IPC, see `namespaces(7)`. In the case of *user namespaces* a container could be provided with a his view of a standard root user whereas the host kernel maps this to a different user ID. More, see [5], `cgroup_namespaces(7)` and `user_namespaces(7)`.

The catch using namespaces is that you can only run one namespace at a time. If you run user namespacing you e.g. can't use network namespacing on the same host [6]. Also, all your containers on a host will be defaulted to it, unless you explicitly configure this differently per container.

<pagebreak/>
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
