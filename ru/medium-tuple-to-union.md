---
id: 10
title: Tuple to Union
lang: ru
level: medium
tags: infer tuple union
---

## Проблема

Реализовать `TupleToUnion<T>` который переводит элементы кортежа в их
объединение. Например:

```typescript
type Arr = ["1", "2", "3"];
const a: TupleToUnion<Arr>; // expected to be '1' | '2' | '3'
```

## Решение

Нам нужно взять все элементы из массива и конвертировать их в объединение
элементов. К счастью, TypeScript это умеет делать на уровне системы типов - типы
поиска.

Используя конструкцию `T[number]` мы получим объединение всех элементов кортежа
`T`:

```typescript
type TupleToUnion<T> = T[number];
```

Но, это решение не компилируется по причине “Type ‘number’ cannot be used to
index type ‘T’“. Потому что, нету ограничений на `T`, которые укажут на
принадлежность `T` к массиву, типу, который можно проиндексировать. Починим это,
добавив ограничение:

```typescript
type TupleToUnion<T extends unknown[]> = T[number];
```

## Что почитать

- [keyof и типы поиска](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-1.html#keyof-and-lookup-types)
