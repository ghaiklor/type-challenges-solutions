---
id: 27958
title: CheckRepeatedTuple
lang: en
level: medium
tags: array
---

## Challenge

Implement type `CheckRepeatedChars<T>` which will return whether type `T`
contains a duplicated member.

```ts
type CheckRepeatedTuple<[1, 2, 3]> // false
type CheckRepeatedTuple<[1, 2, 1]> // true
```

## Solution

The idea behind this challenge is to check if the tuple contains repeated
elements or not. We have to take every single element out of it and check if it
is repeated.

It can be done by inferring the first element and checking if it exists in the
rest of the tuple. So we will infer the first element, `F` and check if it
exists in the rest of the tuple by checking if the element extends the
`Rest[number]` union.

```ts
type CheckRepeatedTuple<T extends unknown[]> = T extends [
  infer F,
  ...infer Rest,
]
  ? F extends Rest[number]
    ? true
    : false
  : false;
```

If the first element `F` exists in the `Rest[number]` that means the item is
repeated, so we return `true`. Otherwise, if it does not exist, we will call the
`CheckRepeatedTuple` again with the rest of the tuple `Rest` in a recursive way
so it will repeat the process of inferring the first element of the passing
tuple again.

```ts
type CheckRepeatedTuple<T extends unknown[]> = T extends [
  infer F,
  ...infer Rest,
]
  ? F extends Rest[number]
    ? true
    : CheckRepeatedTuple<Rest>
  : false;
```

## References

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Inferring within Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Recursive Conditional Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
