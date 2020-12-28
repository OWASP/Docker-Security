# D07 - Resource Protection

## Cenários de ameaça

A depender do SO do host não haverá qualquer restrição para o container em termpos de CPU, memória -- ou rede e I/O de disco. A ameaça é tanto com relação à uma falha do software quanto ao uso deliberado destes recursos por um atacante que causa problemas e afeta recursos do host subjacente e por consequência também de todos os containers.

Além disso se um container foi provisionado com medidas padrão de segurança, por ex. O docker compartilha recursos físicos com outros containers e o host, principalmente CPU e memória. Se um dos outros containers utilizar estes recursos de forma intensa, não sobrará muito para o seu container.

A rede também é um recurso compartilhado e comummente quando o dado está sendo lido ou escrito, o recurso físico é o mesmo.

Para a memória é importante compreender que existe um detalhe chamado _OOM [1] killer_ no kernel dos hosts Linux. O _OOM killer_ entra quando o kernel está com pouca memória. Então este processo - usando alguns algoritmos [2] - libera alguma memória para o host e para o próprio kernel para que ele permaneça responsivo. O processos que são destruídos não são necessariamente aqueles responsáveis pelo alto uso de memória (consulte o _OOM SCORE_ [3]) e muitas vezes é a memória do host que está insuficiente.

## Como prevenir?

Primeiro é melhor impor limites razoáveis de uso de memória e CPU por container. Ao alcançar estes limites o container não está apto a alocar mais memória ou consumir mais CPU.

Para memória existem dois principais variáveis para impor limite de rígido uso ``-memory`` e ``--memory-swap``. Limites não rígidos podem ultrapassar os valores especificados. Eles podem ser definidos com ``--memory-reservation``. Para uma descrição completa consulte a documentação do Docker [4]. Para proteção de processos no container você pode configurar ``--oom-kill-disable``. Dessa forma os _deamons_ terão um baixo _score_ de OOM e normalmente não serão destruídos.
 
## Como posso descobrir?

* Configurado: ``docker inspect``
* Em execução: ``docker stats``, inclui o que está configurado
* Detalhes sobre memória: ``/sys/fs/cgroup/memory/docker/$CONTAINERID/*

## References

* [1] OOM stands for Out of Memory Management
* [2] https://www.kernel.org/doc/gorman/html/understand/understand016.html
* [3] https://lwn.net/Articles/317814/
* [4] https://docs.docker.com/config/containers/resource_constraints/
