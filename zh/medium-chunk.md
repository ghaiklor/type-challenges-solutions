---
id: 4499
title: Chunk
lang: zh
level: medium
tags: tuple
---

## 挑战

你知道 `loadsh` 吗？
`Chunk` 是其中一个非常有用的函数，现在我们来实现它。
`Chunk<T, N>` 接受两个必要类型参数，`T` 必须是一个元组，`N` 必须是大于等于 1 的整型。
比如说：

```typescript
type R0 = Chunk<[1, 2, 3], 2>; // expected to be [[1, 2], [3]]
type R1 = Chunk<[1, 2, 3], 4>; // expected to be [[1, 2, 3]]
type R2 = Chunk<[1, 2, 3], 1>; // expected to be [[1], [2], [3]]
```

## 解答

这个挑战是个难题。
但最后，依我看，我终于找到了一个很容易的解答。
我们从一个声明契约的初始类型开始：

```typescript
type Chunk<T, N> = any;
```

因为我们需要积累元组的块，所以有一个可选类型参数 `A` 来积累大小为 `N` 的块似乎是合理的。
默认情况下，类型参数 `A` 将是一个空元组：

```typescript
type Chunk<T, N, A extends unknown[] = []> = any;
```

有一个空的累加器，我们将用于一个临时的大块，我们可以开始将 `T` 分割成若干部分。
这些部分是元组的第一个元素和剩余的部分：

```typescript
type Chunk<T, N, A extends unknown[] = []> = T extends [infer H, ...infer T]
  ? never
  : never;
```

有部分元组 `T`，我们可以检查累加器的大小是否符合要求。
为了达到这个目的，我们在其类型上查询 `length` 属性。
这有效，因为我们对类型参数 `A` 有一个通用约束，它表示一个元组。

```typescript
type Chunk<T, N, A extends unknown[] = []> = T extends [infer H, ...infer T]
  ? A["length"] extends N
    ? never
    : never
  : never;
```

如果我们的累加器是空的或没有足够的项目，我们需要继续切分 `T` 直到累加器达到所需要的大小。
为了做到这一点，我们继续递归地调用 `Chunk` 类型，并建产一个新的累加器。
在这个累加器中，我们推送之前的 `A` 和 `T` 中的项目 `H`。

```typescript
type Chunk<T, N, A extends unknown[] = []> = T extends [infer H, ...infer T]
  ? A["length"] extends N
    ? never
    : Chunk<T, N, [...A, H]>
  : never;
```

递归调用继续进行，直到我们得到一种情况，即累加器的大小达到了所需的 `N`。
这正是我们的累加器 `A` 中的所有所有元素都有适当大小的情况下。
这是我们需要存储在结果中的第一个块。
所以我们返回一个新的元组，其中包含累加器：

```typescript
type Chunk<T, N, A extends unknown[] = []> = T extends [infer H, ...infer T]
  ? A["length"] extends N
    ? [A]
    : Chunk<T, N, [...A, H]>
  : never;
```

这样做，我们忽略了其余的元组 `T`。
所以我们需要对我们的结果 `[A]` 增加一个递归调用，以清除累加器并重新开始同样的过程：

```typescript
type Chunk<T, N, A extends unknown[] = []> = T extends [infer H, ...infer T]
  ? A["length"] extends N
    ? [A, Chunk<T, N>]
    : Chunk<T, N, [...A, H]>
  : never;
```

这个递归魔法一直持续到我们得到元组 `T` 中没有更多元素的情况。
在这种情况下，我们只需返回累加器中剩余的任何元素。
这样做的原因是，我们可能会遇到累加器的大小小于 `N` 的情况。
所以在这种情况下不返回累加器就意味着失去了这些项目。

```typescript
type Chunk<T, N, A extends unknown[] = []> = T extends [infer H, ...infer T]
  ? A["length"] extends N
    ? [A, Chunk<T, N>]
    : Chunk<T, N, [...A, H]>
  : [A];
```

还有一种情况是我们失去了 `H` 的元素。
这种情况是我们得到了所需大小的累加器，但忽略了推断出的 `H`。
我们的块失去了一些元素，这是不对的。
为了解决这个问题，我们需要在有一个大小为 `N` 的累加器时不要忘记 `H` 元素：

```typescript
type Chunk<T, N, A extends unknown[] = []> = T extends [infer H, ...infer T]
  ? A["length"] extends N
    ? [A, Chunk<[H, ...T], N>]
    : Chunk<T, N, [...A, H]>
  : [A];
```

这个解答解决了一些情况，这很棒。
然而，我们有一种情况，即对 `Chunk` 类型的递归调用返回元组中的元组（因为递归调用）。
为了克服这个问题，让我们给我们的 `Chunk<[H, ...T], N>` 添加一个展开。

```typescript
type Chunk<T, N, A extends unknown[] = []> = T extends [infer H, ...infer T]
  ? A["length"] extends N
    ? [A, ...Chunk<[H, ...T], N>]
    : Chunk<T, N, [...A, H]>
  : [A];
```

所以有的测试案例都通过了！
哈哈...除了一个空元组的边缘案例。
只是一个边缘案例，我们可以添加条件类型来检查它。
如果累加器在基本情况下变成了空的，我们就返回一个空元组。
否则，我们返回基本情况下的累加器：

```typescript
type Chunk<T, N, A extends unknown[] = []> = T extends [infer H, ...infer T]
  ? A["length"] extends N
    ? [A, ...Chunk<[H, ...T], N>]
    : Chunk<T, N, [...A, H]>
  : A[number] extends never
  ? []
  : [A];
```

这就是我们在类型系统中实现的 lodash 版本的 `.chunk()` 函数所需要的全部内容！

## 参考

- [Generics](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Generic Constraints](https://www.typescriptlang.org/docs/handbook/2/generics.html#generic-constraints)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Inferring within Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Variadic Tuple Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
- [Indexed Access Types](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)
