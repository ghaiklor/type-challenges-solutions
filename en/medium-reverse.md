---
id: 3192
title: Reverse
lang: en
level: medium
tags: tuple
---

## Challenge

Implement the type version of `Array.reverse()`.
For example:

```typescript
type a = Reverse<["a", "b"]>; // ['b', 'a']
type b = Reverse<["a", "b", "c"]>; // ['c', 'b', 'a']
```

## Solution

Reversing the tuple is easier than it seems to be.
You need to get the last element of a tuple and put it first in another tuple.
Continuing this operation recursively gives us a reverse tuple in the end.

We start with the initial type to fill it with the implementation later:

```typescript
type Reverse<T> = any;
```

Now, as we talked earlier, we need to get the last element of a tuple and the rest of it.
To do so, apply the inferring within conditional types:

```typescript
type Reverse<T> = T extends [...infer H, infer T] ? never : never;
```

Pay attention to the spread we have in the first part of the tuple.
With this construct we are saying “TypeScript, give us the whole tuple without the last element and the last element assign to the type parameter `T`”.
Having the last element of the tuple, we can create a new one and put the `T` inside of it:

```typescript
type Reverse<T> = T extends [...infer H, infer T] ? [T] : never;
```

Doing so, we get the last element put as the first one.
But, we need to apply the same operation to other elements in the tuple.
It is easily achievable by calling the `Reverse` again recursively:

```typescript
type Reverse<T> = T extends [...infer H, infer T] ? [T, Reverse<H>] : never;
```

But calling a `Reverse` will give us a tuple inside of a tuple and the more we call it, the more depth we get.
That’s not what we want.
Instead, we need to get a plain tuple.
Applying the spread operator to the result of `Reverse` type, we can make it plain:

```typescript
type Reverse<T> = T extends [...infer H, infer T] ? [T, ...Reverse<H>] : never;
```

What if the type parameter `T` does not match the pattern of head and a tail?
In this case, we return the empty tuple to not break the spread:

```typescript
type Reverse<T> = T extends [...infer H, infer T] ? [T, ...Reverse<H>] : [];
```

## References

- [Generics](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Inferring within Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Recursive Conditional Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
- [Variadic Tuple Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
