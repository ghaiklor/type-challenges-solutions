---
id: 2759
title: RequiredByKeys
lang: uk
level: medium
tags: object-keys
---

## Завдання

Реалізуйте загальний `RequiredByKeys<T, K>`, який приймає два аргументи типу `T`
і `K`.

`K` визначає набір властивостей `T`, які мають бути обов'язковими. Якщо `K` не
надано, він має зробити всі властивості обов'язковими, як звичайний
`Required<T>`.

## Розв'язок

В завданні нас просять позначити всі властивості, наявні в `K`, як обов'язкові.
Отже, спочатку давайте виберемо всі ці властивості.

```ts
type RequiredProperties<T, K> = {
  [P in keyof T as P extends K ? P : never]-?: T[P];
};
```

Зверніть увагу, як ми використали `-?` у виразі вище. Це те, що ми називаємо
[Модифікатор на типах зіставлення](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html#mapping-modifiers).
Це говорить TypeScript, що ми не хочемо, щоб жодна з властивостей мала
модифікатор `?`.

Тепер, коли у нас є **обов'язкові** властивості, давайте витягнемо всі
властивості, які слід залишити без змін. Це набір властивостей, яких немає в
`K`.

```ts
type MyOmit<F, S> = { [P in keyof F as P extends S ? never : P]: F[P] };

type EverythingFromTExceptK<T, K> = MyOmit<T, K>;
```

Так як ми маємо обидві частини нашого рішення, давайте об'єднаємо їх в один тип.

```ts
type MyMerge<T> = { [P in keyof T]: T[P] };

type RequiredByKeys<T, K = keyof T> = MyMerge<
  RequiredProperties<T, K> & EverythingFromTExceptK<T, K>
>;
```

## Посилання

- [Типи зіставлення](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
- [Умовні типи](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Модифікатори на типах зіставлення](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html#mapping-modifiers)
