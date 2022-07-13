---
id: 3326
title: BEM Style String
lang: en
level: medium
tags: template-literal union tuple
---

## Challenge

The Block, Element, Modifier methodology (BEM) is a popular naming convention
for classes in CSS.

For example, the block component would be represented as `btn`, element that
depends upon the block would be represented as `btn__price`, modifier that
changes the style of the block would be represented as `btn--big` or
`btn__price--warning`.

Implement `BEM<B, E, M>` which generates a string union from these three
parameters. Where `B` is a string literal, `E` and `M` are string arrays (can be
empty).

## Solution

In this challenge, we are asked to craft a specific string following the rules.
There are 3 rules we must follow: Block, Element and Modifier. In order to
simplify the overall look of the solution, I offer to split them into three
separate types.

We start with the first one - Block:

```typescript
type Block<B extends string> = any;
```

This one is pretty simple because all we need to do here is just to return a
template literal type comprising an input type parameter:

```typescript
type Block<B extends string> = `${B}`;
```

The next one is Element. It is not a template literal type as it was with Block,
because we have a case when the array of elements is empty. So we need to check
if the array is not empty and if so, construct a string. Knowing that an empty
array returns `never` type, when accessed as `T[number]`, we can check it with a
conditional type:

```typescript
type Element<E extends string[]> = E[number] extends never ? never : never;
```

If the array with elements is empty, we just return an empty literal type (no
need to have a string with prefix `__`):

```typescript
type Element<E extends string[]> = E[number] extends never ? `` : never;
```

Once we know an array is not empty, we need to add a prefix `__` and then
combine those elements in a template literal type:

```typescript
type Element<E extends string[]> = E[number] extends never
  ? ``
  : `__${E[number]}`;
```

The same logic we apply to the last one - Modifier. In case the array with
modifiers is empty - return empty literal type. Otherwise, return a prefix with
the union of modifiers:

```typescript
type Modifier<M extends string[]> = M[number] extends never
  ? ``
  : `--${M[number]}`;
```

What’s left is to combine those 3 types in our initial type:

```typescript
type BEM<
  B extends string,
  E extends string[],
  M extends string[]
> = `${Block<B>}${Element<E>}${Modifier<M>}`;
```

The full solution, including all 4 types, looks like that:

```typescript
type Block<B extends string> = `${B}`;
type Element<E extends string[]> = E[number] extends never
  ? ``
  : `__${E[number]}`;
type Modifier<M extends string[]> = M[number] extends never
  ? ``
  : `--${M[number]}`;
type BEM<
  B extends string,
  E extends string[],
  M extends string[]
> = `${Block<B>}${Element<E>}${Modifier<M>}`;
```

## References

- [Generics](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Generic Constraints](https://www.typescriptlang.org/docs/handbook/2/generics.html#generic-constraints)
- [Template Literal Types](https://www.typescriptlang.org/docs/handbook/2/template-literal-types.html)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
