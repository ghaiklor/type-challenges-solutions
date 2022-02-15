---
id: 3312
title: Parameters
lang: zh
level: easy
tags: infer tuple built-in
---

## Challenge

Implement the built-in `Parameters<T>` generic without using it.

## Solution

This challenge requires us to get part of the information from the function.
To be more precise, parameters of the function.
Let’s start with declaring a type that accepts a generic type `T` that we will use to get the parameters:

```typescript
type MyParameters<T> = any
```

Now, what is the proper way of “getting the type we don’t know about yet”?
By using inferring!
But before using it, let’s start with a simple conditional type to match the function:

```typescript
type MyParameters<T> = T extends (...args: any[]) => any ? never : never
```

Here, we check if the type `T` matches the function with any arguments and any return type.
Now, we can replace `any[]` in our parameters list with the inferring:

```typescript
type MyParameters<T> = T extends (...args: infer P) => any ? never : never
```

That way, the TypeScript compiler infers the parameters list of the function and will assign it to the type `P`.
What’s left is to return the type from the branch:

```typescript
type MyParameters<T> = T extends (...args: infer P) => any ? P : never
```

## References

- [Generics](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Inferring within Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
