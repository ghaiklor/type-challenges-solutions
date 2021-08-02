---
id: 949
title: AnyOf
lang: en
level: medium
tags: array
---

## Challenge

Implement Python liked `any` function in the type system.
A type takes the array and returns `true` if any element of the array is true.
If the array is empty, return `false`.
For example:

```typescript
type Sample1 = AnyOf<[1, "", false, [], {}]>; // expected to be true
type Sample2 = AnyOf<[0, "", false, [], {}]>; // expected to be false
```

## Solution

Once I saw the challenge, my first idea was to use [distributive conditional types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#distributive-conditional-types).

We can use the syntax `T[number]` to take the union of all elements from the tuple.
Having a union of the elements, we iterate them and get a union of `false` or `true` types.
In case all the elements returned `false`, we get the `false` type literal.
But, having even a single `true`-y element results in `true` type literal.
Hence, our union will comprise `false` and `true` type literals, the product of which is `boolean`.
Checking the product of a union against `false` type literal says if there was a `true` element.

But, the actual implementation for this turned out to be really quirky.
I don’t like it, take a look:

```typescript
type AnyOf<T extends readonly any[], I = T[number]> = (
  I extends any ?
  I extends Falsy ?
  false :
  true :
  never
) extends false ? false : true;
```

So I’ve started thinking, can we make it more maintainable?
Turns out we can.
Let us remember about inferring from tuple types combined with variadic tuple types.
Remember, we used these when solving [Last](./medium-last.md) challenge or [Pop](./medium-pop.md) and the likes.

We start from inferring the single element from the tuple and the rest of the family:

```typescript
type AnyOf<T extends readonly any[]> = T extends [infer H, ...infer T]
  ? never
  : never;
```

How can we check if the inferred element `H` is false-y?
First, we can construct a type that represents false-y types.
Let’s call it `Falsy`:

```typescript
type Falsy = 0 | '' | false | [] | { [P in any]: never }
```

Having a type that represents false-y values, we can just use a conditional type to check if the `H` extends from the type:

```typescript
type AnyOf<T extends readonly any[]> = T extends [infer H, ...infer T]
  ? H extends Falsy
  ? never
  : never
  : never;
```

What do we do if the element is false-y?
It means we are still trying to check if there is at least one true-y element.
So we can continue recursively:

```typescript
type AnyOf<T extends readonly any[]> = T extends [infer H, ...infer T]
  ? H extends Falsy
  ? AnyOf<T>
  : never
  : never;
```

Finally, once we see the element is not false-y, it means it is true-y.
It makes little sense to continue recursively since we already know there is true-y element.
So we just exit from recursion by returning `true` type literal:

```typescript
type AnyOf<T extends readonly any[]> = T extends [infer H, ...infer T]
  ? H extends Falsy
  ? AnyOf<T>
  : true
  : never;
```

The last state is when we have an empty tuple.
In such case our inferring will not work, meaning there is definitely no true-y elements.
We can return `false` in such case:

```typescript
type AnyOf<T extends readonly any[]> = T extends [infer H, ...infer T]
  ? H extends Falsy
  ? AnyOf<T>
  : true
  : false;
```

That’s how we made an implementation of `AnyOf` function in the type system.
For the reference here is the whole implementation:

```typescript
type Falsy = 0 | '' | false | [] | { [P in any]: never }

type AnyOf<T extends readonly any[]> = T extends [infer H, ...infer T]
  ? H extends Falsy
  ? AnyOf<T>
  : true
  : false;
```

## References

- [Union Types](https://www.typescriptlang.org/docs/handbook/2/everyday-types.html#union-types)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Inferring within Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Generics](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Variadic Tuple Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
