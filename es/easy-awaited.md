---
id: 189
title: Awaited
lang: es
level: easy
tags: promise
---

## Challenge

Si tenemos un tipo el cual esta envuelto por un otro tipo como `Promise`. Como 
podemos obtener el tipo que ha sido envuelto? Por ejemplo, si tenemos 
`Promise<ExampleType>`, como obtenemos `ExampleType`??


## Solution

Es un desafio bastante interesante el cual require que conozcamos una de las
caracteristicas mas infravaloradas de TypeScript, en mi humilde opinion.

Pero, antes de explicar a lo que me refiero, analicemos el desafio. El autor
nos pide que desenvolvamos el tipo. Que es desenvolver? Desenvolver es extraer
el tipo interno dentro de otro tipo.

Dejame explicar con un ejemplo. Si tienes un tipo `Promise<string`, 
desenvolviendo el tipo `Promise` resultara en el tipo `string`. Obtenemos el 
tipo interno de el tipo externo.

Nota que tambien necesitas desenvolver el tipo recursivamente. Por ejemplo,
si tienes el tipo `Promise<Promise<string>>` tienes que regresar el tipo 
`string`.

Ahora, al desafio. Empezare con el caso mas sencillo. Si nuestro tipo
`Awaited` obtiene `Promise<string`, necesitamos retornar `string`, de lo 
contrario debemos retornar `T`, porque `T` no es de tipo `Promise`: 

```ts
type Awaited<T> = T extends Promise<string> ? string : T;
```

Sin embargo, hay un problema. De esa manera, podemos solo encargarnos de 
`strings` en `Promise`, sin embargo debemos poder manejar cualquier caso. 
Como lo logramos? Como podemos obtener el tipo de `Promise` si no sabemos
que es lo que hay alli?

Para estos propositos, TypeScript tiene inferencia de tipos en los tipos 
condicionales! Puede decirle al compilador "hey, una vez sepas que tipo es este, 
asignalo a mi parametro, por favor". Puedes leer mas sobre [inferencia de tipos
en los tipos condicionales aqui](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-8.html#type-inference-in-conditional-types).

Al conocer sobre la inferencia de tipo, podemos actualizar nuestra solucion. 
En vez de propbar `Promise<string>` en nuestro tipo condicional, podemos 
remplazar `string` con `infer R`, porque no sabemos que tipo debe ir alli. Lo 
unico que sabemos es que es un `Promise<T>` con algun tipo dentro.

Una vez TypeScript descubre que tipo es el cual esta dentro de `Promise`, 
lo asignara a nuestro parametro tipo `R` y esta disponible en la rama `true`.
Exactamente donde lo retornamos.

```ts
type Awaited<T> = T extends Promise<infer R> ? R : T;
```

Estamos casi listos, sin embargo del tipo `Promise<Promise<string>>`, obtenemos
el tipo `Promise<string>`. Es por esto que necesitamos repetir el mismo proceso
recursivamente, lo cual es logrado usando `Awaited` en si mismo.

```ts
type Awaited<T> = T extends Promise<infer R> ? Awaited<R> : T;
```

## Referenccias

- [Tipos Condicionales](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Inferencia de Tipo en Tipos Condicionales](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
