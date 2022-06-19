---
id: 3196
title: Flip Arguments
lang: en
level: medium
tags: array
---

## Challenge

Implement the type version of lodash's `_.flip`.

Type `FlipArguments<T>` requires a function type `T` and returns a new function type which has the same return type of `T` but reversed parameters.

For example:

```ts
type Flipped = FlipArguments<
  (arg0: string, arg1: number, arg2: boolean) => void
>;
// (arg0: boolean, arg1: number, arg2: string) => void
```

## Solution

The solution for this challenge is very straightforward. Check if the type `T` is a function type and if it is then reverse its arguments.

```ts
type FlipArguments<T> = T extends (...args: [...infer P]) => infer R
  ? never
  : never;
```

Having captured the function arguments in `P` and its return type in `R`, let's reverse the arguments and return the same from our expression above.

```ts
type MyReverse<T extends unknown[]> = T extends [...infer F, infer S]
  ? [S, ...MyReverse<F>]
  : [];

type FlipArguments<T> = T extends (...args: [...infer P]) => infer R
  ? (...args: MyReverse<P>) => R
  : never;
```

## References

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Type inference in conditional types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
