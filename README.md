Docker Security
===============

This is the OWASP Docker Top 10. It's a work in progress.

## About this document

This document describes the most important 10 security bullet points for
building a secure containerized environment. You can use it as a specification
sheet if you start from scratch, alternatively handing it to a contractor who
will do this for you.

It can also be used to audit or secure an existing installation but especially
here you should start thinking about security very early. Best is in the design
phase. Later on it becomes either difficult to change some decisions you made or
they become costly, in terms of money or time.

### Name

Albeit the document's name resembles the OWASP Top 10 it's quite different.
First, it is not about risks which are based on data collected as the OWASP Top
10. Secondly the 10 bullet points here resemble (proactive) controls.

### For whom is this?

This guide is for developers, auditors, architects, system and networking
engineers. As indicated above you can also use this guide for external
contractors to add formal technical requirements to your contract. The
information security officer should have some interest too to meet baseline
security requirements and beyond.

These 10 bullet points are mostly (see below this paragraph) about system and
network security and system and network architecture. As a developer you don't
have to be an expert in those -- that's what this guide is for. But as indicated
above best is to start thinking about and addressing those points early. Please
do not just start building it.

One of the bullet points should not be misunderstood: Patch management is not a
technical point. It's a management process. Last but not least for technical or
information security management who has not been much worried about
containerization this document also provides insights about the risks involved.

### Structure of this document

Security in Docker environments seemed often to be misunderstood. It was`/`is a
highly disputed matter what the threats are supposed to be. So before diving
into the Docker Top 10 bullet points, the threats need to be modeled which is
happening upfront in this document. It not only helps to understand any security
impacts but also gives you the ability to prioritize your tasks.

### Contribution

Please see CONTRIBUTING.md. To ease contributions to the the open points please
file your PRs against the corresponding dev branches (D06_dev, D07_dev, ...).


### How to Build PDF version

You can build yourself a PDF version as long as you have Docker and docker-compose
installed.

```
docker-compose run --rm build
```

It's not frequently updated in this repository as it otherwise clogs this repo.

## FAQ

### Why not "Container Security"

Albeit the name of this project carries the word "Docker", it also can be used
with little abstraction for other containment solutions. Docker is as of now the
most popular one, so the in-depth details are focusing for now on Docker. This
could change later.

### A single container?

If you run more than 3 containers on a server you probably have an orchestration
solution to manage them. _Specific_ security pitfalls of such a tool are
currently beyond the scope of this document. That does not mean that this guide
is just concerning one or a few containers managed manually -- on the contrary.
It means only that we're looking at the containers including their networking
and their host systems in such an orchestrated environment and not on special
pitfalls of e.g. _Kubernetes_, _Swarm_, _Rancher_ or _OKD/OpenShift_.

### Why ten?

To be honest for us humans the number 10 sounds catchy and while putting it all
together those 10 were considered to be the most important ones.


