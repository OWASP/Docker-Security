
# Introduction

Implementing a containerized environment changes a lot not. It doesn't only affect deployments and the way they are done, but also has a huge impact on both system and networking levels, as well as hardware and network resource usage.

This document helps you in securing your containerized environment and keeping it in that state.


## Application Security?

There are often misunderstandings of what the security impacts - negative or positive - are supposed to be when using Docker.

Docker, same as any other containerization technology, doesn't solve application security problems. It doesn't help with input validation and it doesn't protect against SQL injection. For application security risks, OWASP provides a lot of other useful documents, starting from the OWASP Top 10 through the [OWASP Proactive Controls](https://www.owasp.org/index.php/OWASP_Proactive_Controls) to the [OWASP Application Security Verification standard]([https://www.owasp.org/index.php/Category:OWASP_Application_Security_Verification_Standard_Project) -- just to name a few.

Container Security is mostly about topics regarding system and network security and a secure architectural design.

This indicates that the optimal point to start considering it for your environment is _before_ you start using containerization. Some points are just too difficult or costly to change once you already started rolling out your containers in production.

## Shift in Paradigm: New Vectors

When looking at it from the perspective of more conventional and common environments, containerization leads to big changes - especially regarding system and network topics. Those changes are opening up new potential attack surfaces, and special care has to be taken in order to prevent network and system security problems from arising.

In addition to these technical areas, there are two non-technical points:

* Docker with its 5 years is a relatively new technology. Subtracting the time needed for maturing and adoption, the time span is even shorter. Every new technology needs time until the understanding of it and the associated best practices become common knowledge.
* While container solutions might offer benefits for the developer, their security is not simple. Not being simple is what makes security more difficult, as it violates the _KISS principle_ by not keeping it simple and stupid.

Thats what this document is trying to help you with: It provides you with the knowledge to avoid common pitfalls in the system and network areas and it tries to get a handle on the complexity.

## Document Structure

In order to achieve this, this document provides an analysis of the threats caused by the technology, which is then used as the basis for the ten points to follow.


