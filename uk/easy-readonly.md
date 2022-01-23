---
id: 7
title: Readonly
lang: uk
level: easy
tags: built-in readonly object-keys
---

## Завдання

Реалізуйте вбудований тип `Readonly<T>`, не використовуючи його.

Він має створювати тип з усіма властивостями `T` визначеними як `readonly`, тобто вони не можуть бути переприсвоєними.

Наприклад:

```ts
interface Todo {
  title: string;
  description: string;
}

const todo: MyReadonly<Todo> = {
  title: "Hey",
  description: "foobar",
};

todo.title = "Hello"; // Error: cannot reassign a readonly property
todo.description = "barFoo"; // Error: cannot reassign a readonly property
```

## Розв'язок

Нам потрібно зробити всі властивості у типі доступними лише для читання.
Отже, ми маємо проітерувати всі властивості та додати до них модифікатор.

Ми використаємо звичайні [типи зіставлення](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html), нічого складного.
Ми візьмемо ключ кожної властивості та додамо йому модифікатор `readonly`:

```ts
type MyReadonly<T> = { readonly [K in keyof T]: T[K] };
```

## Посилання

- [Типи зіставлення](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
