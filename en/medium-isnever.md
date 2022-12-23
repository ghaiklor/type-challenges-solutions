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

`extends` becomes distributive when the left-hand side is a generic and a union
is supplied through it. `never` represents an empty union, so when `never` is
supplied _through a generic_, nothing gets distributed to the right-hand side of
`extends`, and the whole thing resolves to `never`, i.e. an empty union.

To avoid this distributivity, we can surround each side of `extends` with square
brackets. This way, the left-hand side of `extends` becomes a tuple holding a
generic rather than a generic itself.

```typescript
type IsNever<T> = [T] extends [never] ? true : false;
```

With this workaround, hack, genuine solution, you name it; we can pass the test
and implement a generic type to check if the type is `never`.

## References

- [never type](https://www.typescriptlang.org/docs/handbook/2/narrowing.html#the-never-type)
- [Never is the empty union](https://github.com/microsoft/TypeScript/issues/31751#issuecomment-498526919)
- [Distributive Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#distributive-conditional-types)
- [Generics](https://www.typescriptlang.org/docs/handbook/2/generics.html)
