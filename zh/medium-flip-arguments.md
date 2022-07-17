---
id: 3196
title: Flip Arguments
lang: zh
level: medium
tags: array
---

## 挑战

在类型系统中实现 Lodash 的 `_.flip` 方法。

类型 `FlipArguments<T>` 需接收函数类型 `T` 并返回新的函数类型。新函数类型应与 `T` 的返回类型相同，但函数参数是倒序的。

例如：

```ts
type Flipped = FlipArguments<
  (arg0: string, arg1: number, arg2: boolean) => void
>;
// (arg0: boolean, arg1: number, arg2: string) => void
```

## 解答

这个挑战的解法并不复杂。首先我们需要判断类型 `T` 是否为函数类型；如果是，则仅需翻转函数的参数类型，即可完成挑战。

```ts
type FlipArguments<T> = T extends (...args: [...infer P]) => infer R
  ? never
  : never;
```

在上述代码中，我们从函数类型中获取参数类型，记为 `P`；同时获取返回类型，记为 `R`。
接下来我们翻转参数，并保持最终的函数返回类型为 `R`：

```ts
type MyReverse<T extends unknown[]> = T extends [...infer F, infer S]
  ? [S, ...MyReverse<F>]
  : [];

type FlipArguments<T> = T extends (...args: [...infer P]) => infer R
  ? (...args: MyReverse<P>) => R
  : never;
```

## 参考

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Type inference in conditional types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
