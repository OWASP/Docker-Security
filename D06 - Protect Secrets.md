# D06 - Protect Secrets

Secrets provide access to resources or help encrypting data in transit or at
rest. Secrets could be private SSH keys, private keys for a X509 certificate,
HMACs for JWT or similar cryptograptographic material. Also it could be just
secrets which provide access to something or just holds credentials, like backend
connectors to databases, API keys, image registry keys or any other tokens which
provide access to an internal or external service.

Likely you cannot avoid always to provide some kind of keys or credentails to
be provided by a container.  E.g. the frontend container needs to have access
to a private keyi, otherwise the HTTPS webservice won't start. A container with
a database connector needs to have access to the database credentials. Or, if
you encrypt the database content: this also would require (a) key(s) for encryption
and decryption.

You could encrypt those private information. But again you would need keys for
it, and those need to be accessible for a container. This would be a chicken an
egg problem.

The point of this section is how you deal appropriately with secrets, i.e. where
do I store this kind of information, what is appropriate and what not.



## Threat Scenarios

## How Do I prevent?

## How can I find out?

## References


