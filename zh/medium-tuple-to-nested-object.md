---
id: 3188
title: Tuple to Nested Object
lang: zh
level: medium
tags: array
---

## 挑战

给定一个只包含字符串类型的元组 `T` 和一个类型 `U`，递归的构建一个对象。

```ts
type a = TupleToNestedObject<["a"], string>; // {a: string}
type b = TupleToNestedObject<["a", "b"], number>; // {a: {b: number}}
type c = TupleToNestedObject<[], boolean>; // boolean. if the tuple is empty, just return the U type
```

## 解答

让我们首先通过推断其内容来迭代元组。

```ts
type TupleToNestedObject<T, U> = T extends [infer F, ...infer R]
  ? never
  : never;
```

如果 `T` 为空呢？在这种情况下，我们按原样返回类型 `U`。

```ts
type TupleToNestedObject<T, U> = T extends [infer F, ...infer R] ? never : U;
```

由于 `object` 的键值只能是 `string` 类型，我们需要检测 `F` 是否为 `string`。

```ts
type TupleToNestedObject<T, U> = T extends [infer F, ...infer R]
  ? F extends string
    ? never
    : never
  : U;
```

如果 `F` 是 `string` 类型，我们想要创建一个 `object` 并递归的遍历剩余的元组。
这样我们就遍历整个元组并创建了嵌套对象。当遍历到最后一个元素，我们返回类型 `U`。

```ts
type TupleToNestedObject<T, U> = T extends [infer F, ...infer R]
  ? F extends string
    ? { [P in F]: TupleToNestedObject<R, U> }
    : never
  : U;
```

## 参考

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Inferring within Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Recursive Conditional Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
