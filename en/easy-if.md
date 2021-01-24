# If

![easy](https://img.shields.io/badge/-easy-7aad0c)
![#utils](https://img.shields.io/badge/-%23utils-999)

## Challenge

Implement a utils `If` which accepts condition `C`, a truthy return type `T`, and a falsy return type `F`.
`C` is expected to be either `true` or `false` while `T` and `F` can be any type.

For example:

```ts
type A = If<true, 'a', 'b'> // expected to be 'a'
type B = If<false, 'a', 'b'> // expected to be 'b'
```

## Solution

If you are not sure when to use [conditional types](https://www.typescriptlang.org/docs/handbook/advanced-types.html#conditional-types) in TypeScript, it is when you need to use an “if” statement on types.
Exactly what we tasked to do here.

If the condition type evaluates to `true`, we need to take a “true” branch, otherwise “false” branch:

```ts
type If<C, T, F> = C extends true ? T : F;
```

Going that way we will get a compilation error, because we are trying to assign `C` to boolean type and not having a constraint that shows that.
So let us fix it by adding `extends boolean` to the type parameter `C`:

```ts
type If<C extends boolean, T, F> = C extends true ? T : F;
```

## References

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/advanced-types.html#conditional-types)
