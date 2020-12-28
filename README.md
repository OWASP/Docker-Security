Segurança Docker
================

Este é o OWASP Docker Top 10. Este é um trabalho em desenvolvimento.

## Sobre este documento

Este documento descreve od dez mais mais importantes pontos de segurança para construção de um ambiente seguro de containers. Você pode utilizá-lo como uma especificação caso esteja iniciando do zero e opcionalmente entregá-lo a um terceiro que esteja realizando isto por você.

Você pode também utilizá-lo para auditar ou melhorar a segurança de uma instalação já existente, mas recomendamos que considere pensar em segurança desde o princípio.
Melhor ainda na fase de desenho. Depois torna-se mais difícil mudar algumas decisões que você pode ter tomado e isto se tornar caro, em temos financeiros ou de tempo.

### Nome

Embora o nome do documento relembre o OWASP TOP 10, este documento é difere um pouco. Primeiro, não trata sobre riscos que são baseados em dados coletados como no OWASP TOP 10. Segundo os dez itens aqui se assemelham mais a controles proativos.

### Para quem é este documento?

Este guia á para desenvolvedores, auditores, arquitetos e engenheiros de sistemas e de rede. Como indicado acima você pode utilizar este guia com parceiros externos para acrescentar de maneira forma requisitos técnicos a seu contrato. O CISO deve ter algum interesse em alcançar uma linha de base de requisitos de segurança.

Estes dez itens são mais (veja parágrafo abaixo) a respeito da arquitetura de segurança de sistema e de rede. Como desenvolvedor você não deverá ser um especialista nestes tópicos -- é para isto que serve este guia. Mas como indicado acima é melhor começar a pensar e endereçar estes pontos antecipadamente. 

Um dos itens não deve ser mal interpretado: Patch management não é um ponto técnico. É um processo de gerenciamento. Por último mas não menos importante para técnicos de segurança ou para gerência que estejam preocupados com a conteinerização este documento também provê conhecimento sobre os riscos envolvidos.

### Estrutura deste documento

Segurança em ambientes Docker geralmente é mal compreendido. Sempre é uma grande e controvesa disputa a respeito de quais seriam as ameaças. Portanto, antes de mergulhar nos dez itens do Docker Top 10, as ameaças necessitam de serem modeladas antecipadamente a este documento. Isto não apenas ajuda na compreensão dos impactos de segurança como também oferece a você a habilidade de priorizar suas tarefas.

### Como compilar a versão PDF

Você pode compilar de forma autônoma a versão PDF desde que possua o Docker (e o [docker compose][1]) instalados.

```
docker-compose run --rm build
```

## FAQ

### Porque não "Container Security"?

Embora o nome do projeto carregue o nome "Docker", ele também pode ser utilizado com pouca abstração para outras soluções de containerização. Docker é atualmente o mais popular, então os detalhes são focados atualmente no Docker. Isto poderá mudar depois.

### Um único container?

Se você executa mais de 3 containeres em um servidor você provavelmente precisa de uma solução de orquestração para gerenciá-los. Armadilhas de segurança _específicas_ nessas ferramentas podem estar fora do escopo deste documento. Isto não significa que este guia seja apenas a respeito de poucos containeres gerenciados manualmente -- pelo contrário. Isto significa que você está olhando para os conteineres incluindo sua rede e seus sistemas host em determinado ambiente de orquestração e não em armadilhas específicas de soluções como _Kubernetes_,_Swarm_, _Mesos_ or _OKD/OpenShift_.

### Porque dez?

Para se honesto, para nós humanos o número dez soa atraente enquando colocar todos juntos entre os dez é considerá-los os mais importantes.

[1]: https://docs.docker.com/compose/