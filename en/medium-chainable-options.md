---
id: 12
title: Chainable Options
lang: en
level: medium
tags: application
---

## Challenge

Chainable options are commonly used in JavaScript.
But when we switch to TypeScript, can you properly type it?

In this challenge, you need to type an object or a class - whatever you like - to provide two functions `option(key, value)` and `get()`.
In `option(key, value)`, you can extend the current config type by the given key and value.
We should about to access the final result via `get()`.

For example:

```ts
declare const config: Chainable

const result = config
  .option('foo', 123)
  .option('name', 'type-challenges')
  .option('bar', { value: 'Hello World' })
  .get()

// expect the type of result to be:
interface Result {
  foo: number
  name: string
  bar: {
    value: string
  }
}
```

You don't need to write any JS/TS logic to handle the problem - just in type level.

You can assume that `key` only accept `string` and the `value` can be anything - just leave it as-is.
Same `key` won't be passed twice.

## Solution

That’s a really interesting challenge with a practical usage in a real world.
Personally, I’ve used it a lot when implementing different Builder patterns.

What does author ask us to do?
We need to implement two methods `option(key, value)` and `get()`.
Every next call of the `option(key, value)` must accumulate type information about `key` and `value` somewhere.
Accumulation must proceed until the method `get()` was called that returns an accumulated type information as an object type.

Let us start with the interface author provides to us:

```ts
type Chainable = {
  option(key: string, value: any): any
  get(): any
}
```

Before we can start accumulating the type information, it would be great to get it first.
So we replace `string` in `key` and `any` in `value` parameters with type parameters, so TypeScript could infer their types and assign it to type parameters:

```ts
type Chainable = {
  option<K, V>(key: K, value: V): any
  get(): any
}
```

Good!
We have a type information about `key` and `value` now.
TypeScript will infer the `key` as a string literal type, while the `value` as the common type.
E.g. calling `option(‘foo’, 123)` will result into having types for `key = ‘foo’` and `value = number`.

We have the information, but where can we store it?
It must be the place that persists its state across different method calls.
The only place here is on the type `Chainable` itself!

Let us add a new type parameter `O` to the `Chainable` type and do not forget that it is by default an empty object:

```ts
type Chainable<O = {}> = {
  option<K, V>(key: K, value: V): any
  get(): any
}
```

The most interesting part now, pay attention!
We want `option(key, value)` to return `Chainable` type itself (we want to have a possibility to chain the calls, right) but with the type information accumulated to its type parameter.
Let us use [intersection types](https://www.typescriptlang.org/docs/handbook/unions-and-intersections.html#intersection-types) to add new types into accumulator:

```ts
type Chainable<O = {}> = {
  option<K, V>(key: K, value: V): Chainable<O & { [P in K]: V }>
  get(): any
}
```

Small things left.
We are getting the compilation error “Type ‘K’ is not assignable to type ‘string | number | symbol’.“.
That’s because we don’t have a constraint over type parameter `K` that says it must be a `string`:

```ts
type Chainable<O = {}> = {
  option<K extends string, V>(key: K, value: V): Chainable<O & { [P in K]: V }>
  get(): any
}
```

Everything is ready to rock!
Now, when the developer will call the `get()` method, it must return the type parameter `O` from `Chainable` that has an accumulated type information from previous `option(key, value)` calls:

```ts
type Chainable<O = {}> = {
  option<K extends string, V>(key: K, value: V): Chainable<O & { [P in K]: V }>
  get(): O
}
```

## References

- [Intersection Types](https://www.typescriptlang.org/docs/handbook/unions-and-intersections.html#intersection-types)
- [Mapped Types](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
- [Generics](https://www.typescriptlang.org/docs/handbook/generics.html)
