---
id: 2
title: Get Return Type
lang: zh
level: medium
tags: infer built-in
---

## 挑战

不使用 ReturnType 实现 TypeScript 的 `ReturnType<T>` 泛型。

例如：

```ts
const fn = (v: boolean) => {
  if (v) return 1;
  else return 2;
};

type a = MyReturnType<typeof fn>; // should be "1 | 2"
```

## 解答

在[条件类型中使用类型推导](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)的经验法则是当你不确定类型必须是什么的时候。
这正好适用本次挑战的情况。
我们不知道函数所返回的类型，但是我们的任务是获取它。

我们有一个在类型系统中看起来为 `() => void` 的函数。
但是我们不知道 `void` 的位置必须是什么。
所以让我们用`infer R`替换它，这将是我们对解决方案的第一次迭代：

```ts
type MyReturnType<T> = T extends () => infer R ? R : T;
```

如果我们的类型 `T` 可以分配给函数，我们推断它的返回类型并将其返回，否则我们返回 `T` 本身。
比较直截了当。

这个解决方案的问题是，如果我们传递一个带参数的函数，它将不能分配给我们的类型 `() => infer R`。

让我们通过添加 `...args: any[]` 来表明我们可以接受任何参数并且我们不关心它们：

```ts
type MyReturnType<T> = T extends (...args: any[]) => infer R ? R : T;
```

## References

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Type inference in conditional types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
