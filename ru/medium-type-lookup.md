---
id: 62
title: Type Lookup
lang: ru
level: medium
tags: union map
---

## Проблема

Бывают ситуации, в которых нужно найти тип в объединении типов по его атрибутам.
В этой проблеме, реализуйте тип `LookUp<U, T>`, который ищет в `U` тип, поле
`type` которого равняется `T`. Например:

```typescript
interface Cat {
  type: "cat";
  breeds: "Abyssinian" | "Shorthair" | "Curl" | "Bengal";
}

interface Dog {
  type: "dog";
  breeds: "Hound" | "Brittany" | "Bulldog" | "Boxer";
  color: "brown" | "white" | "black";
}

type MyDogType = LookUp<Cat | Dog, "dog">; // expected to be `Dog`
```

## Решение

Проверим, что тип присваиваемый другому типу с атрибутами `{ type: T }` с
помощью условных типов. А так как условные типы дистрибутивные на объединениях,
эта проверка будет выполняться для каждого элемента из объединения. Таким
образом, мы переберём все элементы, пока не найдем нужный.

```typescript
type LookUp<U, T> = U extends { type: T } ? U : never;
```

## Что почитать

- [Условные типы](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Дистрибутивные условные типы](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#distributive-conditional-types)
