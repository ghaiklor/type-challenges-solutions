---
id: 2793
title: Mutable
lang: ru
level: medium
tags: readonly object-keys
---

## Проблема

Реализовать общий тип `Mutable<T>`, который сделает все свойства объекта изменяемыми.
Например:

```typescript
interface Todo {
  readonly title: string
  readonly description: string
  readonly completed: boolean
}

// { title: string; description: string; completed: boolean; }
type MutableTodo = Mutable<T>
```

## Решение

И снова, проблема, которую сложно назвать проблемой со средним уровнем сложности.
Я её решил без долгих раздумий и с первого раза.
Но, как бы там ни было, мы всё равно решаем их все, поэтому зачем думать об этом.

Мы знаем, что у нас на входе тип со свойствами, к которым применяется модификатор `readonly`.
Это те же модификаторы, которые мы использовали для решения других задач, например [Readonly](./easy-readonly.md).
Однако, в этом случае, нас попросили убрать этот модификатор из входного типа.

Давайте начнём с самого простого.
Скопируем входной тип без каких-либо изменений:

```typescript
type Mutable<T> = { [P in keyof T]: T[P] }
```

Теперь у нас есть копия `T` с модификаторами `readonly`.
Как же нам от них избавиться?
Помните, что мы использовали ключевое слово `readonly`, чтобы добавлять их к свойствам?

```typescript
type Mutable<T> = { readonly [P in keyof T]: T[P] }
```

Неявно, TypeScript добавляет к этим ключевым словам `+`.
То есть, применяет модификатор `readonly` на свойстве.
Но, в нашем случае, мы хотим его отменить, поэтому используем `-`:

```typescript
type Mutable<T> = { -readonly [P in keyof T]: T[P] }
```

Таким образом, мы реализовали тип, который отменяет модификатор `readonly` на входном типе.

## Что почитать

- [Сопоставляющие типы](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
- [Модификаторы на сопоставляющих типах](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html#mapping-modifiers)
