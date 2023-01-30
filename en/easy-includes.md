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

we can use recursive method. first, we define basic conditional statement. if first element of array is Equal target(U), result is true. if not, result is false.  
```typescript
T extends [infer First, ...infer Rest] ? Equal<First, U> extends true : false
```

if first element is true, another element of array is evaluated by same method.

```typescript
type Includes<T extends unknown[], U> = T extends [infer First, ...infer Rest]
? Equal<First, U> extends true 
  ? true : Includes<Rest, U> 
: false;

```

## References

- [Generics](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Generic Constraints](https://www.typescriptlang.org/docs/handbook/2/generics.html#generic-constraints)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Index Types](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)
