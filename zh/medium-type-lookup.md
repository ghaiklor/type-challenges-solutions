---
id: 62
title: Type Lookup
lang: zh
level: medium
tags: union map
---

## 挑战

有时，你可能想要根据联合类型中的属性查找类型。

在这个挑战中，我们想要在联合类型`Cat | Dog`中通过查找通用的`type`字段获得相应的类型。

换句话说，在接下来的例子中我们希望通过`LookUp<Dog | Cat, 'dog'>`得到`Dog`类型，通过`LookUp<Dog | Cat, 'cat'>` 得到`Cat`类型。

```ts
interface Cat {
  type: "cat";
  breeds: "Abyssinian" | "Shorthair" | "Curl" | "Bengal";
}

interface Dog {
  type: "dog";
  breeds: "Hound" | "Brittany" | "Bulldog" | "Boxer";
  color: "brown" | "white" | "black";
}

type MyDogType = LookUp<Cat | Dog, "dog">; // expected to be `Dog`
```

## 解答

一开始我以为现在这个解答将会有着大量的解释说明，但事实证明并没有什么与众不同。

我们知道可以利用TypeScript中的[条件类型](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-8.html#conditional-types)来检查类型是否可分配给某些特定布局（如果我可以这么说的话）。

然后让我们来检查`U`是否可以赋值给`{ type: T }`：

```ts
type LookUp<U, T> = U extends { type: T } ? U : never;
```

顺便提一下，值得注意的是，条件类型在TypeScript中是分布式的，因此联合类型中的每个成员都将按照我们的条件进行检查。

## 参考

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Distributive Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#distributive-conditional-types)
