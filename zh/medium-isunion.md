---
id: 1097
title: IsUnion
lang: zh
level: medium
tags: union
---

## 挑战

实现一个类型`IsUnion`，它接受输入类型`T`，并返回`T`是否解析为联合类型。

例如：

```typescript
type case1 = IsUnion<string>; // false
type case2 = IsUnion<string | number>; // true
type case3 = IsUnion<[string | number]>; // false
```

## 解答

当我看到这样的挑战时，我总是感到沮丧。因为没有通用的解决方案可以用来实现这样的类
型，也没有可以使用的内置类型或`intrinsic`。

这样我们就必须创造性地结合我们所掌握的知识，我们首先思考联合类型及其代表的含义。

当你指定一个普通类型，例如`string`，它将永远是字符串。但是，当你指定一个联合类型
时，例如`string | number`，你可以从中取得一组潜在的值。

普通类型并不能表示一组值，但联合类型可以。在普通类型上进行分布式迭代是没有意义的
，但对于联合来说是有意义的。

这就是我们如何检测一个类型是否为联合类型所依赖的关键区别。当对类型`T`（不是联合
类型）进行分布式迭代时，它没有任何改变。但是，如果`T`是联合类型的话，它的变化会
很大。

TypeScript 有一个很棒的类型特性——分布式条件类型。当你编写这样的构造
：`T extends string ? true : false`，其中`T`是一个适用于分布式条件类型的联合类型
。粗略地说，这看起来就像将条件类型应用于联合类型中的每个元素。

```typescript
type IsString<T> = T extends string ? true : false;

// For example, we provide type T = string | number
// It is the same as this
type IsStringDistributive = string extends string
  ? true
  : false | number extends string
  ? true
  : false;
```

你明白我的意思了吧?如果类型`T`是一个联合类型，通过使用分布式条件类型，我们可以分
离该联合类型并将其与输入类型`T`进行比较。如果`T`不是一个联合类型，那么在这种情况
下，二者是一样的。但是，当它是一个联合类型时，它们二者的结果就不一样了，因
为`string`不是由`string | number` 扩展而来，当然`number`也不是。

让我们动手实现这个类型吧!首先，我们将复制输入类型 T，这样就可以保留 m 没有经过任
何修改的输入类型`T`，稍后我们将对它们进行比较。

```typescript
type IsUnion<T, C = T> = never;
```

通过应用条件类型，我们得到了分布式语义。在条件类型的 true 分支中，我们将获取联合
类型中的每一项。

```typescript
type IsUnion<T, C = T> = T extends C ? never : never;
```

现在是最重要的部分——将每一项与原来的输入类型`T`进行比较。在没有应用分布式迭代的
情况下(`T`不是联合类型)，`[C]`与`[T]`是相同的，因此为`false`。否则，`T`是一个联
合类型，因此将应用分配式迭代，将联合类型中的单项与联合类型本身进行比较，因此
为`true`。

```typescript
type IsUnion<T, C = T> = T extends C ? ([C] extends [T] ? false : true) : never;
```

齐活儿!

为了更清楚地阐述，接下向你展示 `[C]` 和 `[T]` 在分布式条件类型中`true`分支中代表
什么。

当我们传入的不是联合类型时，例如`string`，它们包含相同的类型。意思是，它不是联合
类型，因此返回`false`。

```typescript
[T] = [string][C] = [string];
```

但是，如果我们传入一个联合类型，例如`string | number`，它们包含不同的类型。我们
的副本`C`保存了一个内部有联合类型的元组类型，而我们的`T`保存了一个内部元素是元组
类型的联合类（这要归功于分布条件类型），因此它是一个联合类型。

```typescript
[T] = [string] | [number]
[C] = [string | number]
```

## 参考

- [Union Types](https://www.typescriptlang.org/docs/handbook/2/everyday-types.html#union-types)
- [Generics](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Distributive Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#distributive-conditional-types)
- [Tuple Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-1-3.html#tuple-types)
