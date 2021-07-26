---
id: 18
title: Length of Tuple
lang: ru
level: easy
tags: tuple
---

## Проблема

Реализовать тип `Length`, который принимает кортеж и возвращает длину этого кортежа.
Например:

```typescript
type tesla = ['tesla', 'model 3', 'model X', 'model Y']
type spaceX = ['FALCON 9', 'FALCON HEAVY', 'DRAGON', 'STARSHIP', 'HUMAN SPACEFLIGHT']

type teslaLength = Length<tesla> // expected 4
type spaceXLength = Length<spaceX> // expected 5
```

## Решение

В этом случае, элементы кортежа предопределены, поэтому мы можем использовать свойство `length`, чтобы получить количество элементов в нём.

```typescript
type Length<T extends any> = T['length']
```

Но обращаясь к свойству `length` напрямую, мы получим ошибку компиляции “Type 'length' cannot be used to index type 'T'.”
Причина этой ошибки в том, что мы пытаемся взять свойство `length` из типа, который может быть чем угодно и не иметь этого свойства.

Чтобы решить эту проблему и помочь компилятору, нам нужно указать ограничения над `T`, а именно, указать что у типа `T` есть свойство `length`.

```typescript
type Length<T extends { length: number }> = T['length']
```

## Что почитать

- [Индексные типы](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)
