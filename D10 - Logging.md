# D10 - Logging

In the case of applications involving a dockerized environment, the logging process involves JSON-formatted logs. A logging driver manages the logs emitted by the docker through its stdout and stderr streams. The logging driver is generally located at the local disk of the respective Docker host. There can often be latency differences in the case of different drivers. To prevent this, the log management setup can be made with a JSON-file driver backed up with the docker blocking mode. One of the challenges in the case of containers is the multi-tiered nature of containers. Hence the defined infrastructure must segregate various log events into individual processes.

Various logging strategies can be followed in the case of containerized applications. These include but are not limited to logging via a dedicated logging container, using data volumes, working through the sidecar approach, or logging through an application. One can simply carry on the workflow using the docker logging driver as well, however, each mentioned approach has benefits of its own.

There are various community plugins supported through docker, also users can create their logging drivers distributed over a private container registry. Docker's local logging driver has a slightly different workflow and compresses the logs written to a local file. These are saved on the disk.
## Threat Scenarios

## How Do I prevent?

## How can I find out?

## References


