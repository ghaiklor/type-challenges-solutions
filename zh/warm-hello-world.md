---
id: 13
title: Hello, World
lang: zh
level: warm
tags: warm-up
---

## 挑战

在 Type Challenges，我们使用类型系统自身去做断言。

在这个挑战中，你需要改变下面的代码使它能够通过测试（没有类型检查错误）。

```ts
// expected to be string
type HelloWorld = any;
```

```ts
// you should make this work
type test = Expect<Equal<HelloWorld, string>>;
```

## 解答

这是一个热身挑战，让你熟悉他们的练习场，如何接受挑战等等。
我们在这里需要做的只是将类型设置为' string '替代原来的' any ':

```ts
type HelloWorld = string;
```

## 参考

- [Typed JavaScript at Any Scale](https://www.typescriptlang.org)
- [The TypeScript Handbook](https://www.typescriptlang.org/docs/handbook/intro.html)
- [TypeScript for Java/C# Programmers](https://www.typescriptlang.org/docs/handbook/typescript-in-5-minutes-oop.html)
- [TypeScript for Functional Programmers](https://www.typescriptlang.org/docs/handbook/typescript-in-5-minutes-func.html)
