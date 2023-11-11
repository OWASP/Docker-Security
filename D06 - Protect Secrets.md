# D06 - Protect Secrets

Secrets provide access to resources or help encrypting data in transit or at
rest. Secrets could be private keys for an X509 certificate, HMACs for JWT or similar
cryptographic material. Also, it could be just secrets which provide necessary
access or just holds credentials. Think of backend connectors to databases, API keys,
image registry keys or any other tokens which provide access to an internal or
external service.

Often you cannot avoid providing some kind of keys or credentials to be provided
by a container.  E.g. the frontend container needs to have access to a private key,
the HTTPS web service won't start otherwise. Also, a container with a database connector
needs to have access to the database credentials. Or, if you encrypt the database
content: somewhere needs to be a key / the keys for encryption and decryption.

You could encrypt those private information. But again you would need keys for
that, and those need to be accessible for a container. This results in a chicken an
egg problem.

The point of this section is how you deal appropriately with secrets, i.e. where
do I store this kind of information, what is appropriate and what not.


## Threat Scenarios

### Scenario 1:

Container is running a web application and the application has code execution vulnerability. Which if gets compromised, an attacker can then easily access hardcoded secrets leading to further movement.

### Scenario 2:

Development team has hardcoded secrets in application or configuration file. Anyone having access to image repository can see the hardcoded secrets.

## How Do I prevent?

### Using Sidecar Container

Vault server or any other secret management tool can be started in parallel as a sidecar container.

The volume from sidecar container can be mounted in other containers where required. And secrets can then be referenced as environment variables from the mounted volulme.

### Using Docker Compose

“secrets” field can be used to define “file” which stores the secret (Eg. API key or password). **The file storing secrets should never be committed with source code.**

```jsx
version: '01'
services:
  secureapp:
    image: secureapp:latest
    secrets:
      - API_KEY
secrets:
  API_KEY:
    file: ./key.txt
```

Here “API_KEY” is defined under “secrets” field which fetches value from key.txt. The secrets can be accessed as environment variables from inside the application.

### Using Docker Swarm

If using docker swarm, “docker secret create” command can be used to create secret. **The key.txt file here should be deleted after creating docker secret.**

```jsx
docker secret create API_KEY ./key.txt
```

Here “key.txt” contains the secret (Eg. API key or password) which is used to create docker secret. 

The secret can then be passed with “—secret” flag while creating service. 

```jsx
docker service create --name SecureApp --secret API_KEY secureapp:latest
```

**Make sure that terminal history should be deleted for instance.**

The same secret can also be used in compose file as below:

```jsx
version: '3'
services:
  secureapp:
    image: secureapp:latest
    secrets:
      - API_KEY
```

## How can I find out?

Hardcoded secrets can be detected by:

1. Scanning container images for secrets. Open source tools like trivy or dagda can be used to scan for vulnerabilities as well as secrets.
2. Continuous monitoring for changes in images can be used to track secrets in its life-cycle

## References

1. [https://docs.docker.com/compose/use-secrets/](https://docs.docker.com/compose/use-secrets/)
2. [https://docs.docker.com/engine/swarm/secrets/](https://docs.docker.com/engine/swarm/secrets/)
3. [https://github.com/aquasecurity/trivy](https://github.com/aquasecurity/trivy)
4. [https://github.com/eliasgranderubio/dagda](https://github.com/eliasgranderubio/dagda)


