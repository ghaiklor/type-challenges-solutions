---
id: 2693
title: EndsWith
lang: en
level: medium
tags: template-literal
---

## Challenge

Implement `EndsWith<T, U>` which takes two exact string types and returns whether `T` ends with `U`:

```typescript
type R0 = EndsWith<'abc', 'bc'> // true
type R1 = EndsWith<'abc', 'abc'> // true
type R2 = EndsWith<'abc', 'd'> // false
```

## Solution

This challenge is in the medium category, but I don’t think it should be here.
It’s more like a simple level than medium one.
But, who am I to judge.

We need to check if the string ends with the specified string.
It’s straightforward that template literal types are going to be useful for us.

Let us start with the template literal type that shows any string it can have.
At this point, we don’t care about the content, so we can leave `any` type here:

```typescript
type EndsWith<
  T extends string,
  U extends string
> = T extends `${any}` ? never : never
```

With this statement, we are saying “hey, compiler, check if the string literal type of `T` extends from `any` type”.
Which is true, it is extended.

Now, let us add a substring we want to check.
We pass the substring through a type parameter `U` and we need to check if it is at the end of the string.
So be it:

```typescript
type EndsWith<
  T extends string,
  U extends string
> = T extends `${any}${U}` ? never : never
```

By using such a construct, we are checking if the string extends from anything, but ends with `U` - simple.
All what’s left is to return boolean literal types according to the result:

```typescript
type EndsWith<
  T extends string,
  U extends string
> = T extends `${any}${U}` ? true : false
```

## References

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Template Literal Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types)
