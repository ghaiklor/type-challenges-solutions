---
id: 5140
title: Trunc
lang: en
level: medium
tags: template-literal
---

## Challenge

Implement the type version of `Math.trunc`, which takes string or number and returns the integer part of a number by removing any fractional digits.
For example:

```typescript
type A = Trunc<12.34> // 12
```

## Solution

It's easy to get the portion of a number before the dot if the number itself will be a string.
In a such way it is just a splitting the string by dot and getting the first part.

Thanks to template literal types in TypeScript, it is easy to do so.
So first, we will start with the initial type we need to implement:

```typescript
type Trunc<T> = any
```

We have a single type parameter that will be accepting the number itself.
As discussed, it will be easy to get the first part by splitting the string, so we need to convert a number to the string:

```typescript
type Trunc<T> = `${T}`
```

Getting an error, “Type 'T' is not assignable to type 'string | number | bigint | boolean | null | undefined”.
To fix this, we will add a generic constraint over type parameter `T` to limit the input parameters to numbers and strings only:

```typescript
type Trunc<T extends number | string> = `${T}`
```

Now, we have a string representation of our number.
Next, we can use a conditional type to check if a string is a string that has a dot in it.
If so, we will infer their parts:

```typescript
type Trunc<T extends number | string> = `${T}` extends `${infer R}.${infer _}` ? never : never
```

With this check in place, we can differentiate the cases when dot exists and when it doesn't.

Having a case when dot exists, we will get the chunk before the dot in the type parameter `R` and can return it, ignoring the part after the dot:

```typescript
type Trunc<T extends number | string> = `${T}` extends `${infer R}.${infer _}` ? R : never
```

But what to return if there is no dot in the string?
Well, it means that there is nothing to truncate, so we return the input type without modifications:

```typescript
type Trunc<T extends number | string> = `${T}` extends `${infer R}.${infer _}` ? R : `${T}`
```

That way, we are passing all the test-cases at the moment of writing the solution!

## References

- [Generics](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Generic Constraints](https://www.typescriptlang.org/docs/handbook/2/generics.html#generic-constraints)
- [Template Literal Types](https://www.typescriptlang.org/docs/handbook/2/template-literal-types.html)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Inferring within Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
