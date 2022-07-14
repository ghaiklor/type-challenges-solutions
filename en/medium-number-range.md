---
id: 8640
title: Number Range
lang: en
level: medium
tags: union number
---

## Challenge

Sometimes we want to limit the range of numbers... For example:

```typescript
type result = NumberRange<2, 9>; // | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9
```

## Solution

I love challenges related to the arithmetic and hate them at the same time. They
are challenging and built on the workarounds. I love them for being challenging
and hate them for being built on workarounds.

Anyway, let's start with the numbers. We need to get a union of numbers,
specific numbers. To get the union of numbers, we simply can use the lookup
types. For instance, having a tuple with range 0-5 and using a lookup type for
`number` type we can get the union:

```typescript
type R0 = [0, 1, 2, 3, 4, 5][number];
// R0 is 0 | 1 | 2 | 3 | 4 | 5
```

Meaning, we can solve the challenge if we have a tuple with the needed numbers
inside. How to create one?

We can start by creating a tuple of specific length. Let's call the type that
creates it `Tuple`. The type will have a single type parameter `L` that we can
use to specify the length of the tuple:

```typescript
type Tuple<L extends number> = any;
```

For instance, we want to create a tuple of length 2. So our type parameter `L`
will be 2. What needs to be compared with it?

When having a tuple, we can use lookup types to get the property `length`. It
will return the length of a tuple as a number. And if the length of a tuple is
equal to type parameter `L` – we have one:

```typescript
type Tuple<L extends number> = A["length"] extends L ? never : never;
```

Let's add a type parameter `A` (Accumulator) to the definition and by default
make it an empty one to fix the compilation error about type parameter `A` being
not defined:

```typescript
type Tuple<L extends number, A extends never[] = []> = A["length"] extends L
  ? never
  : never;
```

Now, having an accumulator with length of 0 and the required length of 2, we
don't pass the condition. In such case, we call ourselves recursively, but
pushing the element into the accumulator, until the length of accumulator
matches the required length:

```typescript
type Tuple<L extends number, A extends never[] = []> = A["length"] extends L
  ? never
  : Tuple<L, [...A, never]>;
```

Once we get the needed length of an accumulator, we will pass the conditional
type and can return it:

```typescript
type Tuple<L extends number, A extends never[] = []> = A["length"] extends L
  ? A
  : Tuple<L, [...A, never]>;
```

Using the type is pretty simple. For instance, passing 5 as a length of a tuple,
we get 5 never-s:

```typescript
type R0 = Tuple<5>;
// R0 is [never, never, never, never, never]
```

We have a type that creates a tuple of required length, filled with `never`
type. Now, back to the challenge.

There is a low (L) and high (H) parameters that specify the minimum and maximum
of a range:

```typescript
type NumberRange<L, H> = any;
```

Creating a tuple of the length `L`, filled with `never`-s, will give us a range
0-L which is placed into another accumulator `A` by default:

```typescript
type NumberRange<
  L extends number,
  H extends number,
  A extends number[] = Tuple<L>
> = any;
```

Sitting in the position of `L` now, we need to start filling the tuple with the
actual numbers we will use for a union later. Since our values in the tuple
matches the indexes they have, we can simply use the property `length` as a
value:

```typescript
type NumberRange<
  L extends number,
  H extends number,
  A extends number[] = Tuple<L>
> = [...A, A["length"]];
```

So we got all the `never`-s until the `L`, and now we are getting the actual
numbers from `L` and greater. This needs to be repeated recursively till we get
to the `H` position. So we check if our accumulator length is equal to `H` and
if not – recursion:

```typescript
type NumberRange<
  L extends number,
  H extends number,
  A extends number[] = Tuple<L>
> = A["length"] extends H ? never : NumberRange<L, H, [...A, A["length"]]>;
```

At this point, we have a tuple of `never` types till the position of `L` and
actual numbers till the position of `H`. The only thing left is to return the
built accumulator in the case of length matches the `H`:

```typescript
type NumberRange<
  L extends number,
  H extends number,
  A extends number[] = Tuple<L>
> = A["length"] extends H ? A : NumberRange<L, H, [...A, A["length"]]>;
```

However, the accumulator does not include the last item. So we add the `length`
value to the tuple as well:

```typescript
type NumberRange<
  L extends number,
  H extends number,
  A extends number[] = Tuple<L>
> = A["length"] extends H
  ? [...A, A["length"]]
  : NumberRange<L, H, [...A, A["length"]]>;
```

At this point, we have the tuple we need. It has the range of `never` type from
`0` to `L` and the numbers from `L` to `H`. `never` type will be ignored in
union, so we don't care about it. The only thing what's left is to use the
lookup type with the `number` type and get the union:

```typescript
type NumberRange<
  L extends number,
  H extends number,
  A extends number[] = Tuple<L>
> = A["length"] extends H
  ? [...A, A["length"]][number]
  : NumberRange<L, H, [...A, A["length"]]>;
```

The whole solution, including the type `Tuple`:

```typescript
type Tuple<L extends number, A extends never[] = []> = A["length"] extends L
  ? A
  : Tuple<L, [...A, never]>;

type NumberRange<
  L extends number,
  H extends number,
  A extends number[] = Tuple<L>
> = A["length"] extends H
  ? [...A, A["length"]][number]
  : NumberRange<L, H, [...A, A["length"]]>;
```

I know, it's hard to grasp all of it at first. Take your time, re-read it
several times, follow the code, and you will understand it in no time.

## References

- [Generics](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Generic Constraints](https://www.typescriptlang.org/docs/handbook/2/generics.html#generic-constraints)
- [Indexed Access Types](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Variadic Tuple Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
- [Recursive Conditional Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
