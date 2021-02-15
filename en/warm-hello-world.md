---
id: 13
title: Hello, World
lang: en
level: warm
tags: warm-up
---

## Challenge

In Type Challenges, we use the type system itself to do the assertion.

For this challenge, you will need to change the following code to make the tests pass (no type check errors).

```ts
// expected to be string
type HelloWorld = any
```

```ts
// you should make this work
type test = Expect<Equal<HelloWorld, string>>
```

## Solution

This challenge is a warm-up challenge to get familiar with their playground, how to take challenges and other stuff.
All we asked to do here is literally to set the type of `string` instead of `any`:

```ts
type HelloWorld = string
```

## References

- [Typed JavaScript at Any Scale](https://www.typescriptlang.org)
- [The TypeScript Handbook](https://www.typescriptlang.org/docs/handbook/intro.html)
- [TypeScript for Java/C# Programmers](https://www.typescriptlang.org/docs/handbook/typescript-in-5-minutes-oop.html)
- [TypeScript for Functional Programmers](https://www.typescriptlang.org/docs/handbook/typescript-in-5-minutes-func.html)
