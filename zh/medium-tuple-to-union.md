---
id: 10
title: Tuple to Union
lang: zh
level: medium
tags: infer tuple union
---

## 挑战

实现泛型`TupleToUnion<T>`，它返回由元组所有值组成的联合类型。

例如:

```ts
type Arr = ["1", "2", "3"];

const a: TupleToUnion<Arr>; // expected to be '1' | '2' | '3'
```

## 解答

我们需要获取一个数组中的所有元素并将其转化为联合类型。幸运的是，TypeScript 已经在其类型系统中实现了这种功能—— [lookup types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-1.html#keyof-and-lookup-types)。我们可以使用构造`T[number]`得到由`T`的所有元素所组成的联合类型。

```ts
type TupleToUnion<T> = T[number];
```

但是，我们得到了一个 `error`: `Type ‘number’ cannot be used to index type ‘T’`。这时因为我们没有向`T`施加约束，即没有告知编译器`T`是一个可以被索引的数组。

让我们通过添加`extends unknown[]`解决这个问题。

```ts
type TupleToUnion<T extends unknown[]> = T[number];
```

## 参考

- [Lookup Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-1.html#keyof-and-lookup-types)

