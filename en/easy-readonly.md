# Readonly

![easy](https://img.shields.io/badge/-easy-7aad0c)
![#built-in](https://img.shields.io/badge/-%23built--in-999)
![#readonly](https://img.shields.io/badge/-%23readonly-999)
![#object-keys](https://img.shields.io/badge/-%23object--keys-999)

## Challenge

Implement the built-in `Readonly<T>` generic without using it.

Constructs a type with all properties of `T` set to `readonly`, meaning the properties of the constructed type cannot be reassigned.

For example:

```ts
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

## Solution

We need to make all the properties in the object read-only.
Therefore, we need to iterate over all the properties and add a modifier to them.

We are going to use the usual [Mapped Type](https://www.typescriptlang.org/docs/handbook/advanced-types.html#mapped-types) here, nothing serious.
For each property in the type, we take its key and add a `readonly` modifier to it:

```ts
type MyReadonly<T> = { readonly [K in keyof T]: T[K] }
```

## References

- [Mapped Types](https://www.typescriptlang.org/docs/handbook/advanced-types.html#mapped-types)
