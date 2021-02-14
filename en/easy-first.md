---
title: First of Array
lang: en
level: easy
tags: array
challenge_url: https://tsch.js.org/14
---

## Challenge

Implement a generic `First<T>` that takes an Array `T` and returns it's first element's type.

For example:

```ts
type arr1 = ['a', 'b', 'c']
type arr2 = [3, 2, 1]

type head1 = First<arr1> // expected to be 'a'
type head2 = First<arr2> // expected to be 3
```

## Solution

The first thing that could come up is to use lookup types and just write `T[0]`:

```ts
type First<T extends any[]> = T[0]
```

But there is an edge case that we need to handle.
If we pass an empty array, `T[0]` will not work, because there is no element.

So that, before accessing the first element in the array, we need to check if the array is empty.
To do that, we can use [conditional types](https://www.typescriptlang.org/docs/handbook/advanced-types.html#conditional-types) in TypeScript.

The idea behind them is pretty straightforward.
If we can assign the type to the type of condition, it will go into “true” branch, otherwise it will take “false” path.

We are going to check, if the array is empty, we return nothing, otherwise we return the first element of the array:

```ts
type First<T extends any[]> = T extends [] ? never : T[0];
```

## References

- [Indexed Types](https://www.typescriptlang.org/docs/handbook/advanced-types.html#index-types)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/advanced-types.html#conditional-types)
