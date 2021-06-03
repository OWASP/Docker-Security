# D06 - Protect Secrets


## Threat Scenarios
- in worst Case Secrets would be stored somewhere in our Container Environment
- exposed environment variables 
- priviliged access, in worst case as root user

## How Do I prevent?
- running containers as a non-root user
- using multi-stage builds
- setting build ARGs 
- defining an ENTRYPOINT script

## How can I find out?

## References


