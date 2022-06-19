---
id: 2688
title: StartsWith
lang: en
level: medium
tags: template-literal
---

## Challenge

Implement `StartsWith<T, U>` which takes two exact string types and returns whether `T` starts with `U`.
For example:

```typescript
type a = StartsWith<"abc", "ac">; // expected to be false
type b = StartsWith<"abc", "ab">; // expected to be true
type c = StartsWith<"abc", "abcd">; // expected to be false
```

## Solution

Knowing about template literal types in TypeScript, the solution becomes really obvious.
Let’s start with an initial type that holds `any` type:

```typescript
type StartsWith<T, U> = any;
```

We need to check if the input type parameter `T` starts with a string literal from `U`.
I’ll do it simpler and just check if the `T` is `U` by using conditional types:

```typescript
type StartsWith<T, U> = T extends `${U}` ? never : never;
```

If the input type parameter `T` is the same as in type parameter `U`, we will go into the true branch of the conditional type.
But, we don’t need them to be equal.
We need to check if it starts with `U`.
In other words; we don’t care if there will be something after the `U` in our literal type.
So that, use `any` type there:

```typescript
type StartsWith<T, U> = T extends `${U}${any}` ? never : never;
```

If type `T` matches the pattern of a string that starts with `U`, we return the `true` literal type.
Otherwise, return `false`:

```typescript
type StartsWith<T, U> = T extends `${U}${any}` ? true : false;
```

We got all the test cases passed, but we still got a compilation error saying “Type ‘U’ is not assignable to type ‘string | number | bigint | boolean | null | undefined’.“.
That’s because we didn’t add a constraint over generic to show that `U` is a string.
Let’s add it:

```typescript
type StartsWith<T, U extends string> = T extends `${U}${any}` ? true : false;
```

## References

- [Generics](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Generic Constraints](https://www.typescriptlang.org/docs/handbook/2/generics.html#generic-constraints)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Template Literal Types](https://www.typescriptlang.org/docs/handbook/2/template-literal-types.html)
