---
lang: en
level: medium
tags: array
---

# Flatten

![medium](https://img.shields.io/badge/-medium-d9901a)
![#array](https://img.shields.io/badge/-%23array-999)

## Challenge

In this challenge, you would need to write a type that takes an array and emitted the flatten array type.

For example:

```ts
type flatten = Flatten<[1, 2, [3, 4], [[[5]]]> // [1, 2, 3, 4, 5]
```

## Solution

The base case for the challenge here is an empty array.
When we get an empty array, we return an empty array; it is already flatten anyway.
Otherwise, `T` itself:

```typescript
type Flatten<T> = T extends [] ? [] : T
```

But, if `T` will not be an empty array, it means that we have an array with elements inside or the element itself.
What we need to do when it is an array with elements?
We need to infer one item from it and the tail.
For now, we can just return inferred items:

```typescript
type Flatten<T> = T extends [] ? [] : T extends [infer H, ...infer T] ? [H, T] : [T]
```

BTW, pay attention to the case when it is not an array with elements.
It means it is not an array at all, so we treat it as the element itself and just return it wrapped in a tuple.

Knowing our array’s head and tail, we can recursively call `Flatten` again and again and pass there these inferred items.
That way, we flatten the item until it is not an array and return the item itself `[T]`:

```typescript
type Flatten<T> = T extends [] ? [] : T extends [infer H, ...infer T] ? [...Flatten<H>, ...Flatten<T>] : [T]
```

## References

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/advanced-types.html#conditional-types)
- [Type inference in conditional types](https://www.typescriptlang.org/docs/handbook/advanced-types.html#type-inference-in-conditional-types)
- [Recursive Conditional Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
- [Variadic Tuple Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
