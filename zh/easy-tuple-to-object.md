---
id: 11
title: Tuple to Object
lang: zh
level: easy
tags: tuple
---

## 挑战

将给定的数组转换为对象类型，键/值必须在给定数组中。

例如：

```ts
const tuple = ["tesla", "model 3", "model X", "model Y"] as const;

// expected { tesla: 'tesla', 'model 3': 'model 3', 'model X': 'model X', 'model Y': 'model Y'}
const result: TupleToObject<typeof tuple>;
```

## 解答

我们需要从数组中获取所有的值，并将其作为新对象中的键和值。

这个使用索引类型很容易。我们可以通过使用`T[number]`从数组中获取值。在映射类型的
帮助下，我们可以迭代`T[number]`中的这些值，并返回一个新的类型，其中键和值
是`T[number]`的类型:

```ts
type TupleToObject<T extends readonly (string | number | symbol)[]> = { [K in T[number]]: K };
```

## 参考

- [Mapped Types](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
- [Indexed Types](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)
