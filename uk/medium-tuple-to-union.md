---
id: 10
title: Tuple to Union
lang: uk
level: medium
tags: infer tuple union
---

## Завдання

Реалізувати `TupleToUnion<T>` який переводить елементи масиву в їх об'єднання.
Наприклад:

```typescript
type Arr = ['1', '2', '3']
const a: TupleToUnion<Arr> // expected to be '1' | '2' | '3'
```

## Розв'язок

Нам потрібно взяти всі елементи з масиву й конвертувати їх в об'єднання елементів.
На щастя, TypeScript вміє це робити на рівні системи типів — типи пошуку.

Використовуючи конструкцію `T[number]` ми отримаємо об'єднання всіх елементів масиву `T`:

```typescript
type TupleToUnion<T> = T[number]
```

Але, цей розв'язок не компілюється через “Type ‘number’ cannot be used to index type ‘T’“.
Тому що немає обмежень на `T`, які вкажуть на приналежність `T` до масиву — типу, який можна проіндексувати.
Виправимо це, додавши обмеження:

```typescript
type TupleToUnion<T extends unknown[]> = T[number]
```

## Посилання

- [keyof й типи пошуку](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-1.html#keyof-and-lookup-types)
