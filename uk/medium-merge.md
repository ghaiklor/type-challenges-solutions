---
id: 599
title: Merge
lang: uk
level: medium
tags: object
---

## Завдання

Об'єднайте два типи в один.
Ключі другого типу замінюють ключі першого.
Наприклад:

```typescript
type Foo = {
  a: number;
  b: string;
};

type Bar = {
  b: number;
};

type merged = Merge<Foo, Bar>; // expected { a: number; b: number }
```

## Розв'язок

Дане завдання дуже схоже на [“append to object”](./medium-append-to-object.md).
Тоді ми використовували об'єднання типів, щоб зібрати всі властивості об'єкту та рядок в один тип.

Повторюємо те саме і тут.
Як результат, отримаємо об'єкт з ключами першого і другого типів.

```typescript
type Merge<F, S> = { [P in keyof F | keyof S]: never };
```

Маючи ключі обох об'єктів, почнемо проставляти типи їх значень.
Почнемо з `S`, тому що він може переназначити властивості типу `F`.
Також перевіряємо наявність властивостей у типі `S`:

```typescript
type Merge<F, S> = { [P in keyof F | keyof S]: P extends keyof S ? S[P] : never };
```

У випадку, коли властивість відсутня, ми перевіряємо її наявність у типі `F`.
Якщо є, то беремо значення звідти.

```typescript
type Merge<F, S> = { [P in keyof F | keyof S]: P extends keyof S ? S[P] : P extends keyof F ? F[P] : never };
```

## Посилання

- [Об'єднання типів](https://www.typescriptlang.org/docs/handbook/2/everyday-types.html#union-types)
- [Типи пошуку](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-1.html#keyof-and-lookup-types)
- [Типи зіставлення](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
- [Умовні типи](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
