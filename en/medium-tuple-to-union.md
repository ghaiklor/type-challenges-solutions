---
title: Tuple to Union
lang: en
level: medium
tags: infer tuple union
---

## Challenge

Implement a generic `TupleToUnion<T>` which covers the values of a tuple to its values union.

For example:

```ts
type Arr = ['1', '2', '3']

const a: TupleToUnion<Arr> // expected to be '1' | '2' | '3'
```

## Solution

We need to take all the elements from an array and convert it to the union.
Luckily, TypeScript already has it in its type system - [lookup types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-1.html#keyof-and-lookup-types).

We can use the construct `T[number]` to get the union of all elements of `T`:

```ts
type TupleToUnion<T> = T[number]
```

But, we will get an error “Type ‘number’ cannot be used to index type ‘T’“.
That is because we don’t have a constraint over `T` that is saying to the compiler it is an array that can be indexed.
Let us fix that by adding `extends unknown[]`:

```ts
type TupleToUnion<T extends unknown[]> = T[number]
```

## References

- [Lookup Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-1.html#keyof-and-lookup-types)
