---
id: 3196
title: Flip Arguments
lang: uk
level: medium
tags: array
---

## Завдання

Реалізуйте типізовану версію lodash `_.flip`.

Тип `FlipArguments<T>` приймає тип функції `T` і повертає новий тип функції,
який має той самий тип повернення, але параметри в зворотньому порядку.

Наприклад:

```ts
type Flipped = FlipArguments<
  (arg0: string, arg1: number, arg2: boolean) => void
>;
// (arg0: boolean, arg1: number, arg2: string) => void
```

## Розв'язок

Рішення цієї проблеми дуже просте. Перевіряємо, чи тип `T`
є типом функції, і якщо так, то змінюємо порядок аргументів.

```ts
type FlipArguments<T> = T extends (...args: [...infer P]) => infer R
  ? never
  : never;
```

Захопивши аргументи функції в `P` і її тип повернення в `R`, давайте змінимо
порядок аргументів та повернемо те ж саме з нашого виразу вище.

```ts
type MyReverse<T extends unknown[]> = T extends [...infer F, infer S]
  ? [S, ...MyReverse<F>]
  : [];

type FlipArguments<T> = T extends (...args: [...infer P]) => infer R
  ? (...args: MyReverse<P>) => R
  : never;
```

## Посилання

- [Умовні типи](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Виведення типів в умовних типах](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
