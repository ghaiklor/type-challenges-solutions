---
id: 8
title: Readonly 2
lang: ru
level: medium
tags: readonly object-keys
---

## Проблема

Реализовать тип `MyReadonly2<T, K>`.
Тип параметр `K` содержит список свойств `T`, которые должны быть указаны как `readonly`.
В случае, если `K` не передали в аргументах, все свойства `T` должны быть `readonly`.
Например:

```typescript
interface Todo {
  title: string
  description: string
  completed: boolean
}

const todo: MyReadonly2<Todo, 'title' | 'description'> = {
  title: "Hey",
  description: "foobar",
  completed: false,
}

todo.title = "Hello" // Error: cannot reassign a readonly property
todo.description = "barFoo" // Error: cannot reassign a readonly property
todo.completed = true // OK
```

## Решение

Эту проблему можно считать продолжением [`Readonly<T>`](./easy-readonly.md).
Всё то же, кроме того, что теперь у нас появляется новый тип параметр `K`, через который указываем, какие свойства сделать неизменяемыми.

Начнём со случая, когда `K` это пустое объединение, то есть, ничего не должно быть неизменяемым.
Всё просто - возвращаем `T` без изменений.

```typescript
type MyReadonly2<T, K> = T;
```

Теперь, обработаем случай, когда у нас указаны свойства в `K`.
Используем типы пересечений и добавим к нашему `T` новый объект.
В этом объекте, используя сопоставляющие типы, перечислим свойства из `K` и добавим к ним модификатор `readonly`.

```typescript
type MyReadonly2<T, K> = T & { readonly [P in K]: T[P] };
```

Выглядит как решение, но получаем ошибку “Type ‘P’ cannot be used to index type ‘T’”.
И это правда, у нас нет ограничений на `K`.
Ограничим его до "ключи из `T`".

```typescript
type MyReadonly2<T, K extends keyof T> = T & { readonly [P in K]: T[P] };
```

А теперь работает?
Нет!
Мы забыли о случае, когда `K` не передан вовсе, как аргумент.
Это тот случай, когда `MyReadonly2` ведёт себя как встроенный `Readonly<T>`.
Добавим к `K` тип параметр по умолчанию "все ключи из `T`".

```typescript
type MyReadonly2<T, K extends keyof T = keyof T> = T & { readonly [P in K]: T[P] };
```

## Что почитать

- [Типы пересечений](https://www.typescriptlang.org/docs/handbook/2/objects.html#intersection-types)
- [Сопоставляющие типы](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
- [Индексные типы](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)
- [Ограничения на тип параметрах](https://www.typescriptlang.org/docs/handbook/2/generics.html#using-type-parameters-in-generic-constraints)
