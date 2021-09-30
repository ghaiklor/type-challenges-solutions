---
id: 3060
title: Unshift
lang: ru
level: easy
tags: array
---

## Проблема

Реализовать типизированную версию `Array.unshift()`.
Например:

```typescript
type Result = Unshift<[1, 2], 0> // [0, 1, 2]
```

## Решение

Эта проблема имеет много общего с другой проблемой - [Push](./easy-push.md).
Там, мы использовали вариативные типы, чтобы взять все элементы из массива.

В этой проблеме мы делаем то же самое, но в другом порядке.
Сначала, давайте возьмем все элементы из входного массива:

```typescript
type Unshift<T, U> = [...T]
```

С этим куском кода, мы получаем ошибку компиляции "A rest element type must be an array type".
Починим её, добавив ограничение на тип параметре:

```typescript
type Unshift<T extends unknown[], U> = [...T]
```

Теперь у нас есть элементы входного массива в нашем кортеже.
Всё что нам нужно это добавить новый элемент в начало кортежа:

```typescript
type Unshift<T extends unknown[], U> = [U, ...T]
```

Таким образом, мы реализовали функцию `unshift()` в системе типов TypeScript!

## Что почитать

- [Дженерики](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Ограничения на дженериках](https://www.typescriptlang.org/docs/handbook/2/generics.html#generic-constraints)
- [Вариативные типы](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
