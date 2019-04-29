# Docker Security

This is the OWASP Docker Top 10. It's a work in progress.

## About this document

This document describes the 10 most important security bullet points for building a secure containerized environment. You can use it as a specification sheet if you start from scratch, alternatively handing it to a contractor who will do this for you.

It can also be used to audit or secure an existing system but especially these cases you should start thinking about security as early as possible. Optimally this would be in the design phase, as later on it becomes either difficult or costly (in terms of money or time) to change some decisions you made.

### Name

Even though the document's name resembles the OWASP Top 10, it's significantly different. Firstly, it is not about risks based on collected data, as are the OWASP Top 10. Secondly, the 10 bullet points in this document resemble (proactive) controls.

### Who is this for?

This guide is for developers, auditors, architects, system and networking engineers. As indicated above, you can use this guide for external contractors to add formal technical requirements to your contract, too. The information security officer should also have some interest in meeting and exceeding baseline security requirements.

These 10 bullet points are mostly (see below this paragraph) about system and network security and system and network architecture. As a developer you don't have to be an expert in those - that's what this guide is for. But as indicated above, the best point to start thinking about and addressing those topics is early on. Please do not just start building it.

One of the bullet point should not be misunderstood: Patch management is not a techincal point, it's a management process. Last but not least,  this document also provides insights about the risks involved. This document might prove useful to technical or information security management people, who have not worried a lot about containerization so far.

### Structure of this document

Security in Docker environments often seems to be misunderstood. The nature of its threats `was/is` a highly disputed matter. So before diving into the Docker Top 10 bullet points, the threats need to be modeled. This can be read in the first part of this document and not only helps to understand any security impacts, but also gives you the ability to prioritize your tasks.


## FAQ

### Why not "Container Security"

Even though the name of this project carries the word "Docker", it also can be used for other containerzation solutions with little abstraction. Docker is - as of now - the most popular one, so the in-depth details are focused on Docker for the time being. This might evolve at a later point.

### A single container?

If you run more than 3 containers on a server, you probably use an orchestration solution to manage them. _Specific_ security pitfalls of such a tool are currently beyond the scope of this document. That does not mean that this guide is just applicable for one to a few containers managed manually - on the contrary. It simply means that we're looking at the containers including their networking and their host systems in such an orchestrated environment and not on special pitfalls of e.g. _Kubernetes_, _Swarm_, _Mesos_ or _OpenShift_.

### Why ten?

To be honest, for us humans the number 10 sounds catchy. While putting it all together, these 10 were considered to be the most important ones.
