---
id: 3060
title: Unshift
lang: zh
level: easy
tags: array
---

## 挑战

实现类型版本`Array.unshift()`。

例如：

```typescript
type Result = Unshift<[1, 2], 0>; // [0, 1, 2]
```

## 解答

这个挑战和[Push challenge](./easy-push.md)有很多相似之处。在这里，我们使用可变元
组类型（Variadic Tuple Types）来获取数组中的所有元素。

这里我们做的差不多，但顺序不同。首先，让我们从传入的数组中获取所有元素:

```typescript
type Unshift<T, U> = [...T];
```

在这段代码中，我们得到了编译错误“A rest element type must be an array type”。让
我们通过在类型参数上添加一个约束来修正这个错误:

```typescript
type Unshift<T extends unknown[], U> = [...T];
```

现在，我们有了与传入的数组相同的数组。我们只需要在元组的开头添加一个元素。让我们
这样做:

```typescript
type Unshift<T extends unknown[], U> = [U, ...T];
```

这样，我们在类型系统中创建了一个“unshift”函数!

## 参考

- [Generics](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Generic Constraints](https://www.typescriptlang.org/docs/handbook/2/generics.html#generic-constraints)
- [Variadic Tuple Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
