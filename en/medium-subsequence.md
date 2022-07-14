---
id: 8987
title: Subsequence
lang: en
level: medium
tags: union
---

## Challenge

Given an array of unique elements, return all possible subsequences.

A subsequence is a sequence that can be derived from an array by deleting some
or no elements without changing the order of the remaining elements. For
example:

```typescript
type A = Subsequence<[1, 2]>; // [] | [1] | [2] | [1, 2]
```

## Solution

This one was a challenging one, indeed. When solving it, I remembered another
one challenge, pretty similar to this one –
[Permutation](./medium-permutation.md). There we were using recursion with
variadic tuple types to make the slices of a tuple. But, let's stick to the
challenge and solve it step by step.

As usual, I'll start with the blank type we need to implement:

```typescript
type Subsequence<T extends any[]> = any;
```

It seems like the challenge is pretty big, so I offer to split it into smaller
tasks first. By going the “divide and conquer” way, it will be easier to
implement the type.

Assume, we have a tuple with one element inside. To infer its value, we can use
a conditional type:

```typescript
type Subsequence<T extends any[]> = T extends [infer I] ? never : never;
```

When a type parameter `T` will have a tuple with a single element, it will be
inferred into type parameter `I`. That way, we get the element from the tuple,
and we can return it:

```typescript
type Subsequence<T extends any[]> = T extends [infer I] ? I : never;
```

But when there are no elements in a tuple, we can return an empty tuple:

```typescript
type Subsequence<T extends any[]> = T extends [infer I] ? I : [];
```

With this type, we can handle tuples with no elements or a single element
inside. However, once we add another element to the input tuple, things gets
harder. Our conditional type will not handle more than one element, so let's
infer the rest of the tuple into type parameter `R`:

```typescript
type Subsequence<T extends any[]> = T extends [infer I, ...infer R] ? I : [];
```

At this point, we split the input tuple into a single element in type parameter
`I` and the rest of the tuple in type parameter `R`.

According to the challenge spec, we need to return subsequences in the tuples.
So that, we wrap the return type `I` into a tuple:

```typescript
type Subsequence<T extends any[]> = T extends [infer I, ...infer R] ? [I] : [];
```

Without recursion, we have a single subsequence, but we need to include other
subsequences from the rest of the tuple as well. To do so, we call the same type
recursively but for the rest of the tuple, without element in `I`:

```typescript
type Subsequence<T extends any[]> = T extends [infer I, ...infer R]
  ? [I, ...Subsequence<R>]
  : [];
```

What's left is to add other sequences as part of the union type, so we actually
get all the possibilities:

```typescript
type Subsequence<T extends any[]> = T extends [infer I, ...infer R]
  ? [I, ...Subsequence<R>] | Subsequence<R>
  : [];
```

Let's summarize what we have here by cases:

- When `T` is an empty tuple, our conditional type will not work, resulting into
  empty tuple return.
- When `T` is a tuple with single element, our conditional type will match.
  However, the single element will be inferred into `I` type parameter, while
  `R` will be an empty tuple. Calling the type recursively with the empty tuple
  will return an empty tuple, as discussed in the previous point.
- When `T` has more than one element, what it does, is, basically, splits the
  tuple into sub-tuples and passes them recursively until two basic cases above
  happens. The result will be stacked together within union type.

That way, we have implemented a type to get the sub-sequences of a tuple.

## References

- [Generics](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Generic Constraints](https://www.typescriptlang.org/docs/handbook/2/generics.html#generic-constraints)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Inferring within Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Variadic Tuple Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
- [Union Types](https://www.typescriptlang.org/docs/handbook/2/everyday-types.html#union-types)
