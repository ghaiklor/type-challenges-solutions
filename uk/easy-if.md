---
id: 268
title: If
lang: uk
level: easy
tags: utils
---

## Завдання

Реалізувати допоміжний тип `If`, який приймає умову `C`, типи `T` та `F`.
Залежно від того, чи умова `C` істинна повернути тип `T` або `F`.

Наприклад:

```ts
type A = If<true, 'a', 'b'> // expected to be 'a'
type B = If<false, 'a', 'b'> // expected to be 'b'
```

## Розв'язок

Використовуйте умовні типи [(conditional types)](https://www.typescriptlang.org/docs/handbook/advanced-types.html#conditional-types) в TypeScript коли вам необхідно вжити “if” до типів.
Якщо тип умови буде `true` то візьмемо тип з гілки “true” і навпаки.

```ts
type If<C, T, F> = C extends true ? T : F;
```

Але так ми отримаємо помилку при компіляції, тому що ми намагаємось привести `C` до булевого типу.

Виправимо це додавши обмеження `extends boolean` до параметру `C`.

```ts
type If<C extends boolean, T, F> = C extends true ? T : F;
```

## Посилання

- [Умовні типи](https://www.typescriptlang.org/docs/handbook/advanced-types.html#conditional-types)
