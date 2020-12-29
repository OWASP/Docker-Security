Segurança Docker
================

Este é o OWASP Docker Top 10. Este é um trabalho em andamento.

## Sobre este documento

Este documento descreve os 10 tópicos em segurança mais importantes para a construção de um ambiente containerizado seguro. Você pode utilizá-lo como uma ficha de especificações caso esteja iniciando do zero ou, alternativamente, entregá-lo a um terceiro que esteja fazendo isto por você.

Você pode também utilizá-lo para auditar ou melhorar a segurança de uma instalação já existente mas recomendamos que considere pensar na segurança desde o princípio.
Melhor ainda na etapa de projeto. Em um momento posterior ou se torna mais difícil modificar as decisões que você tomou ou elas se tornam mais custosas, em termos financeiros ou de tempo.

### Nome

Embora o nome deste documento relembre o OWASP Top 10, ele é bem diferente. Primeiro, ele não trata de riscos baseados em dados coletados, como no OWASP Top 10. Segundo, os 10 tópicos aqui se assemelham mais a controles proativos.

### Para quem é este documento?

Este guia é para desenvolvedores, auditores, arquitetos e engenheiros de sistemas e de rede. Como indicado acima você também pode utilizar este guia com parceiros externos para acrescentar requisitos técnicos formais. O Information Security Officer deveria também ter algum interesse em alcançar as linhas de base de requisitos de segurança e além.

Estes 10 tópicos são em maior parte (veja o parágrafo abaixo) sobre a segurança de sistemas e redes e a arquitetura de sistemas e redes. Como desenvolvedor você não precisa ser um especialista nestes tópicos -- é para isto que serve este guia. Mas como indicado acima é melhor começar a pensar e endereçar estes pontos antecipadamente. Por favor não comece um projeto pela construção.

Um dos tópicos não deve ser mal interpretado: Gerenciamento de patches não é um tópico técnico. É um processo de gerenciamento. Por último mas não menos importante, para a gerência técnica ou de segurança da informação que não tenha tido muita preocupação com a conteinerização, este documento também provê _insights_ sobre os riscos envolvidos.

### Estrutura deste documento

A segurança em ambientes Docker geralmente é mal compreendida. Foi / é uma grande e controversa disputa a respeito do que consiste uma ameaça. Portanto, antes de mergulhar nos tópicos do Docker Top 10, as ameaças precisam ser modeladas, o que faremos de antemão neste documento. Isto não apenas ajuda na compreensão dos impactos de segurança como também oferece a você a habilidade de priorizar suas tarefas.

### Como compilar a versão PDF

Você mesmo pode compilar a versão PDF desde que possua o Docker (e o [docker compose][https://docs.docker.com/compose/]) instalados.

```
docker-compose run --rm build
```

## FAQ (Perguntas mais frequentes)

### Por que não "Segurança de containeres"?

Embora o nome do projeto carregue o nome "Docker", ele também pode ser utilizado com pouca abstração para outras soluções de containerização. Docker é atualmente o mais popular então os detalhes são focados atualmente no Docker. Isto poderá mudar depois.

### Um único container?

Se você executa mais de 3 containeres em um servidor você provavelmente precisa de uma solução de orquestração para gerenciá-los. Armadilhas de segurança _específicas_ de tais ferramentas estão atualmente fora do escopo deste documento. Isto não significa que este guia seja apenas a respeito de poucos containeres gerenciados manualmente -- pelo contrário. Significa somente que estamos olhando para os conteineres incluindo sua rede e seus sistemas hospedeiros (_hosts_) em determinado ambiente de orquestração e não em armadilhas específicas de soluções como _Kubernetes_,_Swarm_, _Mesos_ ou _OKD/OpenShift_.

### Por que dez?

Para se honesto o número 10 atrai a atenção de nós humanos e ao montar o documento estes 10 foram considerados os mais importantes.
