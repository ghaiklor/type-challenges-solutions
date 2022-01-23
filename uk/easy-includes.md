---
id: 898
title: Includes
lang: uk
level: easy
tags: array
---

## Завдання

Реалізувати функцію JavaScript `Array.includes` в системі типів.
Тип приймає два аргументи.
Результат повинен бути `true` або `false`.

Наприклад:

```typescript
// expected to be `false`
type isPillarMen = Includes<["Kars", "Esidisi", "Wamuu", "Santana"], "Dio">;
```

## Розв'язок

Почнемо з того, що створимо тип, який приймає два аргументи: `T` (кортеж із елементів) та `U` (елемент, який ми шукаємо):

```typescript
type Includes<T, U> = never;
```

Перед тим, як шукати щось у кортежі, легше "перетворити" його на об'єднання елементів.
Для цього використаємо індексні типи.
Якщо ми напишемо конструкцію `T[number]`, TypeScript поверне об'єднання усіх елементів з `T`.
Тобто, якщо маємо `T = [1, 2, 3]` то доступ через `T[number]` поверне `1 | 2 | 3`.

```typescript
type Includes<T, U> = T[number];
```

Але в такому випадку ми отримаємо помилку “Type ‘number’ cannot be used to index type ‘T’”.
Це тому що у нас немає жодних обмежень для `T`.
Потрібно сказати TypeScript-у, що `T` - це масив.

```typescript
type Includes<T extends unknown[], U> = T[number];
```

Маємо об'єднання елементів.
Як перевірити чи елемент існує в цьому об'єднанні?
Дистрибутивні (розподілені) умовні типи!
Ми можемо написати умовний тип для об'єднання і TypeScript автоматично застосує цю умову до кожного елементу об'єднання.

Тобто якщо ви напишете `2 extends 1 | 2`, TypeScript насправді замінить це двома умовами `2 extends 1` та `2 extends 2`.

Використаємо це, щоб перевірити чи є `U` у `T[number]` і, якщо так, повернемо `true`.

```typescript
type Includes<T extends unknown[], U> = U extends T[number] ? true : false;
```

## Посилання

- [Дженерики](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Обмеження дженериків](https://www.typescriptlang.org/docs/handbook/2/generics.html#generic-constraints)
- [Умовні типи](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Дистрибутивні умовні типи](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#distributive-conditional-types)
- [Індексні типи](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)
