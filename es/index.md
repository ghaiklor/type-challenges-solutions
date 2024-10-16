---
title: Desafíos de Tipos
description: >-
  Este proyecto tiene como objetivo ayudarte a comprender mejor cómo funciona 
  el sistema de tipos, escribir tus propias utilidades o simplemente divertirte 
  con los desafíos.
keywords: "type, challenges, solutions, typescript, javascript"
lang: es
comments: false
---

¿Qué son los Desafíos de Tipos?
[Desafíos de Tipos](https://github.com/type-challenges/type-challenges) es un
proyecto desarrollado y mantenido por Anthony Fu. El objetivo principal del
proyecto es recopilar y proporcionar desafíos interesantes para TypeScript.
Pero hay un matiz en estos desafíos. No puedes usar el entorno de ejecución
(runtime) para resolverlos. El único lugar donde necesitas escribir el "código"
es en el sistema de tipos. Por lo tanto, los Desafíos de Tipos son los desafíos
que deben resolverse únicamente utilizando el sistema de tipos de TypeScript.

Estos desafíos a veces se vuelven difíciles, especialmente si eres principiante
en tipos y TypeScript. Por eso, este sitio web ofrece un lugar donde puedes
encontrar soluciones para esos desafíos con una explicación de cómo se han
resuelto. Una vez que leas la explicación, podrás encontrar una lista compilada
de referencias útiles para profundizar más. En caso de que hayas resuelto el
desafío de alguna otra manera (no como en este sitio web), puedes dejarlo en los
comentarios.

Si tienes alguna pregunta, problema, etc., por favor
[abre un issue en el repositorio](https://github.com/ghaiklor/type-challenges-solutions/issues).

Ahora, te sugiero que comiences desde “Calentamiento” y vayas avanzando al
nivel “Extremo”, desafío por desafío. Primero, abre el enlace “Desafío” e
intenta resolverlo tú mismo. En caso de que no puedas, regresa aquí y abre la
“Solución”.

Sin más preámbulos, ¡tómate tu tiempo y disfruta de los desafíos!

{% assign challenges = site.pages | where: "lang", "en" %}
{% include challenges.html challenges = challenges %}
