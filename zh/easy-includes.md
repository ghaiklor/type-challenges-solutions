---
id: 898
title: Includes
lang: zh
level: easy
tags: array
---

## 挑战

在类型系统种实现 JavaScript 的`Array.includes`函数，接收 2 个参数。
它的输出应该是布尔类型`true`或`false`。
例如：

```typescript
// expected to be `false`
type isPillarMen = Includes<["Kars", "Esidisi", "Wamuu", "Santana"], "Dio">;
```

## 解法

我们首先编写接受两个参数的类型:`T`(元组)和`U`(我们正在寻找的)。

```typescript
type Includes<T, U> = never;
```

在我们真正能在元组中找到一些东西之前，将其“转换”为联合（union）比会元组（tuple）更容易一些。
为此，我们可以使用索引类型（indexed types）。如果我们访问`T[number]`，TypeScript 会返回`T`中所有元素的联合（union）。
例如，如果你有一个`T = [1, 2, 3]`，通过`T = [1, 2, 3]`访问将返回`1 | 2 | 3`。

```typescript
type Includes<T, U> = T[number];
```

但是，这里有一个错误，“Type ‘number’ cannot be used to index type ‘T’”。这是因为类型`T`没有约束。我们需要告诉 TypeScript，`T`是一个数组。

```typescript
type Includes<T extends unknown[], U> = T[number];
```

我们有了元素的联合（union）。我们如何检查元素是否存在于联合（union）中？条件类型分配（Distributive）!我们可以为联合（union）编写条件类型，TypeScript 会自动将条件应用到联合（union）的每个元素上。

例如，如果你写`2 extends 1 | 2`，TypeScript 实际上会把它替换成 2 个条件语句`2 extends 1`和`2 extends 2`。

我们可以利用它检查`U`是否在`T[number]`中，如果在则返回 true。

```typescript
type Includes<T extends unknown[], U> = U extends T[number] ? true : false;
```

## 参考

- [Generics](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Generic Constraints](https://www.typescriptlang.org/docs/handbook/2/generics.html#generic-constraints)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Distributive Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#distributive-conditional-types)
- [Index Types](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)
