---
id: 268
title: If
lang: zh
level: easy
tags: utils
---

## 挑战

实现一个工具`If`，它接受一个条件`C`，为真返回类型`T`，为假返回类型`F`。`C`期望值
为`true`或`false`，而`T`和`F`可以为任意类型。

例如：

```ts
type A = If<true, "a", "b">; // expected to be 'a'
type B = If<false, "a", "b">; // expected to be 'b'
```

## 解答

如果你不确定什么时候在 TypeScript 中使
用[条件类型](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)，
那就是你需要对类型使用“if”语句的时候。这正是我们这里要做的。

如果条件类型的计算结果为`true`，我们需要取“true”分支，否则“false”分支:

```ts
type If<C, T, F> = C extends true ? T : F;
```

这样我们会得到一个编译错误，因为我们试图将`C`赋值给布尔类型，而没有一个显式的约
束。因此，让我们通过在类型参数`C`中添加`extends boolean`来修复它:

```ts
type If<C extends boolean, T, F> = C extends true ? T : F;
```

## 参考

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
