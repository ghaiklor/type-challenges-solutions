---
id: 3188
title: Tuple to Nested Object
lang: en
level: medium
tags: array
---

## Challenge

Given a tuple type `T` that only contains string type, and a type `U`, build an
object recursively.

```ts
type a = TupleToNestedObject<["a"], string>; // {a: string}
type b = TupleToNestedObject<["a", "b"], number>; // {a: {b: number}}
type c = TupleToNestedObject<[], boolean>; // boolean. if the tuple is empty, just return the U type
```

## Solution

Let's begin by iterating over the tuple by inferring its content.

```ts
type TupleToNestedObject<T, U> = T extends [infer F, ...infer R]
  ? never
  : never;
```

What if the `T` is empty? In that case, we return the type `U` as it is.

```ts
type TupleToNestedObject<T, U> = T extends [infer F, ...infer R] ? never : U;
```

Since keys for an `object` can only be of the type `string`, we have to check
whether `F` is a string.

```ts
type TupleToNestedObject<T, U> = T extends [infer F, ...infer R]
  ? F extends string
    ? never
    : never
  : U;
```

If `F` is a typeof `string`, we would want to create an `object` and recursively
traverse the remaining tuple. This way we iterate over the entire tuple and
create nested objects until we reach the last entry of the tuple at which point
we simply return `U` as its type.

```ts
type TupleToNestedObject<T, U> = T extends [infer F, ...infer R]
  ? F extends string
    ? { [P in F]: TupleToNestedObject<R, U> }
    : never
  : U;
```

## References

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Inferring within Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Recursive Conditional Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
