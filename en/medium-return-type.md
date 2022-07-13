---
id: 2
title: Get Return Type
lang: en
level: medium
tags: infer built-in
---

## Challenge

Implement the built-in `ReturnType<T>` generic without using it.

For example:

```ts
const fn = (v: boolean) => {
  if (v) return 1;
  else return 2;
};

type a = MyReturnType<typeof fn>; // should be "1 | 2"
```

## Solution

The rule of the thumb of using
[type inference in conditional types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
is when you are not sure what the type must be in. Exactly the case of the
challenge. We don’t know what the return type of the function, but we tasked to
get it.

We have a function that looks in type system as `() => void`. But we don’t know
what must be in the place of `void`. So let us replace it with `infer R` and it
will be our first iteration to the solution:

```ts
type MyReturnType<T> = T extends () => infer R ? R : T;
```

In case our type `T` is assignable to the function, we infer its return type and
return it, otherwise we return `T` itself. Pretty straightforward.

The problem with the solution is that if we pass a function with parameters, it
will not be assignable to our type `() => infer R`.

Let us show that we can accept any parameters and we don’t care about them by
adding `...args: any[]`:

```ts
type MyReturnType<T> = T extends (...args: any[]) => infer R ? R : T;
```

## References

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Type inference in conditional types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
