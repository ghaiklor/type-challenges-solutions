---
id: 4
title: Pick
lang: en
level: easy
tags: union built-in
---

## Challenge

Implement the built-in `Pick<T, K>` generic without using it.

Constructs a type by picking the set of properties `K` from `T`.

For example:

```ts
interface Todo {
  title: string
  description: string
  completed: boolean
}

type TodoPreview = MyPick<Todo, 'title' | 'completed'>

const todo: TodoPreview = {
  title: 'Clean room',
  completed: false,
}
```

## Solution

For this challenge to solve, we need to use Lookup Types and Mapped Types.

Lookup Types allow for us to extract a type from another type by its name.
Kind of getting a value from an object by using its key.

Mapped Types allow for us to transform each property in a type into a new type.

You can read more about them and understand what they are doing on TypeScript website: [lookup types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-1.html#keyof-and-lookup-types) and [mapped types](https://www.typescriptlang.org/docs/handbook/advanced-types.html#mapped-types).

Now, knowing that there are lookup types and mapped types in TypeScript.
How to implement the required type?

We need to take everything from the union `K`, iterate over it, and return a new type that will consist only of those keys.
Exactly what mapped types are doing.

The type of values itself are going to be without change.
Although, we need to take its type from the original type and that is where lookup type is useful:

```ts
type MyPick<T, K extends keyof T> = { [P in K]: T[P] }
```

We are saying “get everything from `K`, name it as `P` and make it as a new key in our new object with a value type taken from the input type”.
It's hard to grasp at first, so if you didn’t understand something, try to read the info again and wrap it in your head step by step.

## References

- [Lookup Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-1.html#keyof-and-lookup-types)
- [Mapped Types](https://www.typescriptlang.org/docs/handbook/advanced-types.html#mapped-types)
- [Indexed Types](https://www.typescriptlang.org/docs/handbook/advanced-types.html#index-types)
