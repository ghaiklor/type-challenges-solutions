---
id: 1130
title: ReplaceKeys
lang: zh
level: medium
tags: object-keys
---

## 挑战

实现一个类型`ReplaceKeys`，替换联合类型中的键，如果某个类型没有这个键，只需跳过
替换。该类型有三个参数。例如:

```typescript
type NodeA = {
  type: "A";
  name: string;
  flag: number;
};

type NodeB = {
  type: "B";
  id: number;
  flag: number;
};

type NodeC = {
  type: "C";
  name: string;
  flag: number;
};

type Nodes = NodeA | NodeB | NodeC;

// would replace name from string to number, replace flag from number to string
type ReplacedNodes = ReplaceKeys<
  Nodes,
  "name" | "flag",
  { name: number; flag: string }
>;

// would replace name to never
type ReplacedNotExistKeys = ReplaceKeys<Nodes, "name", { aa: number }>;
```

## 解答

有一个由多个接口组成的联合类型，我们需要对它们进行迭代，并替换其中的键。分布式和
映射类型在这里肯定会有帮助。

首先要说明的是，TypeScript 中的映射类型也是分布式的。这意味着我们可以开始编写映
射类型来遍历接口的键，同时对联合类型具有分布性。但是，欲速则不达，我会稍稍解释一
下。

显然我们可以编写一个接受联合类型的条件类型，它将遍历联合类型的元素，它在之前的其
他挑战中帮助了我们很多。每次你写下形如`U extends any ? U[] : never`的代码时，实
际发生的是在每次迭代中`U`从真值分支中的联合类型`U`变成一个元素。

这同样适用于映射类型。我们可以编写一个映射类型，它迭代类型形参的键，实际发生的是
迭代联合类型的单个元素，而不是整个联合类型。

我们从最简单的开始。从联合类型`U`中取出所有元素(感谢分布性)，对每个元素遍历其键
并返回一个副本。

```typescript
type ReplaceKeys<U, T, Y> = { [P in keyof U]: U[P] };
```

这样我们就得到了所有类型参数`U`的键的副本。现在，我们需要过滤掉`T` 和`Y`中的键。

首先，我们将检查当前所在的属性是否在要更新的键列表中(在类型参数`T`中)。

```typescript
type ReplaceKeys<U, T, Y> = {
  [P in keyof U]: P extends T ? never : never;
};
```

如果是的话，这意味着开发人员要求更新对应的键，并提供了替换类型。但我们不能确定对
应的键是否存在。因此我们需要检查在`Y`中是否存在相同的键。

```typescript
type ReplaceKeys<U, T, Y> = {
  [P in keyof U]: P extends T ? (P extends keyof Y ? never : never) : never;
};
```

如果两个条件都为真，这意味着我们知道要替换的键和键的类型。所以我们返回在`Y`中指
定的类型。

```typescript
type ReplaceKeys<U, T, Y> = {
  [P in keyof U]: P extends T ? (P extends keyof Y ? Y[P] : never) : never;
};
```

但是，如果在类型参数`T`中有一个键需要更新，但是在类型参数`Y`中没有，我们需要返
回`never`(根据挑战规范)。最后一种情况是，在`T`和`Y`中都没有这样的键，在这种情况
下，我们只需要跳过替换，返回原始接口中的对应类型。

```typescript
type ReplaceKeys<U, T, Y> = {
  [P in keyof U]: P extends T ? (P extends keyof Y ? Y[P] : never) : U[P];
};
```

使用分布式映射类型确实可以获得可读性更强的解决方案。如果没有它们的话,我们将不得
不使用条件类型，并在`true`分支中使用映射类型遍历`U`。

## 参考

- [Mapped Types](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Indexed Access Types](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)
