---
id: 16
title: Pop
lang: zh
level: medium
tags: array
---

## 挑战

实现一个通用的 `Pop<T>`，它接受一个数组 `T` 并返回一个没有最后一个元素的数组。

例如：

```ts
type arr1 = ["a", "b", "c", "d"];
type arr2 = [3, 2, 1];

type re1 = Pop<arr1>; // expected to be ['a', 'b', 'c']
type re2 = Pop<arr2>; // expected to be [3, 2]
```

## 解答

我们需要将数组分成两部份：从头部到最后一个元素之前的所有内容和最后一个元素本身。
之后，我们就可以去掉最后一个元素并返回头部部分了。

为此，我们可以使用 [variadic tuple types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)。
结合 [type inference in conditional types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)，我们可以推断出需要的部分：

```ts
type Pop<T extends any[]> = T extends [...infer H, infer T] ? H : never;
```

如果 `T` 是可分配给可分成两部分的数组类型的，则我们返回除最后一个以外的所有内容，否则返回 `never`。

## 参考

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Type inference in conditional types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Variadic Tuple Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
