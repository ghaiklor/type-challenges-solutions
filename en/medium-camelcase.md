---
title: CamelCase
lang: en
level: medium
tags: template-literal
challenge_url: https://tsch.js.org/610
---

## Challenge

Convert a string to CamelCase.
For example:

```typescript
type camelCased = CamelCase<'foo-bar-baz'> // expected "fooBarBaz"
```

## Solution

There is a common pattern that we can use for inferring the parts of the string - hyphen.
We can have everything before the hyphen - head, and everything after the hyphen - tail.
Let us infer those parts.

```typescript
type CamelCase<S> = S extends `${infer H}-${infer T}`
  ? never
  : never;
```

What if there is no such pattern?
We return the input string with no changes.

```typescript
type CamelCase<S> = S extends `${infer H}-${infer T}`
  ? never
  : S;
```

But if there is such a pattern, we need to remove the hyphen and capitalize the tail.
Also, we don’t forget that there are possibly other substring we need to process, so we do it recursively.

```typescript
type CamelCase<S> = S extends `${infer H}-${infer T}`
  ? `${H}${CamelCase<Capitalize<T>>}`
  : S;
```

The problem now is that we do not handle the cases when the tail already capitalized.
We can fix that by checking if we can assign the tail to capitalized tail.

```typescript
type CamelCase<S> = S extends `${infer H}-${infer T}`
  ? T extends Capitalize<T> ? never : `${H}${CamelCase<Capitalize<T>>}`
  : S;
```

What will we do if we get the capitalized tail?
We need to preserve the hyphen and just skip this one.
Sure, we need to do it recursively as well.

```typescript
type CamelCase<S> = S extends `${infer H}-${infer T}`
  ? T extends Capitalize<T> ? `${H}-${CamelCase<T>}` : `${H}${CamelCase<Capitalize<T>>}`
  : S;
```

We got a type that can capitalize template literal types, neat!

## References

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/advanced-types.html#conditional-types)
- [Type inference in conditional types](https://www.typescriptlang.org/docs/handbook/advanced-types.html#type-inference-in-conditional-types)
- [Recursive Conditional Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
- [Template Literal Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types)
