---
id: 43
title: Exclude
lang: uk
level: easy
tags: built-in
---

## Завдання

Реалізувати вбудований тип `Exclude<T, U>`.

> Виключити з типу `T` ті типи, що є присвоюваними в `U`

```ts
type T0 = Exclude<"a" | "b" | "c", "a">; // "b" | "c"
type T1 = Exclude<"a" | "b" | "c", "a" | "b">; // "c"
```

## Розв'язок

Для вирішення цього завдання важливо знати, що умовні типи в TypeScript
[дистрибутивні](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#distributive-conditional-types).

Тож, коли ви пишете `T extends U`, де `T` є об'єднанням, TypeScript застосує
умову до кожного елементу з `T`.

Зважаючи на це, рішення виглядатиме просто. Ми перевірятимемо, чи `T` можна
присвоїти в тип `U` і, якщо це так, будемо пропускати `T`, повертаючи `never`.
Іншими словами, це означає, що поточний елемент із `T` не знаходиться в `U`, а
отже ми можемо повернути його:

```ts
type MyExclude<T, U> = T extends U ? never : T;
```

## Посилання

- [Дистрибутивні умовні типи](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#distributive-conditional-types)
