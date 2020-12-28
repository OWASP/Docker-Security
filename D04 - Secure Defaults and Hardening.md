# D04 - Secure Defaults and Hardening

Enquanto o item *D03 - Network Segmentation and Firewalling* é direcionado a prover uma camada de proteção para qualquer serviço de rede no host, containers e ferramenta de orquestração: ele não endereça a causa raíz. Ele mitiga eventualmente apenas o sintoma. Se há serviço de rede iniciado o qual não é realmente necessário então ele não deveria ser iniciado em primeiro lugar. E caso um serviço precise realmente ser iniciado, ele deve ser configurado adequadamente.

## Cenários de ameaça

Basicamente são três os "domínios" onde serviços podem ser atacados:

* Interfaces da ferramenta de orquestração. Geralmente: _dasboard_, etcd, API.
* Interfaces do host. Geralmente: Serviços RPC, OpenSSHD, avahi, serviços de rede do systemd-services.
* Interfaces dentro do container ou microsserviço (ex. spring-boot) ou da distribuição.

## Como prevenir?

### Orquestração / Host

Para sua ferramenta de orquestração é crucial conhecer qual serviço está em execução e se ele está protegido adequadamente ou se existem configurações padrão frágeis.

Para seu host o primeiro passo é escolher a distribuição correta: Um sistema Ubuntu padrão é um sistema Ubuntu padrão. Existem distribuições especializadas em hospedagem de containers, você deve preferir considerá-las. Em todo caso instale a distribuição mínima -- pense em sistemas mínimos como _bare metal_. E se caso você tenha preferido optar uma uma distribuição padrão: Aplicativos desktop, ambientes de compilação e quaisquer serviços de servidores não possuem papel aqui. Todos eles adicionam camadas a superfíie de ataque ao seu ambiente.

Tempo de suporte é outro tópico: Quando você selecionar um SO para o host, procure a data de fim de suporte.

De forma geral você precisa ter certeza que conhece quais serviços são oferecidos para cada componente na sua LAN. Então você precisa decidir o que fazer com dada um:

* Pode ser parado ou desabilitado sem afetar a operação?
* Pode ser iniciado apenas na interface local ou por meio de interfaces de rede?
* A autenticação está configurada para este serviço?
* Pode um _tcpwrapper_ (no host) ou qualquer outra configuração estreitar o acesso à este serviço?
* Existe alguma falha de design conhecida? Você revisou a documentação nos termos de segurança?

Para serviços que não podem ser desligados, reconfigurados ou _hardened_: Existe como proteger baseado na rede (D03) provendo pelo menos uma camada de defesa.

E ainda: Caso seu host agache por causa de regras do AppArmor ou SELinux, nunca desligue estas proteções adicionais. Encontre a causa raíz nos logs do sistema com as ferramentas fornecidas e ralaxe apenas estas regras.

### Container

Também para os containers, a melhor prática é: Não instale pacotes desnecessários [1]. O Alpine Linux possui um pequeno _footprint_ e tem menos binários a bordo. Mas ainda está entre os binários coisas como `wget` e `netcat` (provido pela busybox) também. No caso de a aplicação quebrar dentro do container estes binários podem contribuir para o atacante "ligar para casa" e requisitar alguma ferramenta. Se você deseja elevar a barra você deve olhar para imagens _"distroless"_ [2].

Existem algumas outras opções que você deve examinar. O que pode afetar a segurança do kernel do host são _syscalls_ defeituosas. No pior caso isto pode levar a uma escalada de privilégio a partir do container como usuário root do host. So-called capabilities are a superset from the syscalls. 

Aqui vão algumas defesas:

* Desabilite SUID/SGID bits (`--security-opt no-new-privileges`): mesmo que você execute como usuário, binários SUID pode elevar privilégios. Ou utilize `--cap-drop=setuid --cap-drop=setgid` quando aplicando o que vem abaixo.
* Reduza capacidades (`--cap-drop`): O Docker restringe as capacidades so-called de 38 (veja `/usr/include/linux/capability.h`) para 14 (veja ``man 7 capabilities`` e [3]). Geralmente você pode retirar `net_bind_service`, `net_raw` e mais, veja [4]. `pscap` é a ferramenta do host que lista as capacidades. Nunca use `--cap-add=all`.
* Se você precisar de controles mais granulares do que os recursos podem fornecer, você pode controlar cada uma mais de 300 _syscalls_ com seccomp com um perfil em JSON (`--security-opt seccomp=mysecure.json`), veja [5]. Cerca de 44 _syscalls_ são desabilitadas por padrão. Não utilize `unconfined` ou `apparmor=unconfined` aqui.

A melhor prática é definir qual das opções acima você escolheu. Melhor não misturar configuração de recursos e perfis seccomp.

## Como posso descobrir?

*

* É necessária atenção especial para sua ferramenta de orquestração. Existem interfaces desprotegidas por (mau) design [6], [7]-[9].
* Você sempre pode fazer a varredura do sistema na mesma rede para ver o que está exposto nesta LAN. D03 descreve como fazer isso.
* Melhor é olhar para o sistema.
    * Host: Faça logon como privilégios administrativos e veja o que está em execução utilizando `netstat -tulpn | grep -v ESTABLISHED` ou `lsof -i -Pn| grep -v ESTABLISHED`.
    * Host: Log in with administrative privileges and see what's running using `netstat -tulpn | grep -v ESTABLISHED` or `lsof -i -Pn| grep -v ESTABLISHED`. No entanto, isso não retornará os soquetes de rede dos contêineres.
    * Em um contêiner, você também pode usar esses comandos - se `netstat` ou `lsof` foram fornecidos na imagem.
* Todos os serviços também podem ser protegidos pelo firewall baseado em host. As regras que serão aplicadas por padrão variam de sistema operacional para host. Verificando a saída de `iptables -t nat -L -nv` e `iptables -L -nv` torna-se uma tarefa tediosa em ambientes maiores de contêineres. Portanto, aqui é uma boa ideia também fazer a varredura da LAN.

## Referências

* [1] Docker's [Best Practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
* [2] Google's FLOSS project [distroless](https://github.com/GoogleContainerTools/distroless)
* [3] Docker Documentation: [Runtime privilege and Linux capabilities](https://docs.docker.com/engine/reference/run/#runtime-privilege-and-linux-capabilities)
* [5] [Docker Documentation, Seccomp security profiles for Docker](https://docs.docker.com/engine/security/seccomp/)
* [6] Weak default of etcd in CoreOS 2.1: [The security footgun in etcd](https://gcollazo.com/the-security-footgun-in-etcd)
* [7] Kubernetes documentation: [Controlling access to the Kubelet](https://kubernetes.io/docs/tasks/administer-cluster/securing-a-cluster/#controlling-access-to-the-kubelet): _Kubelets expose HTTPS endpoints which grant powerful control over the node and containers. By default Kubelets allow unauthenticated access to this API. Production clusters should enable Kubelet authentication and authorization._
* [8] Github: ["Exploit"](https://github.com/kayrus/kubelet-exploit) for the API in [7].
* [9] Medium: [Analysis of a Kubernetes hack — Backdooring through kubelet](https://medium.com/handy-tech/analysis-of-a-kubernetes-hack-backdooring-through-kubelet-823be5c3d67c). Incident because of an open API, see [7].

### Comercial

* [4] RedHat Blog: Secure your Container: [One weird trick](https://www.redhat.com/en/blog/secure-your-containers-one-weird-trick)



