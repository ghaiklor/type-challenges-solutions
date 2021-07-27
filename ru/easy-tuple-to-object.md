---
id: 11
title: Tuple to Object
lang: ru
level: easy
tags: tuple
---

## Проблема

Имея кортеж на входе, трансформируйте его в объект, ключи и значения которого будут элементами из кортежа.
Например:

```typescript
const tuple = ['tesla', 'model 3', 'model X', 'model Y'] as const

// expected { tesla: 'tesla', 'model 3': 'model 3', 'model X': 'model X', 'model Y': 'model Y'}
const result: TupleToObject<typeof tuple>
```

## Решение

Нужно взять элементы из кортежа, перечислить их, и каждый элемент сделать ключом и значением в новом объекте.

Это легко реализуется с использованием индексных типов.
Мы можем получить все элементы из кортежа в объединение, используя конструкцию `T[number]`.

А уже при помощи сопоставляющих типов, создать новый объект, ключами и значениями которого будут элементы нашего объединения `T[number]`.

```typescript
type TupleToObject<T extends readonly any[]> = { [K in T[number]]: K }
```

## Что почитать

- [Сопоставляющие типы](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
- [Индексные типы](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)
