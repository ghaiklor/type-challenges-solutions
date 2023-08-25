---
id: 5310
title: Join
lang: en
level: medium
tags: array
---

## Challenge

Implement the type version of `Array.join`. `Join<T, U>` takes an array `T`,
separator `U` and returns the array `T` with `U` stitching up.

```typescript
type Res = Join<["a", "p", "p", "l", "e"], "-">; // expected to be 'a-p-p-l-e'
type Res1 = Join<["Hello", "World"], " ">; // expected to be 'Hello World'
type Res2 = Join<["2", "2", "2"], 1>; // expected to be '21212'
type Res3 = Join<["o"], "u">; // expected to be 'o'
```

## Solution

At first glance, the easiest solution to this is to enumerate items in the tuple
and return the template literal type with its content and separator.

Let's start with the blank type we need to implement:

```typescript
type Join<T, U> = any;
```

The classic trick to enumerate the tuple is to infer its first element and rest,
following with recursion. Let's add inferring first:

```typescript
type Join<T, U> = T extends [infer S, ...infer R] ? never : never;
```

Here, we infer the string (`S`) and the rest (`R`) of the tuple. What should we
do with the inferred string? We need to add a separator after it from the type
parameter `U`:

```typescript
type Join<T, U> = T extends [infer S, ...infer R] ? `${S}${U}` : never;
```

Having this type, we are able to add a separator to the first element of the
tuple. But we need to do it until the end of the tuple so that we continue
joining the rest:

```typescript
type Join<T, U> = T extends [infer S, ...infer R]
  ? `${S}${U}${Join<R, U>}`
  : never;
```

However, there is an absent case when there is no more elements. In such case,
we return an empty string, so that it will not mix something up in the result:

```typescript
type Join<T, U> = T extends [infer S, ...infer R]
  ? `${S}${U}${Join<R, U>}`
  : "";
```

Seems like a working solution, but we got some compiler errors. So let's fix
them foremost. The first compiler error is “Type 'S' is not assignable to type
'string | number | bigint | boolean | null | undefined'”. The same error applies
to the type parameter `U`. We can fix it by introducing constraints over
generics:

```typescript
type Join<T extends string[], U extends string | number> = T extends [
  infer S,
  ...infer R,
]
  ? `${S}${U}${Join<R, U>}`
  : "";
```

These constraints check if the input type parameters are what we expect here.
Now, we need to tell the compiler that these types that we are inferring are
also strings. So that, we add the same construct in the block with inferring:

```typescript
type Join<T extends string[], U extends string | number> = T extends [
  infer S extends string,
  ...infer R extends string[],
]
  ? `${S}${U}${Join<R, U>}`
  : "";
```

Pretty close, but still no... We got a solution that adds a trailing dash, which
we don't need there. For instance, passing an apple will give us:

```typescript
type R0 = Join<["a", "p", "p", "l", "e"], "-">;
// type R0 = "a-p-p-l-e-"
```

How to remove it from there? Let's try to check if there are some strings left
or not, instead of simply putting the separator:

```typescript
type Join<T extends string[], U extends string | number> = T extends [
  infer S extends string,
  ...infer R extends string[],
]
  ? `${S}${R["length"] extends 0 ? never : never}${Join<R, U>}`
  : "";
```

We do so by looking into the `length` of the tuple `R`, the exact tuple where
the rest is stored. In case, the rest is empty, it means nothing left to
process, so we don't need a separator there:

```typescript
type Join<T extends string[], U extends string | number> = T extends [
  infer S extends string,
  ...infer R extends string[],
]
  ? `${S}${R["length"] extends 0 ? "" : never}${Join<R, U>}`
  : "";
```

In all other cases, we put the separator:

```typescript
type Join<T extends string[], U extends string | number> = T extends [
  infer S extends string,
  ...infer R extends string[],
]
  ? `${S}${R["length"] extends 0 ? "" : U}${Join<R, U>}`
  : "";
```

## References

- [Generics](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Generic Constraints](https://www.typescriptlang.org/docs/handbook/2/generics.html#generic-constraints)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Inferring within Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Variadic Tuple Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
- [Template Literal Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types)
- [Indexed Access Types](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)
- [Recursive Conditional Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
