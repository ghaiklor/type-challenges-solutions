---
id: 898
title: Includes
lang: ru
level: easy
tags: array
---

## Проблема

Реализовать функцию `Array.includes` из JavaScript в системе типов TypeScript.
Этот тип принимает два тип параметра. Результатом должно быть либо `true`, либо
`false`. Например:

```typescript
// expected to be `false`
type isPillarMen = Includes<["Kars", "Esidisi", "Wamuu", "Santana"], "Dio">;
```

## Решение

Начнём с типа, который принимает два тип параметра: `T` (кортеж из элементов) и
`U` (что мы ищем в кортеже).

```typescript
type Includes<T, U> = never;
```

Прежде чем приступить к поиску в кортеже, облегчим себе жизнь и приведём кортеж
в объединение элементов. Для этого воспользуемся индексными типами. Используя
индексные типы, мы можем написать конструкцию `T[number]`, результатом которой
будет объединение элементов из кортежа `T`. Например, если у вас
`T = [1, 2, 3]`, то результатом `T[number]` будет `1 | 2 | 3`.

```typescript
type Includes<T, U> = T[number];
```

Получаем ошибку “Type ‘number’ cannot be used to index type ‘T’”. У нас нету
никаких ограничений на `T`, которые укажут что это массив. Поэтому TypeScript не
гарантирует, что обращение по индексу возможно. Починим это, указав, что `T` -
массив.

```typescript
type Includes<T extends unknown[], U> = T[number];
```

На этом этапе, у нас есть объединение элементов из кортежа `T`. Как же
проверить, что элемент существует в объединении? Дистрибутивные условные типы!
Напишем условный тип для `T[number]` и TypeScript проверит наше условие по
отношению к каждому элементу из объединения.

Например, если мы напишем `2 extends 1 | 2`, то TypeScript выполнит две проверки
`2 extends 1` и `2 extends 2`. Проверим, что элемент, который мы ищем [`U`],
находится в объединении элементов `T`. В случае, элемент находится в объединении
элементов, мы возвращаем `true`, иначе - `false`.

```typescript
type Includes<T extends unknown[], U> = U extends T[number] ? true : false;
```

## Что почитать

- [Общие типы](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Ограничения на общих типах](https://www.typescriptlang.org/docs/handbook/2/generics.html#generic-constraints)
- [Условные типы](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Дистрибутивные условные типы](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#distributive-conditional-types)
- [Индексные типы](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)
