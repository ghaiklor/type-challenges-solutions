---
id: 612
title: KebabCase
lang: en
level: medium
tags: template-literal
---

## Challenge

Convert a string to kebab-case.
For example:

```typescript
type kebabCase = KebabCase<'FooBarBaz'> // expected "foo-bar-baz"
```

## Solution

This challenge has a lot in common with the ["CamelCase"](./medium-camelcase.md) challenge.
We start from inferring; we need to know the first character and the tail.

```typescript
type KebabCase<S> = S extends `${infer C}${infer T}`
  ? never
  : never;
```

Once there is no pattern for character and tail, it means that we are done with the string and there is nothing left.
So we just return the input string with no changes.

```typescript
type KebabCase<S> = S extends `${infer C}${infer T}`
  ? never
  : S;
```

But, in case we have the pattern, we need to handle two cases.
The first one is the case when we do not have the capitalized tail, and the second one is when we do.
To check this, we can use `Uncapitalize` type.

```typescript
type KebabCase<S> = S extends `${infer C}${infer T}`
  ? T extends Uncapitalize<T> ? never : never
  : S;
```

What do we do if we have the uncapitalized tail?
It means that we can have e.g. “Foo” or “foo”.
So we “uncapitalize” the first character and leave the tail without modifications.
Do not forget that we need to continue to apply the type to process other characters.

```typescript
type KebabCase<S> = S extends `${infer C}${infer T}`
  ? T extends Uncapitalize<T> ? `${Uncapitalize<C>}${KebabCase<T>}` : never
  : S;
```

The last case we have now is the case when the tail is capitalized, e.g. “fooBar”.
We need to “uncapitalize” the first character, add the hyphen, and continue processing the tail recursively.
We do not need to “uncapitalize” the tail here because it will be uncapitalized anyway on `Uncapitalize<C>`.

```typescript
type KebabCase<S> = S extends `${infer C}${infer T}`
  ? T extends Uncapitalize<T> ? `${Uncapitalize<C>}${KebabCase<T>}` : `${Uncapitalize<C>}-${KebabCase<T>}`
  : S;
```

## References

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Type inference in conditional types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Recursive Conditional Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
- [Template Literal Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types)
