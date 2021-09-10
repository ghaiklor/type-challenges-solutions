---
id: 119
title: ReplaceAll
lang: en
level: medium
tags: template-literal
---

## Challenge

Implement `ReplaceAll<S, From, To>` which replace the all the substring `From` with `To` in the given string `S`.

For example:

```ts
type replaced = ReplaceAll<'t y p e s', ' ', ''> // expected to be 'types'
```

## Solution

We will base this solution on solution for [`Replace`](./medium-replace.md) type.

The input string `S` must be split into three parts.
The leftmost part before `From`, the `From` itself, the rightmost part after the `From`.
We can do that with conditional types and inferring.

Once the string is inferred and we know the parts, we can return a new template literal type which is constructed from those parts and our required `To` part:

```ts
type ReplaceAll<
  S extends string,
  From extends string,
  To extends string
> = From extends '' ? S : S extends `${infer L}${From}${infer R}` ? `${L}${To}${R}` : S;
```

This solution will replace a single match, but we need to replace all the matches.
It is easily achievable by providing our new string as a type parameter to the type itself (recursively):

```ts
type ReplaceAll<
  S extends string,
  From extends string,
  To extends string
> = From extends '' ? S : S extends `${infer L}${From}${infer R}` ? ReplaceAll<`${L}${To}${R}`, From, To> : S;
```

However, on the next recursive call, characters can be replaced in not expected way.
For instance, calling `ReplaceAll<"fooo", "fo", "f">` will lead to `foo -> fo -> f`.
So that, we need to keep track of the string before:

```
type ReplaceAll<
  S extends string,
  From extends string,
  To extends string,
  Before extends string = ""
> = From extends "" ?
      S :
      S extends `${Before}${infer L}${From}${infer R}` ?
        ReplaceAll<`${Before}${L}${To}${R}`, From, To, `${Before}${L}${To}`> :
        S
```

## References

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Type inference in conditional types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Recursive Conditional Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
- [Template Literal Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types)
