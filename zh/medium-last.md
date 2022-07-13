---
id: 15
title: Last of Array
lang: zh
level: medium
tags: array
---

## 挑战

实现一个通用的 `Last<T>`，它接受一个数组 `T` 并返回它的最后一个元素的类型。

例如：

```ts
type arr1 = ["a", "b", "c"];
type arr2 = [3, 2, 1];

type tail1 = Last<arr1>; // expected to be 'c'
type tail2 = Last<arr2>; // expected to be 1
```

## 解答

当你想从数组中获取最后一个元素时，你需要从头开始获取所有元素，直到找到最后一个元
素。这里提示使用
[variadic tuple types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)；
我们有一个数组，我们需要处理它的元素。

了解了可变元组类型，解答也就非常明显了。我们需要将数组中除最后一个元素的其余元素
排除出去。结合
[type inference in conditional types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
可以很容易的推断出最后一个元素的类型了。

```ts
type Last<T extends any[]> = T extends [...infer X, infer L] ? L : never;
```

## 参考

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Type inference in conditional types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Variadic Tuple Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
