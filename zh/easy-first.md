---
id: 14
title: First of Array
lang: zh
level: easy
tags: array
---

## 挑战

实现一个泛型`First<T>`，接收一个数组`T`然后返回它的第一个元素的类型。

例如：

```ts
type arr1 = ["a", "b", "c"];
type arr2 = [3, 2, 1];

type head1 = First<arr1>; // expected to be 'a'
type head2 = First<arr2>; // expected to be 3
```

## 解答

首先我们想到的就是使用查询类型，然后写出`T[0]`：

```ts
type First<T extends any[]> = T[0];
```

但是这里有个临界情况我们需要去处理。如果我们传入一个空数组，`T[0]`不能正常工作，
因为它没有元素。

因此，在访问数组中的第一个元素之前，我们需要检查数组是否为空。为此，我们可以在
TypeScript 中使
用[条件类型](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)。

它们背后的理念非常简单。如果我们可以将该类型分配给条件类型，它将进入“true”分支，
否则它将采取“false”分支。

我们接下来检查，如果数组为空，则什么也不返回，否则返回数组的第一个元素:

```ts
type First<T extends any[]> = T extends [] ? never : T[0];
```

## 参考

- [Indexed Types](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
