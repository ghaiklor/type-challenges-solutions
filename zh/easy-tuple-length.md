---
id: 18
title: Length of Tuple
lang: zh
level: easy
tags: tuple
---

## 挑战

对于给定的元组，你需要创建一个泛型`Length`类型，取得元组的长度。

例如：

```ts
type tesla = ["tesla", "model 3", "model X", "model Y"];
type spaceX = [
  "FALCON 9",
  "FALCON HEAVY",
  "DRAGON",
  "STARSHIP",
  "HUMAN SPACEFLIGHT"
];

type teslaLength = Length<tesla>; // expected 4
type spaceXLength = Length<spaceX>; // expected 5
```

## 解答

我们知道在 JavaScript 中可以使用属性`length`来访问数组的长度。我们也可以在类型上
做同样的事情:

```ts
type Length<T extends any> = T["length"];
```

但是按照这种方式，我们将得到编译错误“Type 'length' cannot be used to index type
'T'.”。所以我们需要给 TypeScript 一个提示，告知我们的输入类型参数有这个属性:

```ts
type Length<T extends { length: number }> = T["length"];
```

## 参考

- [Indexed Types](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)
