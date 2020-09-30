# D02 - Patch Management Strategy

Not patching the infrastructure in a timely fashion is still the most frequent security problem in the IT industry which proved Viruses like WannaCry or NotPetya. Most software defects from "off the shelf software" are well known for some time before exploits are written and used. Sometimes not even a sophisticated exploit is needed. All you need to do is patching those known vulnerabilities soon enough.

This is similar to OWASP Top 10's "Known Vulnerabilities" [1].

It's necessary to agree and have a policy or at least a common understanding _when_ certain patches will be applied. Often this strategy would be a task of an Information Security Officer, an ISO or CISO. Not having an (C)ISO is no excuse for not having a patch management strategy. Please note that by the term patch management strategy in this paragraph the scope intended is not primarily a technical one. Synonymous terms for patch management strategy are patch management policy or plan, or security SLA.

## Threat Scenarios

The worst thing which can happen to your container environment is that either the host(s) are compromised or the orchestration tool. The first would enable the attacker to control all the containers running on the host, the second will enable the attacker to control all containers on _all_ hosts which the software is managing.

The most severe threats to the host are kernel exploits from within a container through abuse of Linux sys(tem)calls which lead to root access [2]. Also the orchestration software has interfaces whose defaults were weak and have shown numerous problems in the past [3],[4].

While threats from the Linux kernel can be partly mitigated by constraining syscalls further (see D4) and network access restrictions (D3) can be applied to reduce the network vector for the orchestration, it is important to keep in mind that you can't mitigate future security problems, like from remaining syscalls, other than by patching. The likelihood of such an incident might be small, however the impact is huge, thus resulting in a high risk.

Patching timely makes sure that your software you are using for your infrastructure is always secure and you avoid known vulnerabilities.

Another threat arises from any Linux services on the host. Also if the host configuration is reasonably secured (see D3 and D4) e.g. a vulnerable `sshd` poses a threat to your host too. If the services are not secured via network and configuration, the risk is higher.

You should also keep an eye on the support life time of each "ops" component used. If e.g. the host OS or orchestration software has run out of support, you likely won't be able to address security issues.

## How Do I prevent?

### Different Patch Domains

Maintaining your infrastructure software is not as straightforward though as there are four different "patch domains":

* Images: the container distribution
* Container software: Docker
* Orchestration software (Kubernetes, Mesos, OpenShift, ...)
* Host: operating system

While the first domain of patching seems easy at the first glance updating the Container software is not seldom postponed. Same applies for the orchestration tool and the host as they are core components.

Have a migration plan for EOL support for each domain mentioned.

### When to patch what?

In short: patch often and if possible automated.

Depending on the patch domains mentioned above there are different approaches how proper patching can be achieved. Important is to have a patch strategy for each component. Your patch strategy should handle _regular_ and _emergency_ patches. You also need to be prepared for testing patches and rollback procedures.

If you aren't in an environment which has change or patch policies or processes, the following is recommended (test procedures omitted for simplicity):

* Define a time span in which pending patches will be applied on a _regular basis_. This process should be automated.
* This can be different for each patch domain -- as the risk might be different -- but it doesn't have to. It may differ due to different risks: An exposed container, an API from your orchestration software or a severe kernel bug are a higher risk than container, the DB backend or a piece of middleware.
* Execute patch cycles and monitor them for success and failures, see below.
* For critical patches to your environment where the time span between the regular patches is too large for an attacker you need to define a policy for emergency patches which need to be followed in such a case. You also need a team which tracks critical vulnerabilities and patches, e.g. through vendor announcements or through security mailing lists. Emergency patches are normally applied within days or about a week.

Keep in mind that some patches require a restart of their service, a new deployment (container image) or even a reboot (host) to become effective. If this won't be done, your patching otherwise could be as effective as just not to patch. Technical details when to restart a service, a host or initiate a new deployment need to be defined in the patch plan too.

It helps a lot if you have planned for redundancy, so that e.g. a new deployment of a container or a reboot of a host won't affect your services.

## How can I find out?

Depending on your role there are different approaches. If you are external or not involved you can just ask what the plan is for the different patch domains and have the plans explained. This can be supplemented by having a look at the systems. Also keep an eye on the continuity management.

### Manual

Without doing deep researches you can gather good indicators on the host like

* `uptime`
* When were last patches applied (`rpm --qa --last`, `tail -f /var/log/dpkg.log`). Which patches are pending? (RHEL/CentOS: `echo n | yum check-update`, Suse/SLES: `zypper list-patches --severity important -g security`, Debian/Ubuntu: `echo n | apt-get upgrade`).
* `ls -lrt /boot/vmlinu*` vs. `uname -a`
* Have a look at the runtime of processes (`top` --> column `TIME+`) including e.g. `dockerd`, `docker-containerd*` and `kube*` processes
* Deleted files: `lsof +L1`

If your role is internal within the organization, you need to be sure that a patch management plan exists and is being properly executed. Depending where you start with your policy recommended is [5].

### Automated

For the host: patch often! Every Linux vendor nowadays supports automated patching. For monitoring patches there are external tools available for authenticated vulnerability scans like OpenVAS [6]. But also all Linux operation systems provide builtin means notifying you for outstanding security patches.

The general idea for container images is though to deploy often and only freshly build containers. Scanning also here should never be used as a reactive measure but rather to verify that your patching works. For your container images there are a variety of solutions available [7]. Both use feed data on the CVEs available.

In any case it's also recommended to make use of plugins for your monitoring software notifying you of pending patches.

## References

* [1] OWASP's Top 10 2017, A9: [Using Components with Known Vulnerabilities](https://www.owasp.org/index.php/Top_10-2017_A9-Using_Components_with_Known_Vulnerabilities)
* [3]: Weak default of etcd in CoreOS 2.1: [The security footgun in etcd](https://gcollazo.com/the-security-footgun-in-etcd)
* [4]: cvedetails on [Kubernetes](https://www.cvedetails.com/vulnerability-list/vendor_id-15867/product_id-34016/Kubernetes-Kubernetes.html), [Rancher](https://www.cvedetails.com/vulnerability-list/vendor_id-19744/product_id-53073/Rancher-Rancher.html)
* [5] [OpenVAS](http://openvas.org/index.html).

### Commercial

* [2] Blog of Aquasec: [Dirty COW Vulnerability: Impact on Containers](https://blog.aquasec.com/dirty-cow-vulnerability-impact-on-containers)

* [5] TBD: ~~Good source (1) for patch management, light-weighted (not ITIL, nor ISO 2700x)~~
* [6] TBD: ~~what all needs to be listed here?~~
