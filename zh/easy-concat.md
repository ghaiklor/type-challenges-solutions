---
id: 533
title: Concat
lang: zh
level: easy
tags: array
---

## 挑战

在类型系统中实现 JavaScript 的`Array.concat`函数。它接收 2 个参数并将输入按顺序输出为一个新数组。

例如：

```ts
type Result = Concat<[1], [2]>; // expected to be [1, 2]
```

## 解法

在 TypeScript 中处理数组时，变参元组类型通常会在某些情况下发挥作用。他们允许我们进行泛型展开。稍后我会试着说明。

让我向你展示在 JavaScript 中连接两个数组的实现:

```js
function concat(arr1, arr2) {
  return [...arr1, ...arr2];
}
```

我们可以使用展开操作符将`arr1`中的所有元素放入另外一个数组中。我们可以对`arr2`进行同样的操作。这里的关键是，它迭代数组或元组中的元素，并将它们粘贴到使用展开操作符的地方。

可变元组类型允许我们在类型系统中建模相同的行为。
如果我们想要连接两个泛型数组，可以使用展开操作符返回合并后的新数组:

```ts
type Concat<T, U> = [...T, ...U];
```

我们遇到一个错误“A rest element type must be an array type.”。让我们来修复它并让编译器知道这些类型是数组：

```ts
type Concat<T extends unknown[], U extends unknown[]> = [...T, ...U];
```

## 参考

- [Variadic Tuple Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
