---
id: 2257
title: MinusOne
lang: en
level: medium
tags: math
---

## Challenge

Given a number (always positive) as a type.
Your type should return the number decreased by one.
For example:

```typescript
type Zero = MinusOne<1>; // 0
type FiftyFour = MinusOne<55>; // 54
```

## Solution

It is a challenging task indeed.
TypeScript has nothing to offer to work with the number literal types at all - nothing.

So that, we need to workaround it somehow and I believe it will not be a pleasure.
Please, understand that it is going to be a really hacky solution and I don’t know if there is a better way (at the time of writing).

I’ve started by questioning myself, “where did we work with the number literal types without specifying them as literal types?”.
The only answer I came up with was tuples!

We had challenges where we worked with the tuples and were getting their length by using indexed access types.
Do you remember the syntax for it?
It was simple as that - accessing the property `length` directly on the tuple.

So I thought, we can create a tuple of required length (which is our input number) and infer the part of the tuple from it without the last element.
Afterwards, get the length of inferred tuple, hence the tuple that is one element shorter.

Let us start with the helper type that will build a tuple of required length.
Let us call it `Tuple`:

```typescript
type Tuple<L extends number, T extends unknown[] = []> = never;
```

It accepts the length of the tuple and temporary accumulator that holds the tuple itself.
Now, we need to check if the temporary accumulator has the required length.
To do that, we access its property `length` and compare it with the required length:

```typescript
type Tuple<L extends number, T extends unknown[] = []> = T["length"] extends L
  ? never
  : never;
```

Once we get the tuple of required length - return the tuple:

```typescript
type Tuple<L extends number, T extends unknown[] = []> = T["length"] extends L
  ? T
  : never;
```

However, while we are still don’t have a required tuple, we need to create it somehow.
To do that, we apply recursive types and append to the temporary accumulator a single element.
We do so until the temporary accumulator will not have the required count of elements:

```typescript
type Tuple<L extends number, T extends unknown[] = []> = T["length"] extends L
  ? T
  : Tuple<L, [...T, unknown]>;
```

Now, when we call the type with `5` as a parameter, for instance, we will get a tuple with 5 `unknown` elements.
Accessing the property `length` of the tuple will return a number literal type `5`.
Exactly what we needed.

How do we get a number literal type `4` from a tuple like this?
We can infer the part of the tuple without its last element!

```typescript
type MinusOne<T extends number> = Tuple<T> extends [...infer L, unknown]
  ? never
  : never;
```

By using such a construct, we will get a tuple in type parameter `L` without its last element `unknown`.
Hence, the tuple that is one element shorter.

All that’s left is to return the type value of property `length`:

```typescript
type MinusOne<T extends number> = Tuple<T> extends [...infer L, unknown]
  ? L["length"]
  : never;
```

That way we have implemented a simple substraction in a type system.
Calling `MinusOne<5>` e.g. will give a result - type literal `4`.

```typescript
type Tuple<L extends number, T extends unknown[] = []> = T["length"] extends L
  ? T
  : Tuple<L, [...T, unknown]>;
type MinusOne<T extends number> = Tuple<T> extends [...infer L, unknown]
  ? L["length"]
  : never;
```

Although, please note that with recent TypeScript versions, they have added a check for recursive calls.
So that, honestly, we don’t pass the tests that contain numbers greater than 50.
Meaning, I can’t really say that it is a solution.

If you have any better ideas, please do not hesitate to leave them in the comments with an explanation.
Thank you!

## References

- [Generics](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Indexed Access Types](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Inferring within Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Recursive Conditional Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
- [Variadic Tuple Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
