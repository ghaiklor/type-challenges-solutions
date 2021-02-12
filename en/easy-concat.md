---
lang: en
level: easy
tags: array
---

# Concat

![easy](https://img.shields.io/badge/-easy-7aad0c)
![#array](https://img.shields.io/badge/-%23array-999)

## Challenge

Implement the JavaScript `Array.concat` function in the type system.
A type takes the two arguments.
The output should be a new array that includes inputs in ltr order.

For example:

```ts
type Result = Concat<[1], [2]> // expected to be [1, 2]
```

## Solution

When working with arrays in TypeScript, pretty often Variadic Tuple Types are coming to the rescue in certain situations.
They allow us to make generic spreads.
I’ll try to explain, hold on.

Let me show you the implementation of concatenating two arrays in JavaScript:

```js
function concat(arr1, arr2) {
  return [...arr1, ...arr2];
}
```

We can use spread operators and just take everything from the `arr1` and paste it into another array.
We can apply the same to the `arr2`.
The key idea here is that it iterates over the elements in array\tuple and pastes them in the place where spread operator is used.

Variadic Tuple Types allows us to model the same behavior in the type system.
If we want to concatenate two generic arrays, we can return the new array where both arrays are behind the spread operator:

```ts
type Concat<T, U> = [...T, ...U]
```

We are getting the error “A rest element type must be an array type.”, though.
Let us fix that by letting compiler know those types are arrays:

```ts
type Concat<T extends unknown[], U extends unknown[]> = [...T, ...U]
```

## References

- [Variadic Tuple Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
