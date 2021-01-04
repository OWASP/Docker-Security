# D06 - Protect Secrets

Secrets provide access to resources or help encrypting data in transit or at
rest. Secrets could be private keys for a X509 certificate, HMACs for JWT or similar
cryptograptographic material. Also it could be just secrets which provide necessary
access or just holds credentials. Think of backend connectors to databases, API keys,
image registry keys or any other tokens which provide access to an internal or
external service.

Often you cannot avoid to provide some kind of keys or credentials to be provided
by a container.  E.g. the frontend container needs to have access to a private key,
otherwise the HTTPS webservice won't start. Also a container with a database connector
needs to have access to the database credentials. Or, if you encrypt the database
content: somewhere needs to be a key / the keys for encryption and decryption.

You could encrypt those private information. But again you would need keys for
that, and those need to be accessible for a container. This results in a chicken an
egg problem.

The point of this section is how you deal appropriately with secrets, i.e. where
do I store this kind of information, what is appropriate and what not.



## Threat Scenarios

## How Do I prevent?

## How can I find out?

## References


