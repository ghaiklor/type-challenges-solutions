---
id: 16
title: Pop
lang: en
level: medium
tags: array
---

## Challenge

Implement a generic `Pop<T>` that takes an Array `T` and returns an Array without it's last element.

For example:

```ts
type arr1 = ['a', 'b', 'c', 'd']
type arr2 = [3, 2, 1]

type re1 = Pop<arr1> // expected to be ['a', 'b', 'c']
type re2 = Pop<arr2> // expected to be [3, 2]
```

## Solution

We need to split the array into two parts: everything from the head until the last element and the last element itself.
Afterwards, we can get rid of the last element and return the other part.

To achieve that, we can use [variadic tuple types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types).
By combining them with [type inference in conditional types](https://www.typescriptlang.org/docs/handbook/advanced-types.html#type-inference-in-conditional-types), we can infer the needed parts:

```ts
type Pop<T extends any[]> = T extends [...infer H, infer T] ? H : never;
```

In case `T` is assignable to the type of array that can be split in two parts, we return everything except the last one, otherwise - `never`.

## References

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/advanced-types.html#conditional-types)
- [Type inference in conditional types](https://www.typescriptlang.org/docs/handbook/advanced-types.html#type-inference-in-conditional-types)
- [Variadic Tuple Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
