---
id: 16
title: Pop
lang: ru
level: medium
tags: array
---

## Проблема

Реализовать тип `Pop<T>` который берёт массив `T` и возвращает новый массив без последнего элемента.
Например:

```typescript
type arr1 = ["a", "b", "c", "d"];
type arr2 = [3, 2, 1];

type re1 = Pop<arr1>; // expected to be ['a', 'b', 'c']
type re2 = Pop<arr2>; // expected to be [3, 2]
```

## Решение

Разделим массив на две части: всё что идёт от начала до последнего элемента и последний элемент.
После, избавимся от последнего элемента и вернём только начало.

Чтобы этого добиться, воспользуемся вариативными типами.
Совмещая их с выведением в условных типах, выведем необходимые части массива.
В случае, если `T` присваиваемый к массиву, который можно разбить на две части, возвращаем его первую часть.
Иначе, возвращаем `never`, чтобы отобразить ситуацию, когда задача нерешаемая.

```typescript
type Pop<T extends any[]> = T extends [...infer H, infer T] ? H : never;
```

## Что почитать

- [Условные типы](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Выведение в условных типах](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Вариативные типы](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
