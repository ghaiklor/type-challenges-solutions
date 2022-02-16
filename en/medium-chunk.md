---
id: 4499
title: Chunk
lang: en
level: medium
tags: tuple
---

## Challenge

Do you know `lodash`?
`Chunk` is a very useful function in it, now let's implement it.
`Chunk<T, N>` accepts two required type parameters, the `T` must be a `tuple`, and the `N` must be an `integer >=1`.
For instance:

```typescript
type R0 = Chunk<[1, 2, 3], 2> // expected to be [[1, 2], [3]]
type R1 = Chunk<[1, 2, 3], 4> // expected to be [[1, 2, 3]]
type R2 = Chunk<[1, 2, 3], 1> // expected to be [[1], [2], [3]]
```

## Solution

This challenge was a hard nut.
But in the end, I came up with a solution that is easy to understand, IMHO.
We start with an initial type that declares the contract:

```typescript
type Chunk<T, N> = any
```

Since we need to accumulate chunks of the tuple, it seems reasonable to have an optional type parameter `A` that accumulates the chunk of size `N`.
By default, the type parameter `A` will be an empty tuple:

```typescript
type Chunk<T, N, A extends unknown[] = []> = any
```

Having an empty accumulator that we will use for a temporary chunk, we can start splitting the `T` into parts.
The parts are the first element of the tuple and the rest of it:

```typescript
type Chunk<T, N, A extends unknown[] = []> = T extends [infer H, ...infer T]
  ? never
  : never
```

Having parts of the tuple `T`, we can check if our accumulator has a required size.
To achieve that, we lookup the `length` property on its type.
It works, because we have a generic constraint over the type parameter `A` that says it is a tuple.

```typescript
type Chunk<T, N, A extends unknown[] = []> = T extends [infer H, ...infer T]
  ? A['length'] extends N
  ? never
  : never
  : never
```

In case our accumulator is empty or has not enough items in it, we need to continue slicing the `T` until the accumulator has the required size.
To do that, we continue calling `Chunk` type recursively with a new accumulator.
In this accumulator, we push the previous one from `A` and the item `H` from the `T`:

```typescript
type Chunk<T, N, A extends unknown[] = []> = T extends [infer H, ...infer T]
  ? A['length'] extends N
  ? never
  : Chunk<T, N, [...A, H]>
  : never
```

The recursive call continues until we got a case when the accumulator size has the required `N`.
This is exactly the case when our accumulator `A` has all the elements in it with proper size.
It is our first chunk that we need to store in the result.
So we return a new tuple with accumulator in it:

```typescript
type Chunk<T, N, A extends unknown[] = []> = T extends [infer H, ...infer T]
  ? A['length'] extends N
  ? [A]
  : Chunk<T, N, [...A, H]>
  : never
```

Doing so, we ignore the rest of the tuple `T`.
So we need to add another recursive call to our result `[A]` that will clear the accumulator and start again the same process:

```typescript
type Chunk<T, N, A extends unknown[] = []> = T extends [infer H, ...infer T]
  ? A['length'] extends N
  ? [A, Chunk<T, N>]
  : Chunk<T, N, [...A, H]>
  : never
```

This recursive magic continues until we get the case when there are no more elements in tuple `T`.
In such scenario, we just return whatever is left in our accumulator.
The reasoning for this is that we can have a case when the size of accumulator is less than `N`.
So not returning the accumulator in such case means losing the items.

```typescript
type Chunk<T, N, A extends unknown[] = []> = T extends [infer H, ...infer T]
  ? A['length'] extends N
  ? [A, Chunk<T, N>]
  : Chunk<T, N, [...A, H]>
  : [A]
```

There is also another case when we lose the element of `H`.
It is the case when we got the accumulator of needed size, but ignore the inferred `H`.
Our chunks lose some elements and this is not ok.
To fix that, we need to not forget about `H` element when having an accumulator of size `N`:

```typescript
type Chunk<T, N, A extends unknown[] = []> = T extends [infer H, ...infer T]
  ? A['length'] extends N
  ? [A, Chunk<[H, ...T], N>]
  : Chunk<T, N, [...A, H]>
  : [A]
```

The solution solves some cases, which is great.
However, we have a case when the recursive call to the `Chunk` type returns the tuples in the tuple in the tuple (because of recursive calls).
To overcome that, let’s add a spread to our `Chunk<[H, ...T], N>`:

```typescript
type Chunk<T, N, A extends unknown[] = []> = T extends [infer H, ...infer T]
  ? A['length'] extends N
  ? [A, ...Chunk<[H, ...T], N>]
  : Chunk<T, N, [...A, H]>
  : [A]
```

All the test cases are passed!
Hooray... except the edge case with an empty tuple.
This one is just an edge case and we can add the conditional type to check it.
If the accumulator turns out to be empty in the basic case, we return an empty tuple.
Otherwise, we return the accumulator itself as before:

```typescript
type Chunk<T, N, A extends unknown[] = []> = T extends [infer H, ...infer T]
  ? A['length'] extends N
  ? [A, ...Chunk<[H, ...T], N>]
  : Chunk<T, N, [...A, H]>
  : A[number] extends never ? [] : [A]
```

That’s all we need to implement a lodash version of `.chunk()` function in the type system!

## References

- [Generics](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Generic Constraints](https://www.typescriptlang.org/docs/handbook/2/generics.html#generic-constraints)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Inferring within Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Variadic Tuple Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
- [Indexed Access Types](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)
