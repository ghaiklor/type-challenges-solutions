---
id: 5360
title: Unique
lang: zh
level: medium
tags: array
---

## 挑战

实现类型版本 `Lodash.uniq()`。`Unique<T>` 接收一个数组 `T`，返回去重后的列表。

```typescript
type Res = Unique<[1, 1, 2, 2, 3, 3]>; // expected to be [1, 2, 3]
type Res1 = Unique<[1, 2, 3, 4, 4, 5, 6, 7]>; // expected to be [1, 2, 3, 4, 5, 6, 7]
type Res2 = Unique<[1, "a", 2, "b", 2, "a"]>; // expected to be [1, "a", 2, "b"]
```

## 解答

在这个挑战中，我们需要在类型系统中实现lodash的 `.uniq()` 函数。
我们必须接受一个元组类型参数，过滤到重复的元素，只保留唯一的元素集合。

让我们从初始类型开始：

```typescript
type Unique<T> = any;
```

为了检测元素在元组中是否是唯一的，首先我们需要读取它。要做到这一点，我们将在条件类型中推断它。

不过，为了得到预期的结果，我们需要按照相反的顺序进行。如果我们通过 `[infer H, ...infer T]` 的方式，我们的结果的顺序将会是错的。因此我们先取得最后的元素，将其它的元素放在其头部：

```typescript
type Unique<T> = T extends [...infer H, infer T] ? never : never;
```

现在我们得到了元素 `T`，我们应该检测什么呢？我们需要检测元素 `T` 是否存在于元组的其余部分（头部）中：

```typescript
type Unique<T> = T extends [...infer H, infer T]
  ? T extends H[number]
    ? never
    : never
  : never;
```

通过条件类型 `T extends H[number]`，我们可以检测类型 `T` 是否存在于 `H` 中。如果存在则意味着重复，我们需要跳过它。也就是说我们只返回头部元素：

```typescript
type Unique<T> = T extends [...infer H, infer T]
  ? T extends H[number]
    ? [...Unique<H>]
    : never
  : never;
```

如果不存在于头部（`H`）中，就说明它是唯一的。我们返回的元组需要包含它：

```typescript
type Unique<T> = T extends [...infer H, infer T]
  ? T extends H[number]
    ? [...Unique<H>]
    : [...Unique<H>, T]
  : never;
```

最后一种情况是输入类型 `T` 与元组不匹配。
这里我们只需要返回一个空元组，以避免在递归调用中中断展开操作：

```typescript
type Unique<T> = T extends [...infer H, infer T]
  ? T extends H[number]
    ? [...Unique<H>]
    : [...Unique<H>, T]
  : [];
```

这样，我们实现了一个可以返回唯一元素的类型。

## 参考

- [Generics](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Inferring within Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Recursive Conditional Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
