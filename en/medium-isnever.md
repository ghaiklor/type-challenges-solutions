---
id: 1042
title: IsNever
lang: en
level: medium
tags: union utils
---

## Challenge

Implement a type `IsNever<T>`, which takes input type `T`. If the type of `T`
resolves to `never`, return `true`, otherwise `false`.

For example:

```typescript
type A = IsNever<never>; // expected to be true
type B = IsNever<undefined>; // expected to be false
type C = IsNever<null>; // expected to be false
type D = IsNever<[]>; // expected to be false
type E = IsNever<number>; // expected to be false
```

## Solution

The most obvious solution here is to check if the type is assignable to `never`
with the help of conditional types. If we can assign the type `T` to `never`, we
return `true`, otherwise `false`.

```typescript
type IsNever<T> = T extends never ? true : false;
```

Unfortunately, we do not pass the test case for `never` itself. Why is that?

Type `never` represents the type of values that never occur. The `never` type is
a subtype of any other type in TypeScript and thus you can assign `never` type
to any type. However, no type is a subtype of `never`, meaning you can assign
nothing to `never`, except `never` itself.

That leads us to another problem. How can we check if the type is assignable to
`never` if we can not assign any type to `never`?

We could create another type with `never` inside, why not? What if we check that
type `T` is assignable not to `never`, but to the tuple that holds `never`? In
such case, formally, we are not trying to assign any type to `never`.

```typescript
type IsNever<T> = [T] extends [never] ? true : false;
```

With this workaround, hack, genuine solution, you name it; we can pass the test
and implement a generic type to check if the type is `never`.

## References

- [never type](https://www.typescriptlang.org/docs/handbook/2/narrowing.html#the-never-type)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Generics](https://www.typescriptlang.org/docs/handbook/2/generics.html)
