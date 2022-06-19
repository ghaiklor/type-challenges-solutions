---
id: 5360
title: Unique
lang: en
level: medium
tags: array
---

## Challenge

Implement the type version of `Lodash.uniq()`.
`Unique<T>` takes an array `T`, returns the array `T` without repeated values.

```typescript
type Res = Unique<[1, 1, 2, 2, 3, 3]>; // expected to be [1, 2, 3]
type Res1 = Unique<[1, 2, 3, 4, 4, 5, 6, 7]>; // expected to be [1, 2, 3, 4, 5, 6, 7]
type Res2 = Unique<[1, "a", 2, "b", 2, "a"]>; // expected to be [1, "a", 2, "b"]
```

## Solution

In this challenge, we need to implement a lodash version of a `.uniq()` function in the type system.
Our type must accept a single type parameter that is a tuple of elements.
We need to filter out the duplicates from there and leave only a unique set of elements.

I’ll start with the initial type:

```typescript
type Unique<T> = any;
```

In order to check if the element is unique in the tuple, first, we need to get it.
To do that, we will use inferring within conditional types.

However, we will do it in the reverse order.
Pay attention to the order of unique elements in the expected result.
If we do it as `[infer H, ...infer T]`, our ending result will not be in the correct order.
So that, I’m using the last element of the tuple as an item and the rest of the tuple goes into head:

```typescript
type Unique<T> = T extends [...infer H, infer T] ? never : never;
```

Now, having the element in type parameter `T`, what should we check?
We should check if the element `T` is present in other part of the tuple - in its head:

```typescript
type Unique<T> = T extends [...infer H, infer T]
  ? T extends H[number]
    ? never
    : never
  : never;
```

By having a conditional type `T extends H[number]` we can check if the type `T` is present in union of elements of `H`.
If so, it means that `T` is the duplicate and we need to skip it.
Meaning, we just return whatever is left in the head:

```typescript
type Unique<T> = T extends [...infer H, infer T]
  ? T extends H[number]
    ? [...Unique<H>]
    : never
  : never;
```

But if it’s not present in the head - it is a unique element!
We include the `T` in the tuple in this case:

```typescript
type Unique<T> = T extends [...infer H, infer T]
  ? T extends H[number]
    ? [...Unique<H>]
    : [...Unique<H>, T]
  : never;
```

The last case is when the input type parameter `T` does not match the tuple.
Here, we just return an empty tuple to not break the spread in recursive call:

```typescript
type Unique<T> = T extends [...infer H, infer T]
  ? T extends H[number]
    ? [...Unique<H>]
    : [...Unique<H>, T]
  : [];
```

That way, we have implemented a type that can return a tuple with unique elements in it.

## References

- [Generics](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Inferring within Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Recursive Conditional Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
