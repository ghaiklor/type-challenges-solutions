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

Let's begin by iterating over the tuple by inferring its content. after that, we need to check if `F` is repeated in the rest of the array so we check that by extending the union of the `Rest`.

```ts
type CheckRepeatedTuple<T extends unknown[]> = T extends [
  infer F,
  ...infer Rest
]
  ? F extends Rest[number]
    ? true
    : false
  : false;
```

For this case if the first item exists in the remaining items of the array so return true otherwise we need to check every other item so we will use [Recursive Conditional](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types) we pass the `Rest` to the `CheckRepeatedTuple`
it will infer the first element of the passing array again and check if it exists in the remaining items.

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

It will be like this:

```T => [1, 2, 3 ]``` then infer ```F``` it will be equal to 1 then the ```Rest = [2 ,3]```
so when  ```F``` extends the union of the Rest ```Rest[number]``` as you know we get the union of the array by ```array[number]``` it will cause false so check the other path ```CheckRepeatedTuple<[2, 3]>``` and so on.

## References

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Inferring within Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Recursive Conditional Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
