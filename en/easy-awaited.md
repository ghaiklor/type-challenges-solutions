---
title: Awaited
lang: en
level: easy
tags: promise
---

## Challenge

If we have a type which is wrapped type like `Promise`.
How we can get a type which is inside the wrapped type?
For example if we have `Promise<ExampleType>` how to get `ExampleType`?

> This question is ported from the [original article](https://dev.to/macsikora/advanced-typescript-exercises-question-1-45k4) by [@maciejsikora](https://github.com/maciejsikora)

## Solution

Pretty interesting challenge that requires us to know about one of the underrated TypeScript features, IMHO.

But, before explaining what I mean, let us analyze the challenge.
The author asks us to unwrap the type.
What is unwrap?
Unwrap is extracting the inner type from another type.

Let me explain it with an example.
If you have a type `Promise<string>`, unwrapping the `Promise` type will result into type `string`.
We got the inner type from the outer type.

Now, to the challenge.
I’ll start with the simplest case.
If our `Awaited` type gets `Promise<string>`, we need to return the `string`, otherwise we return the `T` itself, because it is not a Promise:

```ts
type Awaited<T> = T extends Promise<string> ? string : T;
```

But there is a problem.
That way, we can handle only strings in `Promise` while we need to handle any case.
So how to do that?
How to get the type from `Promise` if we don’t know what is there?

For these purposes, TypeScript has type inference in conditional types!
You can say to the compiler “hey, once you know what the type is, assign it to my type parameter, please”.
You can read more about [type inference in conditional types here](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-8.html#type-inference-in-conditional-types).

Knowing about type inference, we can update our solution.
Instead of checking for `Promise<string>` in our conditional type, we replace a `string` with `infer R`, because we don’t know what must be there.
The only thing we know is that it is a `Promise<T>` with some type inside.

Once the TypeScript figures out the type inside the `Promise`, it will assign it to our type parameter `R` and becomes available in “true” branch.
Exactly where we return it:

```ts
type Awaited<T> = T extends Promise<infer R> ? R : T;
```

## References

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/advanced-types.html#conditional-types)
- [Type Inference in Conditional Types](https://www.typescriptlang.org/docs/handbook/advanced-types.html#type-inference-in-conditional-types)
