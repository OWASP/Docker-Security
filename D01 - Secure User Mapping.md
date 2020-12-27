# D01 - Secure User Mapping

## Cenários de ameaça

A ameaça aqui refere-se ao microserviço em execução com a conta `root` no container. Caso o serviço contenha uma fragilidade o atacante terá privilégios totais dentro daquele container. Embora existam proteções padrão disponíveis (Capacidades do Linux e mesmo AppArmor ou perfis do SELinux), esta configuração remove uma camada extra de proteção. Esta camada aberta aumenta a superfície de ataque e também viola o conceito do mínimo privilégio [1] e da perspectiva do OWASP é insegura por padrão. 

Para containers privilegiados (`--privileged`) uma quebra de um microserviço em containers é comparável à execução sem nenhum container. Containeres privilegiados arriscam todo o host e todos os demais containers.

## Como prevenir?

É importante executar seu microserviço com o mínimo privilégio possível.

Primeiro lugar: Nunca utilize a opção `--privileged`. Esta opção concede capacidades (veja o item D04) do container acessar dispositivos do host principal (`/dev`) incluindo os discos, e também concede acesso a `/sys` e `/proc` no sistema de arquivos. Com um pouco de trabalho o container pode ainda carregar módulos no kernel do host [2]. A boa prática é que containers devem ser desprivilegiados por padrão. Você deverá configurar explicitamente para executá-los em modo privilegiado.

Entretanto a execução de seu microserviço a partir de uma credencial de usuário diferente da root requer configuração extra. Você precisa configurar uma distribuição mínima do seu container para que ambos contenam o usuário (e talvez também um grupo) e então o serviço precisa usar este mesmo usuário e grupo.

Basicamente existem aqui duas opções.

Em um cenário simplificado se você mesmo compila seu container, você precisa adicionar `RUN useradd <username>` ou `RUN adduser <username>` com os parâmetros apropriado -- respectivamente a mesma coisa para grupos. Então, antes de iniciar o microserviço, use `USER <username>` [3] para fazer a mudança para este usuário. Vale notar que um servidor web padrão necessita usar portas como 80 ou 443. Configurar o usuário não o habilita a fazer uso de portas abaixo da 1024. Não há necessidade de fazer a vinculação de portas baixas ou serviços. Você precisa configurar uma porta alta e mapear esta porta de acordo usando o comando de exposição [4]. Seu caminho será mais ou longo ou curto a depender da ferramenta de orquestração que esteja utilizando.

A segunda opção poderá ser a utilização de *user namespaces* do Linux. Namespaces é uma maneira de prover ao container uma diferente (e falsa) visão dos recursos do kernel do Linux. Existem diferentes recursos disponíveis como User, Rede, PID, IPC, veja `namespaces(7)`. No caso de *user namespaces* um container pode ser provido de uma visão relativa de um usuário root do host que na verdade está mapeado para outro usuário. Para mais informações veja [5], `cgroup_namespaces(7)` e `user_namespaces(7)`.

A desvantagem no uso de namespaces é que você pode pode executar um deles ao mesmo tempo. Se você executa um namespace de usuário que não pode acessar o namespace de rede [6], você não pode usar também em todos os demais containers, exceto que você faça a configuração explícita para cada container.

Em todo caso utilize IDs de usuário que não estejam em uso ainda. Se você, por exemplo, executar um container que externamente ao container esteja com o usuário `systemd`, isto não é necessariamente melhor.

## Como posso descobrir?

#### Configuração

Dependendo de como você inicia seus containers o primeiro lugar a verificar são os arquivos de configuração e compilação do seu container se eles possuem um usuário.

#### Runtime

Dê uma verificada na lista de processos do host, ou utilize `docker top` ou `docker inspect`.

1) `ps auxwf`

2) `docker top <containerID>` ou `for d in $(docker ps -q); do docker top $d; done`

3) Determina o valor da chave `Config/User` no `docker inspect <containerID>`. Para todos os containers em execução: `docker inspect $(docker ps -q) --format='{{.Config.User}}'`

#### Namespaces de usuários

Os arquivos `/etc/subuid` e `/etc/subgid` possuem um ID de mapeamento para cada um dos containers. se ele não existe e o diretório `/var/lib/docker/` não possui nenhuma entrada em propriedade do `root:root` você não está utilizando nenhum mapeamento de ID de usuário. De outra forma se os arquivos existem no diretório você deverá verificar se o deamon do docker foi iniciato com `--userns-remap` ou ainda se o arquivo de configuração `/etc/docker/daemon.json` foi utilizado.

## Referêcias
* [1] [OWASP: Security by Design Principles](https://www.owasp.org/index.php/Security_by_Design_Principles#Principle_of_Least_privilege)
* [3] [Docker Docs: USER command](https://docs.docker.com/engine/reference/builder/#user)
* [4] [Docker Docs: EXPOSE command](https://docs.docker.com/engine/reference/builder/#expose)
* [5] [Docker Docs: Isolate containers with a user namespace](https://docs.docker.com/engine/security/userns-remap/)
* [6] [Docker Docs: User namespace known limitations](https://docs.docker.com/engine/security/userns-remap/#user-namespace-known-restrictions)

### Comercial

* [2] [How I Hacked Play-with-Docker and Remotely Ran Code on the Host](https://www.cyberark.com/threat-research-blog/how-i-hacked-play-with-docker-and-remotely-ran-code-on-the-host/)