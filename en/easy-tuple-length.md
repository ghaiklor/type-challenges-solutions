---
id: 18
title: Length of Tuple
lang: en
level: easy
tags: tuple
---

## Challenge

For given a tuple, you need create a generic `Length`, pick the length of the
tuple.

For example:

```ts
type tesla = ["tesla", "model 3", "model X", "model Y"];
type spaceX = [
  "FALCON 9",
  "FALCON HEAVY",
  "DRAGON",
  "STARSHIP",
  "HUMAN SPACEFLIGHT",
];

type teslaLength = Length<tesla>; // expected 4
type spaceXLength = Length<spaceX>; // expected 5
```

## Solution

We know that we can use property `length` to access the length of the array in
JavaScript. We can do the same in types as well:

```ts
type Length<T extends any> = T["length"];
```

But going that way we will get the compilation error “Type 'length' cannot be
used to index type 'T'.”. So we need to give a hint to TypeScript and tell that
our input type parameter has this property:

```ts
type Length<T extends { length: number }> = T["length"];
```

An alternative solution:

```ts
type Length<T extends readonly any[]> = T["length"];
```

## References

- [Indexed Types](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)
