---
id: 13
title: Hello, World
lang: ru
level: warm
tags: warm-up
---

## Проблема

В Type Challenges нужно решать проблемы, используя только систему типов и ничего больше.
Эта проблема является ознакомительной, чтобы вы лучше поняли как происходит процесс решения.

```typescript
// expected to be string
type HelloWorld = any
```

```typescript
// you should make this work
type test = Expect<Equal<HelloWorld, string>>
```

## Решение

Эта проблема, на самом деле, и не проблема вовсе.
Она используется как песочница, чтобы ознакомить вас с процессом решения проблем в песочнице TypeScript.

Всё что нам нужно здесь сделать, это заменить `any` на `string` и увидеть, что в песочнице компиляция проходит успешно.

```typescript
type HelloWorld = string
```

## Что почитать

- [Typed JavaScript at Any Scale](https://www.typescriptlang.org)
- [The TypeScript Handbook](https://www.typescriptlang.org/docs/handbook/intro.html)
- [TypeScript for Java/C# Programmers](https://www.typescriptlang.org/docs/handbook/typescript-in-5-minutes-oop.html)
- [TypeScript for Functional Programmers](https://www.typescriptlang.org/docs/handbook/typescript-in-5-minutes-func.html)
