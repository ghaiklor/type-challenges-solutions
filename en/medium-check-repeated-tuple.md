---
id: 27958
title: CheckRepeatedTuple
lang: en
level: medium
tags: array
---

## Challenge

Implement type `CheckRepeatedChars<T>` which will return whether type `T` contains a duplicated member

```ts
  type CheckRepeatedTuple<[1, 2, 3]>   // false
  type CheckRepeatedTuple<[1, 2, 1]>   // true
```

## Solution

Let's begin by iterating over the tuple by inferring its content. after that, we need to check if `F` extends the union of the rest of the array
if yes so the `F` is repeated if not so we call `CheckRepeatedTuple` recursively with the `R`.

```ts
type CheckRepeatedTuple<T extends unknown[]> = T extends [
  infer F,
  ...infer Rest
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
