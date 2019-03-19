# D02 - Patch Management Strategy


Please note that by patch management strategy (patch management plan or policy, or security SLA are used synonymous) in the following paragraphs the scope is not primarily a technical one: It's necessary to agree and have an approval _when_ certain patches will be applied.  Often this strategy would be a task of an Information Security Officer. However not having an ISO should not be an excuse not to have a patch management strategy.


## Threat Scenarios

The worst thing which can happen to your container environment is that either the host(s) are compromised or the orchestration tool. The first would enable the attacker to control all the containers running on the host, the second will enable the attacker to control all containers on _all_ hosts which the software is managing. 

The most important threats are kernel exploits from within a container through abuse of Linux sys(tem )calls which lead to root access. Also the orchestration software has interfaces which either maybe not be locked down [1] and have shown numerous problems in the past. e.g. like etcd [], kubelet [] and dashboard [].

While threats from the Linux kernel can be partly mitigated by constraining syscalls further (see D4) and network access restrictions (D3) can be applied to reduce the network vector for the orchestration it is important to keep in mind that risk is equal likelihood times damage. Which means also if you minimized the likelihood through partly mitigation or network access, the damage and thus the risk is very high. Patches make sure that the software is always as secure as provided from the vendor.

Another threat arises from any Linux services on the host. Also if the host configuration is reasonable secured (see D3 and D4) e.g. a vulnerable `sshd` poses a threat to your host too. If the services is not secured via network and configuration, the risk is higher.


## How Do I prevent?

### Different Patch Domains

In general not patching in a timely fashion is the most frequent problem in the IT industry. Most software defects from "off the shelf software" are well known before exploits are written and used. Sometimes not even a sophisticated exploit is needed.

Same applies for your container environment. It is not as straight foward though as there are four different "patch domains":

* Images: the container operating distribution
* Container software: Docker
* Orchestration software (Kubernetes, Mesos, OpenShift, ...)
* Host: operating system

While the first domain of patching seems easy at the first glance updating the Container software is not seldom postponed. Same applies for the orchestration tool and the host as they are core components.

### Suggestion when to patch what

Depending on the patch domains mentioned above there are different approaches how patching can be achieved. Important is to have a patch strategy for each component. Your patch strategy should handle _regular_ and _emergency_ patches.

If you aren't in an environment which has change or patch policies or processes recommended is the following (also if you are it's recommended to review them whether it needs to be re-adjusted for you container environment):

* Define a time span in which outstanding patches will be applied on a _regular basis_. This can be different for each patch domain but it doesn't have to. Differences may arise due to different threat scenarios: An exposed container or API from your orchestration software which you need to expose has a higher threat level.
* Execute patch cycles and monitor them for success and failures.
* For critical patches to your environment where the time span between the regular patches is too large for an attacker you need to define a policy for emergency patches which need to be followed in such a case. You also need a team which tracks critical vulnerabilities and patches, e.g. through vendor announcements or through security mailing lists. Emergency patches are normally applied within days or about a week.

Keep in mind that some patches require a restart of their service, a new deployment (container image) or even a reboot (host) to become effective. If this won't be done your patching otherwise can be as effective as not to patch. Those technical details which come after applying patches need to be defined in the the patch plan too.


## How can I find out?

Depending on your role there are different approaches. If you are external or not involved you can just ask what the plan is for the different patch domains and have the plans explained. This can be supplemented by having a look at the systems.

Without doing deep researches you can gather good indicators on the host like

* `uptime`
* When were last patches applied (`rpm --qa --last`, `yum check-update`, `zypper lu` or check `/var/log/dpkg.log*`, `echo n | apt-get upgrade`)
* `ls -lrt /boot/vmlinu*` vs. `uname -a`
* Have a look at the runtime of processes (`top` --> column `TIME+`) including e.g. `dockerd`, `docker-containerd*` and `kube*` processes
* Deleted files: `lsof +L1`

If your role is internal within the organization and you need to be sure that both patch management strategies exist and are being properly executed. Depending where you start with your policy recommended is [n-1]. [n].


## References

### Commercial

* [1] [Lacework: Containers at Risk](https://www.lacework.com/containers-at-risk-a-review-of-21000-cloud-environments/)
* [n-1] TBD: ~~Good source (1) for patch management, lightweighted (not ITIL, nor ISO 2700x)~~
* [n] TBD: ~~Another good source (2) for patch management~~
