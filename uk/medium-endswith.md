---
id: 2693
title: EndsWith
lang: uk
level: medium
tags: template-literal
---

## Завдання

Реалізувати тип `EndsWith<T, U>`, який перевіряє, чи рядок `T` закінчується на
рядок `U`. Наприклад:

```typescript
type R0 = EndsWith<"abc", "bc">; // true
type R1 = EndsWith<"abc", "abc">; // true
type R2 = EndsWith<"abc", "d">; // false
```

## Розв'язок

Не впевнений, що це завдання повинно бути в категорії середнього рівня
складності. Це більше схоже не легкий рівень складності, ніж на середній. Але,
хто я такий, щоб судити.

Нам потрібно перевірити, що рядок закінчується на вказаний підрядок. Якщо в
справі замішані рядки, то нам точно будуть корисні рядкові тип літерали.

Давайте почнемо з найпростішого рядкового тип літералу, який відображає всі
можливі рядки. Так як нам зміст, поки що, не цікавий, використаємо тип `any`:

```typescript
type EndsWith<T extends string, U extends string> = T extends `${any}`
  ? never
  : never;
```

За допомогою цього виразу ми кажемо компілятору перевірити, чи тип `T`
привласнюється до `any`. Що, звичайно ж, так.

Тепер, давайте додамо наший підрядок в рішення. Нам потрібно перевірити що
підрядок `U` знаходиться в кінці рядка `T`. Давайте так і зробимо:

```typescript
type EndsWith<T extends string, U extends string> = T extends `${any}${U}`
  ? never
  : never;
```

Використовуючи таку конструкцію, ми перевіряємо, що рядок привласнюється до
всього, що закінчується на `U` - просто. Все що залишається це повернути `true`
або `false` літерали в залежності від результату:

```typescript
type EndsWith<T extends string, U extends string> = T extends `${any}${U}`
  ? true
  : false;
```

## Посилання

- [Умовні типи](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Рядкові тип літерали](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types)
