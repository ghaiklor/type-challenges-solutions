---
id: 191
title: Append Argument
lang: zh
level: medium
tags: arguments
---

## 挑战

对于给定的函数类型`Fn`和任何类型`A`（在此上下文中,任何类型意味着我们不限制类型，
并且我不考虑任何类型）创建一个将`Fn`作为第一个参数，`A`作为第二个参数的泛型函
数，将生成函数类型`G`，它与`Fn`相同，但附加参数`A`作为最后一个参数。

例如:

```ts
type Fn = (a: number, b: string) => number;

// 期待结果为 (a: number, b: string, x: boolean) => number
type Result = AppendArgument<Fn, boolean>;
```

## 解答

这是一个有趣的挑战, 其中包含了类型推断，可变元组类型，条件类型以及其他很多有趣的
东西。

让我们从推断函数参数及其返回类型开始, 条件类型将帮助我们完成这点。一旦类型被推断
出来，我们可以返回我们自己输入的函数签名，例如:

```ts
type AppendArgument<Fn, A> = Fn extends (args: infer P) => infer R
  ? (args: P) => R
  : never;
```

显然, 目前的答案还没达到我们想要的结果. 为什么呢? 因为我们检查了 `Fn` 是否可以赋
值给具有单个参数 `args` 的函数。这并不合理，我们可以有多个参数或没有参数的函数。

为了解决这个问题，我们可以使用展开参数：

```ts
type AppendArgument<Fn, A> = Fn extends (...args: infer P) => infer R
  ? (args: P) => R
  : never;
```

现在，条件类型中的条件求值为真，因此进入带有类型参数`P`（函数参数）和类型参
数`R`（返回类型）的`真`分支。虽然如此，目前方案还是有问题。类型参数 `P` 有一个带
有函数参数的元组，但我们需要将它们视为单独的参数。通过应用可变元组类型，我们可以
展开元组:

```ts
type AppendArgument<Fn, A> = Fn extends (...args: [...infer P]) => infer R
  ? (args: P) => R
  : never;
```

类型参数`P`有我们现在需要的。唯一剩下的事情就是从推断的类型中构造出新的函数签名:

```ts
type AppendArgument<Fn, A> = Fn extends (...args: [...infer P]) => infer R
  ? (...args: [...P]) => R
  : never;
```

我们有一个类型，它接受一个输入函数并返回一个具有推断类型的新函数。有了它，我们现
在可以将所需的 `A` 参数添加到参数列表中:

```ts
type AppendArgument<Fn, A> = Fn extends (...args: [...infer P]) => infer R
  ? (...args: [...P, A]) => R
  : never;
```

## 参考

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Type inference in conditional types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Variadic Tuple Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
- [Rest parameters in function type](https://www.typescriptlang.org/docs/handbook/2/functions.html#rest-parameters-and-arguments)
