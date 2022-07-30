---
id: 5317
title: LastIndexOf
lang: en
level: medium
tags: array
---

## Challenge

Implement the type version of `Array.lastIndexOf`. `LastIndexOf<T, U>` takes an
Array `T`, any `U` and returns the index of the last `U` in Array `T`. For
example:

```typescript
type Res1 = LastIndexOf<[1, 2, 3, 2, 1], 2>; // 3
type Res2 = LastIndexOf<[0, 0, 0], 2>; // -1
```

## Solution

To find the last index in the tuple, we simply can start with enumerating it
from the right until the item is found. Afterwards, having a match, just get the
position of the match. Sounds pretty simple, so let's get started.

As usual, a blank type to get started with:

```typescript
type LastIndexOf<T, U> = any;
```

In the type, we have two type parameters `T` and `U`, where `T` is the tuple and
`U` is the item we are looking for. Let's start with the conditional type, where
we infer two parts of the tuple. One part is the last item (`I`) and another one
is the rest (`R`):

```typescript
type LastIndexOf<T, U> = T extends [...infer R, infer I] ? never : never;
```

Once we have the item from the right, we can check if it is equal to the item we
are looking for. To do this, there is a built-in type `Equal`:

```typescript
type LastIndexOf<T, U> = T extends [...infer R, infer I]
  ? Equal<I, U> extends true
    ? never
    : never
  : never;
```

What happens if there is a match? It means that the item is found, but what is
the index? Well, the index of the match is the same as the length of the rest to
the left, right? So we can use the length of the rest as the index:

```typescript
type LastIndexOf<T, U> = T extends [...infer R, infer I]
  ? Equal<I, U> extends true
    ? R["length"]
    : never
  : never;
```

When there is no match, we should keep trying to find the index recursively:

```typescript
type LastIndexOf<T, U> = T extends [...infer R, infer I]
  ? Equal<I, U> extends true
    ? R["length"]
    : LastIndexOf<R, U>
  : never;
```

At last, if the match hasn't been found at all, we return the `-1` as the
answer:

```typescript
type LastIndexOf<T, U> = T extends [...infer R, infer I]
  ? Equal<I, U> extends true
    ? R["length"]
    : LastIndexOf<R, U>
  : -1;
```

## References

- [Generics](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Inferring within Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Indexed Access Types](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)
- [Recursive Conditional Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
- [Variadic Tuple Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
