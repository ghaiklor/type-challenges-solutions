---
id: 11
title: Tuple to Object
lang: uk
level: easy
tags: tuple
---

## Завдання

Перетворити отриманий масив на об'єкт, де парами ключ-значення будуть елементи цього масиву.

Наприклад:

```ts
const tuple = ['tesla', 'model 3', 'model X', 'model Y'] as const

// expected { tesla: 'tesla', 'model 3': 'model 3', 'model X': 'model X', 'model Y': 'model Y'}
const result: TupleToObject<typeof tuple>
```

## Розв'язок

Нам потрібно взяти всі значення масиву і зробити їх ключами та, відповідно, значеннями нашого нового об'єкта.

Це легко зробити з індексними типами.
Ми можемо взяти значення масиву використовуючи вираз `T[number]`.
За допомогою типів зіставлення, ми можемо ітерувати значення через `T[number]` і повернути новий тип, ключами та значеннями якого будуть відповідні елементи `T[number]`:

```ts
type TupleToObject<T extends readonly any[]> = { [K in T[number]]: K }
```

## Посилання

- [Типи співставлення](https://www.typescriptlang.org/docs/handbook/advanced-types.html#mapped-types)
- [Індексні типи](https://www.typescriptlang.org/docs/handbook/advanced-types.html#index-types)
