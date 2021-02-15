---
id: 191
title: Append Argument
lang: en
level: medium
tags: arguments
---

## Challenge

For given function type `Fn`, and any type `A` (any in this context means we don't restrict the type, and I don't have in mind any type) create a generic type which will take `Fn` as the first argument, `A` as the second, and will produce function type `G` which will be the same as `Fn` but with appended argument `A` as a last one.

For example:

```ts
type Fn = (a: number, b: string) => number

// expected be (a: number, b: string, x: boolean) => number
type Result = AppendArgument<Fn, boolean>
```

## Solution

An interesting challenge!
There are type inferring, variadic tuple types, conditional types, a lot of interesting things.

We start with inferring function parameters and its return type.
Conditional types will help us with that.
Once types are inferred, we can return our own function signature that copies the input one, for now:

```ts
type AppendArgument<Fn, A> = Fn extends (args: infer P) => infer R ? (args: P) => R : never;
```

Obviously, this solution is not yet ready.
Why?
Because we check that `Fn` is assignable to the function with a single parameter `args`.
That’s not true, we can have over one or no parameters.

To fix that, we can use spread parameters:

```ts
type AppendArgument<Fn, A> = Fn extends (...args: infer P) => infer R ? (args: P) => R : never;
```

Now, the condition in conditional type evaluates to true, hence going into “true” branch with a type parameter `P` (function parameters) and type parameter `R` (return type).
Although, we still have a problem.
Type parameter `P` has a tuple with function parameters, but we need to treat them as a separate parameters.

By applying variadic tuple types, we can spread the tuple:

```ts
type AppendArgument<Fn, A> = Fn extends (...args: [...infer P]) => infer R ? (args: P) => R : never;
```

Type parameter `P` has what we need now.
The only thing left is to construct our own new function signature from inferred types:

```ts
type AppendArgument<Fn, A> = Fn extends (...args: [...infer P]) => infer R ? (...args: [...P]) => R : never;
```

We have a type that takes an input function and returns a new function with inferred types.
Having that we can add the required `A` parameter to the parameters list now:

```ts
type AppendArgument<Fn, A> = Fn extends (...args: [...infer P]) => infer R ? (...args: [...P, A]) => R : never;
```

## References

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/advanced-types.html#conditional-types)
- [Type inference in conditional types](https://www.typescriptlang.org/docs/handbook/advanced-types.html#type-inference-in-conditional-types)
- [Variadic Tuple Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
- [Rest parameters in function type](https://www.typescriptlang.org/docs/handbook/functions.html#rest-parameters)
