---
id: 2070
title: Drop Char
lang: en
level: medium
tags: template-literal infer
---

## Challenge

Drop a specified char from a string.
For example:

```typescript
type Butterfly = DropChar<' b u t t e r f l y ! ', ' '> // 'butterfly!'
```

## Solution

To solve the challenge, we need to know about template literal types.
You can [read more about them](https://www.typescriptlang.org/docs/handbook/2/template-literal-types.html) in the TypeScript Handbook.

When using template literal types, we can infer the needed parts from the string and check if the part is what we expect.
Let’s start with the simplest case - infer the left part and the right part of the string.
The delimiter between them is the needed char itself.

```typescript
type DropChar<S, C> = S extends `${infer L}${C}${infer R}`
  ? never
  : never;
```

With such a notation, we are getting a compilation error “Type ‘C’ is not assignable to type ‘string | number | bigint | boolean | null | undefined’.“.
Adding a generic constraint will fix it.

```typescript
type DropChar<S, C extends string> = S extends `${infer L}${C}${infer R}`
  ? never
  : never;
```

Now, we can see clearly that we have all the parts and the character from `C` between them.
Since we need to remove the `C`, we return the left and right parts without it.

```typescript
type DropChar<S, C extends string> = S extends `${infer L}${C}${infer R}`
  ? `${L}${R}`
  : never;
```

That way, we dropped one character from the string.
To drop others, we need to continue dropping them by calling the type recursively.

```typescript
type DropChar<S, C extends string> = S extends `${infer L}${C}${infer R}`
  ? DropChar<`${L}${R}`, C>
  : never;
```

We covered all the cases, except the case when there are no patterns we look for.
If so, we just passing through the incoming string itself.

```typescript
type DropChar<S, C extends string> = S extends `${infer L}${C}${infer R}`
  ? DropChar<`${L}${R}`, C>
  : S;
```

## References

- [Template Literal Types](https://www.typescriptlang.org/docs/handbook/2/template-literal-types.html)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Inferring within Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
