---
id: 898
title: Includes
lang: en
level: easy
tags: array
---

## Challenge

Implement the JavaScript `Array.includes` function in the type system. A type
takes the two arguments. The output should be a boolean `true` or `false`. For
example:

```typescript
// expected to be `false`
type isPillarMen = Includes<["Kars", "Esidisi", "Wamuu", "Santana"], "Dio">;
```

## Solution

We begin with writing the type that accepts two arguments: `T` (a tuple) and `U`
(what we are looking for).

```typescript
type Includes<T, U> = never;
```

Before we actually can find something in a tuple, it is easier to “convert” it
to union, instead of a tuple. To do so, we can use indexed types. If we access
the `T[number]`, TypeScript will return a union of all elements from `T`. E.g.
if you have a `T = [1, 2, 3]`, accessing it via `T[number]` will return
`1 | 2 | 3`.

```typescript
type Includes<T, U> = T[number];
```

But, there is an error “Type ‘number’ cannot be used to index type ‘T’”. It is
because we don’t have a constraint over `T`. We need to tell TypeScript that `T`
is an array.

```typescript
type Includes<T extends unknown[], U> = T[number];
```

We have a union of elements. How do we check if the element exists in a union?
Distributive conditional types! We can write a conditional type for a union, and
TypeScript will automatically apply the condition to each element of a union.

E.g. if you write `1 | 2 extends 2`, what TypeScript will do is actually replace
it with two conditionals `1 extends 2` and `2 extends 2`.

We can use it to check if `U` is in `T[number]` and if so, return true.

```typescript
type Includes<T extends unknown[], U> = U extends T[number] ? true : false;
```

## References

- [Generics](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Generic Constraints](https://www.typescriptlang.org/docs/handbook/2/generics.html#generic-constraints)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Distributive Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#distributive-conditional-types)
- [Index Types](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)
