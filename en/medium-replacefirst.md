---
id: 25170
title: ReplaceFirst
lang: en
level: medium
tags: infer array
---

## Challenge

Implement the type ```ReplaceFirst<T, S, R>``` which will replace the first occurrence of ```S``` in a tuple ```T``` with  ```R```. If no such ```S``` exists in ```T```, the result should be ```T```.

For example:

```typescript
type replaced = ReplaceFirst<["A", "B", "C"], "C", "D">;
// expected to be ['A', 'B', 'D']
```

## Solution

Interesting challenge here, Let me explain it step by step.

We start with splitting the ```T``` to infer the first Item in the list and infer the Rest then check if it ```extends``` what we want to replace which is ```S```. If we found the element that we are searching for at the beginning of the list we will call it ```First``` and return ```[First, ...Rest]```.

```typescript
type ReplaceFirst<T extends readonly unknown[], S, R> =
  T extends [infer FI, ...infer Rest] ?
     FI extends S ? [R, ...Rest] : T
```

This solution will replace the first match, but what if the element that we are searching for is in the middle or the end, so we will need to loop recursively through every element, so when the element is not found at the beginning will go to the other direction to the recursive call and pass to `ReplaceFirst` the `Rest, S, R` to check every element till find the matched one.

```typescript
type ReplaceFirst<T extends readonly unknown[], S, R> = T extends [
  infer FI,
  ...infer Rest
]
  ? FI extends S
    ? [R, ...Rest]
    : [FI, ...ReplaceFirst<Rest, S, R>]
  : T;
```

## References

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Type inference in conditional types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Recursive Conditional Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
