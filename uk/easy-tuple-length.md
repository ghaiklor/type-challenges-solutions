---
id: 18
title: Length of Tuple
lang: uk
level: easy
tags: tuple
---

## Завдання

Потрібно створити дженерик-тип `Length`, що поверне довжину заданого кортежу.

До прикладу:

```ts
type tesla = ['tesla', 'model 3', 'model X', 'model Y']
type spaceX = ['FALCON 9', 'FALCON HEAVY', 'DRAGON', 'STARSHIP', 'HUMAN SPACEFLIGHT']

type teslaLength = Length<tesla> // expected 4
type spaceXLength = Length<spaceX> // expected 5
```

## Розв'язок

Ми знаємо, що можна використати властивість `length` для доступу до довжини масиву в JavaScript.
Того ж можна досягти в типах:

```ts
type Length<T extends any> = T['length']
```

Проте, якщо зробити так, ми отримаємо помилку компіляції “Type 'length' cannot be used to index type 'T'.”.
Тож, треба дати TypeScript підказку, вказавши, що наш вхідний тип має таку властивість:

```ts
type Length<T extends { length: number }> = T['length']
```

## Посилання

- [Індексні типи](https://www.typescriptlang.org/docs/handbook/advanced-types.html#index-types)
