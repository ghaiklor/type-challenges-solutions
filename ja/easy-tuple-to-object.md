---
id: 11
title: Tuple to Object
lang: ja
level: easy
tags: tuple
---

## 課題

配列が与えられたとき、配列の各要素をキーと値とするオブジェクト型に変換してください。

例:

```ts
const tuple = ["tesla", "model 3", "model X", "model Y"] as const;

// expected { tesla: 'tesla', 'model 3': 'model 3', 'model X': 'model X', 'model Y': 'model Y'}
const result: TupleToObject<typeof tuple>;
```

## 解答

配列のすべての値を取り出し、新しいオブジェクトのキーと値とする必要があります。

これは Indexed Access 型を使用することがわかれば簡単です。`T[number]` により配列から値を取り出し、さらに Mapped 型 を用いて `T[number]` に含まれる値を走査することで、`T[number]` の型をキーと値とする新しい型を返すことができます:

```ts
type TupleToObject<T extends readonly PropertyKey[]> = { [K in T[number]]: K };
```

## 参考

- [Mapped Types](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
- [Indexed Types](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)
