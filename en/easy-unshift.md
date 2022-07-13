---
id: 3060
title: Unshift
lang: en
level: easy
tags: array
---

## Challenge

Implement the type version of `Array.unshift()`. For example:

```typescript
type Result = Unshift<[1, 2], 0>; // [0, 1, 2]
```

## Solution

This one has a lot in common with the [Push challenge](./easy-push.md). There we
were using variadic tuple types to get all the elements from an array.

Here we do pretty the same, but in a different order. First, let us take all the
elements from the incoming array:

```typescript
type Unshift<T, U> = [...T];
```

With this snippet, we are getting the compilation error “A rest element type
must be an array type”. Let us fix the error by adding a constraint over the
type parameter:

```typescript
type Unshift<T extends unknown[], U> = [...T];
```

Now, we have the same array as the incoming one. All we need is to add an
element to the beginning of the tuple. Let’s do just that:

```typescript
type Unshift<T extends unknown[], U> = [U, ...T];
```

That way, we made an “unshift” function in the type system!

## References

- [Generics](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Generic Constraints](https://www.typescriptlang.org/docs/handbook/2/generics.html#generic-constraints)
- [Variadic Tuple Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
