<h1>Pop <img src="https://img.shields.io/badge/-medium-eaa648" alt="medium"/> <img src="https://img.shields.io/badge/-%23array-999" alt="#array"/></h1>

## Challenge

> TypeScript 4.0 is recommended in this challenge

Implement a generic `Pop<T>` that takes an Array `T` and returns an Array without it's last element.

For example

```ts
type arr1 = ['a', 'b', 'c', 'd']
type arr2 = [3, 2, 1]

type re1 = Pop<arr1> // expected to be ['a', 'b', 'c']
type re2 = Pop<arr2> // expected to be [3, 2]
```

**Extra**: Similarly, can you implement `Shift`, `Push` and `Unshift` as well?

## Solution

We need to split the array into two parts: everything from the head until the last element and the last element itself.
Afterwards, we can get rid of the last element and return the other part.

To achieve that, we can use [variadic tuple types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types).
By combining them with [type inference in conditional types](https://www.typescriptlang.org/docs/handbook/advanced-types.html#type-inference-in-conditional-types), we can infer the needed parts:

```ts
type Pop<T extends any[]> = T extends [...infer H, infer T] ? H : never;
```

In case T is assignable to the type of array that can be split in two parts, we return everything except the last one, otherwise - never.
