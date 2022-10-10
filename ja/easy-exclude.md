---
id: 43
title: Exclude
lang: ja
level: easy
tags: built-in
---

## 課題

`U` に割り当て可能な型を `T` から除外する、組み込みの `Exclude<T, U>` を実装してください。

例:

```ts
type T0 = Exclude<"a" | "b" | "c", "a">; // expected "b" | "c"
type T1 = Exclude<"a" | "b" | "c", "a" | "b">; // expected "c"
```

## 解答

ここで重要な知識は、TypeScript の Conditional 型が [distributive](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#distributive-conditional-types) であるということです。

これにより、`T` が Union 型である場合に `T extends U` と書くと、TypeScript は Union 型 `T` の各要素に対して条件を適用していきます。

よって、解決策はとてもシンプルなものとなります。`T` が `U` に割り当て可能である場合、その要素をスキップすればよいのです:

```ts
type MyExclude<T, U> = T extends U ? never : T;
```

## 参考

- [Distributive Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#distributive-conditional-types)
