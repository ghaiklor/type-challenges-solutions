---
id: 3057
title: Push
lang: zh
level: easy
tags: array
---

## 挑战

实现泛型版本的`Array.push`。
例如：

```typescript
type Result = Push<[1, 2], '3'> // [1, 2, '3']
```

## 解法

这个实际上很简单。
要实现一个将元素插入数组的类型，我们需要做2件事。
第一件事是获取数组的所有元素，第二件事是向它们插入一个额外的元素。

要从数组中获取所有元素，可以使用可变参数元组类型。
因此，让我们返回一个具有输入类型`T`中相同元素的数组:

```typescript
type Push<T, U> = [...T]
```

得到一个编译错误“A rest element type must be an array type”。
这意味着我们不能在非数组类型上使用可变元组类型。
因此，让我们添加一个通用的约束来表明我们只处理数组:

```typescript
type Push<T extends unknown[], U> = [...T]
```

现在，我们有一个类型参数`T`传入的数组副本。
剩下的就是添加传入的元素`U`:

```typescript
type Push<T extends unknown[], U> = [...T, U]
```

这样，我们就在类型系统中实现了一个push操作。

## 参考

- [Generics](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Variadic Tuple Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
