---
id: 7
title: Readonly
lang: ru
level: easy
tags: built-in readonly object-keys
---

## Проблема

Реализовать встроенный `Readonly<T>` не используя его.
Этот тип создает новый объект с неизменяемыми свойствами из объекта `T`.
Например:

```typescript
interface Todo {
  title: string
  description: string
}

const todo: MyReadonly<Todo> = {
  title: "Hey",
  description: "foobar"
}

todo.title = "Hello" // Error: cannot reassign a readonly property
todo.description = "barFoo" // Error: cannot reassign a readonly property
```

## Решение

Нам нужно взять все свойства из объекта `T` и сделать их неизменяемыми.
Следовательно, нам нужно их перечислить и добавить модификатор `readonly` к каждому из свойств.

Для того чтобы перечислить свойства объекта, можно использовать сопоставляющие типы.
Для каждого ключа из объекта, добавляем модификатор `readonly`, а значением берём без изменений из `T`.

```typescript
type MyReadonly<T> = { readonly [K in keyof T]: T[K] }
```

## Что почитать

- [Сопоставляющие типы](https://www.typescriptlang.org/docs/handbook/advanced-types.html#mapped-types)
