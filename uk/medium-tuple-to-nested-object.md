---
id: 3188
title: Tuple to Nested Object
lang: uk
level: medium
tags: array
---

## Завдання

Дано тип кортежу `T`, який містить лише рядки, і тип `U`. Створіть об'єкт рекурсивно.

```ts
type a = TupleToNestedObject<["a"], string>; // {a: string}
type b = TupleToNestedObject<["a", "b"], number>; // {a: {b: number}}
type c = TupleToNestedObject<[], boolean>; // boolean. if the tuple is empty, just return the U type
```

## Розв'язок

Давайте почнемо з перебору кортежу, виводячи його вміст.

```ts
type TupleToNestedObject<T, U> = T extends [infer F, ...infer R]
  ? never
  : never;
```

Що робити, якщо `Т` порожній? У цьому випадку ми повертаємо тип `U` як є.

```ts
type TupleToNestedObject<T, U> = T extends [infer F, ...infer R] ? never : U;
```

Оскільки ключі для `object` можуть бути лише типу `string`, ми повинні перевірити, чи є `F` рядком.

```ts
type TupleToNestedObject<T, U> = T extends [infer F, ...infer R]
  ? F extends string
    ? never
    : never
  : U;
```

Якщо `F` це рядок, нам потрібно створити об'єкт і рекурсивно пройти решту кортежу.
Таким чином ми пройдемо весь кортеж і створимо вкладені об'єкти, поки кортеж не буде
порожній, після чого ми просто повернемо `U` як його тип.

```ts
type TupleToNestedObject<T, U> = T extends [infer F, ...infer R]
  ? F extends string
    ? { [P in F]: TupleToNestedObject<R, U> }
    : never
  : U;
```

## Посилання

- [Умовні типи](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Виведення в умовних типах](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Рекурсивні умовні типи](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
