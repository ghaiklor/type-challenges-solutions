---
id: 189
title: Awaited
lang: es
level: easy
tags: promise
---

## Desafío

Si tenemos un tipo el cual es un tipo encapsulador como `Promise`. ¿Cómo podemos 
obtener un tipo que está dentro del tipo encapsulador? Por ejemplo, si tenemos 
`Promise<ExampleType>` ¿cómo obtenemos `ExampleType`?

## Solución

Un desafío bastante interesante que requiere que conozcamos una de las 
características subestimadas de TypeScript, en mi humilde opinión.

Pero, antes de explicar lo que quiero decir, analicemos el desafío. El autor
nos pide que extraigamos el tipo. ¿Qué es extraer en este contexto? Esto es 
extraer el tipo interno de otro tipo.

Déjame explicarlo con un ejemplo. Si tienes un tipo `Promise<string>`,
extraer el tipo `Promise` dará como resultado el tipo `string`. 
Al extraer, obtuvimos el tipo interno del tipo externo.

Ten en cuenta que también debes extraer el tipo de forma recursiva. Por ejemplo, 
si tienes el tipo `Promise<Promise<string>>`, debes extraer el tipo `string`.

Ahora, el desafío. Comenzaré con el caso más simple. Si nuestro tipo `Awaited`
obtiene `Promise<string>`, debemos extraer el `string`, de lo contrario, 
devolvemos el `T` en sí, porque no es un `Promesa`:

```ts
type Awaited<T> = T extends Promise<string> ? string : T;
```

Sin embargo, hay un problema. De esa manera, podemos solo encargarnos de 
`strings` en `Promise`, sin embargo debemos poder manejar cualquier caso. ¿Cómo 
lo logramos? ¿Cómo obtener podemos el tipo de `Promise` si no sabemos que es lo 
que hay alli?

Para estas propuestas, TypeScript tiene inferencia de tipos en los tipos 
condicionales. Puede decirle al compilador "hey, una vez sepas que tipo es este, 
asignalo a mi parámetro, por favor". Puedes leer más sobre [inferencia de tipos en los tipos condicionales aquí](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-8.html#type-inference-in-conditional-types).

Al conocer sobre la inferencia de tipo, podemos actualizar nuestra solución.
En vez de propbar `Promise<string>` en nuestro tipo condicional, podemos 
remplazar `string` con `infer R`, porque no sabemos que tipo debe ir alli. 
Lo único que sabemos es que es un `Promise<T>` con algún tipo dentro.

Una vez TypeScript descubre que tipo es el cual esta dentro de `Promise`, 
lo asignara a nuestro parámetro tipo `R` y está disponible en la rama `true`.
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

## Referencias

- [Tipos Condicionales](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Inferencia de Tipo en Tipos Condicionales](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
