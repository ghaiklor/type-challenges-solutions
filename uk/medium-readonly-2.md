---
id: 8
title: Readonly 2
lang: uk
level: medium
tags: readonly object-keys
---

## Завдання

Реалізувати дженерик `MyReadonly2<T, K>`, що приймає два типи-аргументи `T` та `K`.

Тип `K` визначає множину властивостей з `T`, які мають стати `readonly`.
Якщо `K` немає, він має зробити `readonly` всі властивості, як звичайний `Readonly<T>`.
Наприклад:

```ts
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

## Розв'язок

Це завдання є продовженням завдання [`Readonly<T>`](./easy-readonly.md).
Все майже таке ж, тільки треба додати новий тип-параметр `K`, щоб ми могли вказати, які конкретно властивості мають стати `readonly`.

Почнемо з найпростішого рішення. Розглянемо випадок, коли `K` є порожньою множиною, тож нам не потрібно робити щось `readonly`.
Просто повертаємо `T`:

```ts
type MyReadonly2<T, K> = T;
```

Тепер потрібно врахувати випадок, коли `K` містить якісь властивості.
Ми можемо використати оператор `&` і створити [перетин двох типів](https://www.typescriptlang.org/docs/handbook/unions-and-intersections.html#intersection-types): першим є наш тип `T`, а другим є множина властивостей, які треба зробити `readonly`:

```ts
type MyReadonly2<T, K> = T & { readonly [P in K]: T[P] };
```

Виглядає правдоподібно, та ми отримаємо помилку компіляції “Type ‘P’ cannot be used to index type ‘T’”.
І це дійсно так, ми не встановили обмежень для `K`.
Це має бути “кожен ключ з `T`”:

```ts
type MyReadonly2<T, K extends keyof T> = T & { readonly [P in K]: T[P] };
```

Працює?
Ні!
Ми не врахували випадок, коли `K` зовсім немає.
Це той самий випадок, коли наш тип має поводитись так само як `Readonly<T>`.
Щоб це виправити, ми просто вкажемо, що за замовчуванням `K`, це “всі ключі з `T`”:

```ts
type MyReadonly2<T, K extends keyof T = keyof T> = T & { readonly [P in K]: T[P] };
```

## Посилання

- [Типи перетину](https://www.typescriptlang.org/docs/handbook/unions-and-intersections.html#intersection-types)
- [Типи співставлення](https://www.typescriptlang.org/docs/handbook/advanced-types.html#mapped-types)
- [Типи пошуку/індексні типи](https://www.typescriptlang.org/docs/handbook/advanced-types.html#index-types)
- [Використання типів-параметрів в обмеженнях дженериків](https://www.typescriptlang.org/docs/handbook/generics.html#using-type-parameters-in-generic-constraints)
