---
id: 5117
title: Without
lang: en
level: medium
tags: union array
---

## Challenge

Implement the type version of lodash `.without()`.
`Without<T, U>` takes an array `T`, number or array `U` and returns an array without the elements of `U`.

```typescript
type Res = Without<[1, 2], 1>; // expected to be [2]
type Res1 = Without<[1, 2, 4, 1, 5], [1, 2]>; // expected to be [4, 5]
type Res2 = Without<[2, 3, 2, 3, 2, 3, 2, 3], [2, 3]>; // expected to be []
```

## Solution

This challenge was an interesting one, indeed.
We need to implement the type that can filter out items from a tuple.
We start with the initial type:

```typescript
type Without<T, U> = any;
```

Since we need to work with the specific items in the tuple, I’m using the inferring to get the specific item and the rest of the tuple:

```typescript
type Without<T, U> = T extends [infer H, ...infer T] ? never : never;
```

Having an item from the tuple, we can check if the item is the type `U`.
We need this check in order to decide, should we add the element to the result or not:

```typescript
type Without<T, U> = T extends [infer H, ...infer T]
  ? H extends U
    ? never
    : never
  : never;
```

In case it is “extends” from the input type `U`, it means that we don’t need it in our resulting type.
So we just skip it and return a tuple without it.
But, since we need to process other items as well, we return not an empty tuple, but a tuple with a recursive call to `Without` again:

```typescript
type Without<T, U> = T extends [infer H, ...infer T]
  ? H extends U
    ? [...Without<T, U>]
    : never
  : never;
```

That way, we skip anything that is specified as `U` in our `T`.
However, once we get a check that says we shouldn’t skip the element, we return a tuple with the element itself:

```typescript
type Without<T, U> = T extends [infer H, ...infer T]
  ? H extends U
    ? [...Without<T, U>]
    : [H, ...Without<T, U>]
  : never;
```

There is the last `never` type left we need to address.
Since we are working with the variadic tuple types and spreading them, instead of `never` we must return an empty tuple:

```typescript
type Without<T, U> = T extends [infer H, ...infer T]
  ? H extends U
    ? [...Without<T, U>]
    : [H, ...Without<T, U>]
  : [];
```

We got a working solution for a case, when `U` specified as a primitive type.
But, in the challenge, there is also a case when it can be specified as a tuple of numbers.
To support this case, we can extend our type `U` in `H extends U` to be a conditional type that checks that case.

If `U` is a tuple of numbers, we return all the items in there as a union, otherwise - just `U`:

```typescript
type Without<T, U> = T extends [infer H, ...infer T]
  ? H extends (U extends number[] ? U[number] : U)
    ? [...Without<T, U>]
    : [H, ...Without<T, U>]
  : [];
```

Congratulations!
We have implemented a lodash version of `.without()` method in the type system.

## References

- [Generics](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Inferring within Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Recursive Conditional Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
