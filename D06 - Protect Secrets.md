# D06 - Protect Secrets


## Threat Scenarios

## How Do I prevent?
Generally, docker secrets must have access control along with encryption at transit. One of the easiest ways for the secrets getting leaked would be while they're being exchanged. It's better to restrict their movement to a privately defined overlay network. The secrets are generally stored in an encrypted Raft log and hence also require encryption while at rest. To circulate secrets at runtime to a container, either volume mounts or environment variables can be used. However, using the approach involving volume mount is more reliable as there can be secret leakage while logging in the case of environment
variables.

Another way of preventing leakage of secrets is regular rotation using environment variables. These variables essentially indicate the path to the secret, which can be updated at each rotation. This mechanism is required due to the immutable nature of the secrets and ensures
authenticity.

One of the simplest ways to maintain secret authenticity is avoiding container image for storing the secret. This is a bad idea for two reasons, one is that it restricts the secret to the process of deployment. This might also affect the efficiency of the rotation cycle.Furthermore, an image containing a secret might be a vulnerable target for hackers to get 
access to.
## How can I find out?

## References


