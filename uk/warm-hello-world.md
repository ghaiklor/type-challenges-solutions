---
id: 13
title: Hello, World
lang: uk
level: warm
tags: warm-up
---

## Завдання

В Type Challenges ми використовуємо систему типів для вирішення різних завдань.

Для цього завдання потрібно буде змінити наступний код так, щоб тести були успішними(без помилок у типах).

```ts
// expected to be string
type HelloWorld = any;
```

```ts
// you should make this work
type test = Expect<Equal<HelloWorld, string>>;
```

## Розв'язок

Це завдання не зовсім завдання, це радше розігрів, щоб познайомити вас з нашою пісочницею задачок, показати, як виглядають завдання і таке інше.
Все, що треба було зробити в цьому завданні, це присвоїти тип `string` замість `any`:

```ts
type HelloWorld = string;
```

## Посилання

- [Typed JavaScript at Any Scale](https://www.typescriptlang.org)
- [The TypeScript Handbook](https://www.typescriptlang.org/docs/handbook/intro.html)
- [TypeScript for Java/C# Programmers](https://www.typescriptlang.org/docs/handbook/typescript-in-5-minutes-oop.html)
- [TypeScript for Functional Programmers](https://www.typescriptlang.org/docs/handbook/typescript-in-5-minutes-func.html)
