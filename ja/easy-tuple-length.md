---
id: 18
title: Length of Tuple
lang: ja
level: easy
tags: tuple
---

## 課題

タプルが与えられたとき、そのタプルの長さを返すような `Length` を実装してください。

例:

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

JavaScript では `length` プロパティを使用して配列の長さにアクセスできることをご存知でしょう。型においても同様のことが可能です:

```ts
type Length<T extends any> = T["length"];
```

しかし、この方法では Type 'length' cannot be used to index type 'T' というコンパイルエラーが発生してしまいます。そのため、型変数がこのプロパティをもっていることを TypeScript に伝えておく必要があります:

```ts
type Length<T extends { length: number }> = T["length"];
```

## 参考

- [Indexed Types](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)
