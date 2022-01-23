---
id: 15
title: Last of Array
lang: ru
level: medium
tags: array
---

## Проблема

Реализовать тип `Last<T>` который принимает массив `T` и возвращает тип его последнего элемента.
Например:

```typescript
type arr1 = ["a", "b", "c"];
type arr2 = [3, 2, 1];

type tail1 = Last<arr1>; // expected to be 'c'
type tail2 = Last<arr2>; // expected to be 1
```

## Решение

Когда нужно получить последний элемент из кортежа, можно перебрать все элементы кроме последнего.
Для этой задачи подходят вариативные типы.

Зная о вариативных типах, решение очевидное.
Берём элементы от начала кортежа до тех пор, пока не дойдём до последнего элемента.
Совмещая это с выведением типов в условных типах, решение становится банально простым.

```typescript
type Last<T extends any[]> = T extends [...infer X, infer L] ? L : never;
```

## Что почитать

- [Условные типы](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Выведение типов в условных типах](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Вариативные типы](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
