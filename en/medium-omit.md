---
id: 3
title: Omit
lang: en
level: medium
tags: union built-in
---

## Challenge

Implement the built-in `Omit<T, K>` generic without using it.

> Constructs a type by picking all properties from `T` and then removing `K`.

For example:

```ts
interface Todo {
  title: string
  description: string
  completed: boolean
}

type TodoPreview = MyOmit<Todo, 'description' | 'title'>

const todo: TodoPreview = {
  completed: false,
}
```

## Solution

We need to return a new object type here, but without specified keys.
Obviously, it is a hint that we need to use [mapped types](https://www.typescriptlang.org/docs/handbook/advanced-types.html#mapped-types) here.
We need to map each property in object and construct a new type.

Let us start with the basic block and construct the same object:

```ts
type MyOmit<T, K> = { [P in keyof T]: T[P] }
```

Here, we iterate over all the keys in `T`, map it to the type `P` and make it a key in our new object type, while value type is the type from `T[P]`.

That way, we iterate over all the keys, but we need to filter out those that we are not interested in.
To achieve that, we can [remap the key type using “as” syntax](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#key-remapping-in-mapped-types):

```ts
type MyOmit<T, K> = { [P in keyof T as P extends K ? never : P]: T[P] }
```

We map all the properties from `T` and if the property is in `K` union, we return “never” type as its key, otherwise the key itself.
That way, we filter out the properties and got the required object type.

## References

- [Mapped Types](https://www.typescriptlang.org/docs/handbook/advanced-types.html#mapped-types)
- [Index Types](https://www.typescriptlang.org/docs/handbook/advanced-types.html#index-types)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/advanced-types.html#conditional-types)
- [Key remapping in mapped types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#key-remapping-in-mapped-types)
