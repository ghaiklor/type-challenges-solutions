---
id: 3062
title: Shift
lang: en
level: medium
tags: array
---

## Challenge

Implement the type version of `Array.shift()`. For example:

```typescript
type Result = Shift<[3, 2, 1]>; // [2, 1]
```

## Solution

Another challenge focused on manipulating the tuples. In this case, we need to
split the element from the beginning of the tuple and the “other” part - tail.
We start with the initial type:

```typescript
type Shift<T> = any;
```

In order to get the first element of the tuple and the rest of it, we can use
inferring within conditional types:

```typescript
type Shift<T> = T extends [infer _, ...infer T] ? never : never;
```

The first element is named as `_` because we don’t care about it. However, we
care about the rest of the tuple, which is exactly a shifted one. So that, we
return it from the true branch of the conditional type:

```typescript
type Shift<T> = T extends [infer _, ...infer T] ? T : never;
```

When type parameter `T` is not matched against the pattern with a head and a
tail, return the empty tuple, because no need to shift:

```typescript
type Shift<T> = T extends [infer _, ...infer T] ? T : [];
```

## References

- [Generics](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Inferring within Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Variadic Tuple Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
