---
id: 5317
title: LastIndexOf
lang: zh
level: medium
tags: array
---

## 挑战

在类型系统中实现 `Array.lastIndexOf`。 `LastIndexOf<T, U>` 接收一个数组 `T` 和查
找项 `U` ，并且返回 `U` 在数组 `T` 中最后一次出现位置的索引，例如：

```typescript
type Res1 = LastIndexOf<[1, 2, 3, 2, 1], 2>; // 3
type Res2 = LastIndexOf<[0, 0, 0], 2>; // -1
```

## 解答

要找到元素在元组中最后一次出现位置的索引，只需要从右往左枚举元组项直至找到匹配
项。然后获取匹配项的索引。听起来很简单，让我们开始吧。

像往常一样，我们从一个空白类型开始:

```typescript
type LastIndexOf<T, U> = any;
```

在这个类型中，我们有 `T` 和 `U` 两个泛型，`T` 是元组，`U` 是我们要查找的项。让我
们从条件类型开始，我们将元组推断为两个部分。一部分是最后一项（`I`），另一部分是
前面的剩余项（`R`）：

```typescript
type LastIndexOf<T, U> = T extends [...infer R, infer I] ? never : never;
```

一旦我们推断出最右侧的项，我们就可以检查它是否和我们要查找的项相等。我们可以使用
一个内置的工具类型 `Equal` 来协助我们完成检查：

```typescript
type LastIndexOf<T, U> = T extends [...infer R, infer I]
  ? Equal<I, U> extends true
    ? never
    : never
  : never;
```

如果找到了匹配项意味着什么呢？意味着我们找到了要查找的项，但是如何获取其索引呢？
左侧剩余项元组的长度，正好就是我们需要的索引，是吗？所以我们使用左侧剩余项元组的
长度当做索引：

```typescript
type LastIndexOf<T, U> = T extends [...infer R, infer I]
  ? Equal<I, U> extends true
    ? R["length"]
    : never
  : never;
```

如果找不到匹配项，我们就继续递归寻找下去：

```typescript
type LastIndexOf<T, U> = T extends [...infer R, infer I]
  ? Equal<I, U> extends true
    ? R["length"]
    : LastIndexOf<R, U>
  : never;
```

最后，如果仍然没有找到匹配项，则返回 `-1` 作为答案：

```typescript
type LastIndexOf<T, U> = T extends [...infer R, infer I]
  ? Equal<I, U> extends true
    ? R["length"]
    : LastIndexOf<R, U>
  : -1;
```

## 参考

- [Generics](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Inferring within Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Indexed Access Types](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)
- [Recursive Conditional Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
- [Variadic Tuple Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
