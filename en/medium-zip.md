---
id: 4471
title: Zip
lang: en
level: medium
tags: tuple
---

## Challenge

In this challenge, you should implement a type `Zip<T, U>`, `T` and `U` must be `Tuple`:

```typescript
// expected to be [[1, true], [2, false]]
type R = Zip<[1, 2], [true, false]>
```

## Solution

Let’s start with declaring the initial type that we will use to implement the solution for the challenge.
The type parameter `T` is used to get the first tuple we need to zip and `U` is used to get the second one:

```typescript
type Zip<T, U> = any
```

Before diving into implementation, let me give you an example of what zipping means here.
For instance, if you have a tuple `[1, 2]` and a tuple `[true, false]`, you need to combine first elements of the tuple in a new tuple - `[1, true]`.
Then, once again, do the same, but to the second one - `[2, false]`.
In the end, put these tuples in another tuple - `[[1, true], [2, false]]`.
That’s what zipping means.

As you can see, we need to have an ability to get the first element of a tuple.
We can do that by using an inference!
Take the first tuple `T` and infer the item (`TI`) from there and the tail (`TT`):

```typescript
type Zip<T, U> = T extends [infer TI, ...infer TT]
  ? never
  : never;
```

But we have another tuple that we didn’t consider.
So take another tuple `U` and do the same - infer the item (`UI`) and the tail (`UT`):

```typescript
type Zip<T, U> = T extends [infer TI, ...infer TT]
  ? U extends [infer UI, ...infer UT]
  ? never
  : never
  : never;
```

If both tuples have the item and the tail - we can zip them together.
To do that, we return a tuple with `TI` and `UI`:

```typescript
type Zip<T, U> = T extends [infer TI, ...infer TT]
  ? U extends [infer UI, ...infer UT]
  ? [TI, UI]
  : never
  : never;
```

The problem here is that we don’t process other items.
We just get a single tuple and that’s it.
To overcome this, we can call `Zip` again and provide our tails to it.
Also, don’t forget that we need to have a tuple of tuples, so we are wrapping it into square brackets once more:

```typescript
type Zip<T, U> = T extends [infer TI, ...infer TT]
  ? U extends [infer UI, ...infer UT]
  ? [[TI, UI], Zip<TT, UT>]
  : never
  : never;
```

Having a recursive way of zipping the tail until it’s gone is great.
But using the `Zip` type, we get the tuple of tuples in the end.
Which goes inside our tuple of tuples and we don’t need it.
We need it unwrapped here, so we can use the variadic tuple type to unwrap the tuple when calling `Zip`:

```typescript
type Zip<T, U> = T extends [infer TI, ...infer TT]
  ? U extends [infer UI, ...infer UT]
  ? [[TI, UI], ...Zip<TT, UT>]
  : never
  : never;
```

The last question to answer is - what should we do when the tail is no more?
Well, instead of returning `never` type, we can return just an empty tuple.
So that our spread will add nothing to the tuple.

```typescript
type Zip<T, U> = T extends [infer TI, ...infer TT]
  ? U extends [infer UI, ...infer UT]
  ? [[TI, UI], ...Zip<TT, UT>]
  : []
  : [];
```

## References

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Inferring within Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Variadic Tuple Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
