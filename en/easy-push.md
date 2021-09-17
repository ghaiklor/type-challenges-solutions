---
id: 3057
title: Push
lang: en
level: easy
tags: array
---

## Challenge

Implement the generic version of `Array.push`.
For example:

```typescript
type Result = Push<[1, 2], '3'> // [1, 2, '3']
```

## Solution

An easy one, indeed.
To implement a type that pushes an element to the array, we need to do two things.
First thing is to get all the elements of array and the second one is to add an extra element to them.

To get all the elements from an array, we can use variadic tuple types.
So, let us return an array with the same elements from input type `T`:

```typescript
type Push<T, U> = [...T]
```

Getting a compilation error “A rest element type must be an array type”.
It means that we can not use variadic tuple type on non-array-like types.
So let us add a generic constraint to show that we are working with arrays only:

```typescript
type Push<T extends unknown[], U> = [...T]
```

Now, we have a copy of the incoming array in type parameter `T`.
The only thing remains is to add an element from `U`:

```typescript
type Push<T extends unknown[], U> = [...T, U]
```

That way, we have implemented a push operation in the type system.

## References

- [Generics](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Variadic Tuple Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
