---
id: 5117
title: Without
lang: zh
level: medium
tags: union array
---

## 挑战

实现 lodash `.without()` 的类型版本。 `Without<T, U>` 参数 `T` 为数组、参数 `U`
为数字或数组，返回一个不包含`U`元素的数组。

```typescript
type Res = Without<[1, 2], 1>; // expected to be [2]
type Res1 = Without<[1, 2, 4, 1, 5], [1, 2]>; // expected to be [4, 5]
type Res2 = Without<[2, 3, 2, 3, 2, 3, 2, 3], [2, 3]>; // expected to be []
```

## 解答

这个挑战确实很有趣。我们需要实现该类型，可以从元组中过滤出元素。我们从初始类型开
始：

```typescript
type Without<T, U> = any;
```

因为我们需要处理元组中的特定元素，我使用类型推导获取特定元素和其余部分：

```typescript
type Without<T, U> = T extends [infer H, ...infer T] ? never : never;
```

元素是否来自元组，我们可以检查该元素是否为 `U` 类型。我们需要这个检查以确定是否
应该将该元素添加到结果中：

```typescript
type Without<T, U> = T extends [infer H, ...infer T]
  ? H extends U
    ? never
    : never
  : never;
```

如果它 “extends” 于输入类型 `U`，就表明着我们结果中不需要它。于是我们跳过它，返
回不含它的元组。但是，因为我们需要处理其它元素，我们不会返回一个空元组，而是返回
通过递归调用 `Without` 后的元组：

```typescript
type Without<T, U> = T extends [infer H, ...infer T]
  ? H extends U
    ? [...Without<T, U>]
    : never
  : never;
```

这样我们就在 `T` 中跳过了所有通过 `U` 指定的元素。然而，一旦我们检测到不应该跳过
该元素，我们就返回包含这个元素的元组：

```typescript
type Without<T, U> = T extends [infer H, ...infer T]
  ? H extends U
    ? [...Without<T, U>]
    : [H, ...Without<T, U>]
  : never;
```

我们还需要处理最后一个 `never` 类型。因为我们处理可变元组类型（variadic tuple
types）并展开它，我们必须返回一个空元组而非 `never`：

```typescript
type Without<T, U> = T extends [infer H, ...infer T]
  ? H extends U
    ? [...Without<T, U>]
    : [H, ...Without<T, U>]
  : [];
```

当 `U` 为基本类型时，我们得到了一个有效的方案。但是，这个挑战中还有一种情况是它
可以是数字元组。为了支持这个情况，我们可以将 `H extends U` 中的类型 `U` 继续扩展
，通过条件类型继续检测。

如果 `U` 是一个数字元组，我们以联合（union）的方式返回所有元素，否则就原样返回：

```typescript
type Without<T, U> = T extends [infer H, ...infer T]
  ? H extends (U extends number[] ? U[number] : U)
    ? [...Without<T, U>]
    : [H, ...Without<T, U>]
  : [];
```

恭喜！我们实现了 lodash `.without()` 的类型版本。

## 参考

- [Generics](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Inferring within Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Recursive Conditional Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
