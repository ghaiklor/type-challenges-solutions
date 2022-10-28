---
id: 533
title: Concat
lang: ja
level: easy
tags: array
---

## 課題

JavaScript の `Array.concat` 関数を型システムにおいて実装してください。この型は
2 つの配列を引数に取り、入力の各要素を左から順に含む新しい配列を出力します。

例:

```ts
type Result = Concat<[1], [2]>; // expected to be [1, 2]
```

## 解答

TypeScript において配列を扱う際、Variadic Tuple 型が役に立つことが多くあります。
これによりジェネリックなスプレッドが可能になります。以下でそのことについて説明し
ていきます。

JavaScript で 2 つの配列を連結する実装を見てみましょう:

```js
function concat(arr1, arr2) {
  return [...arr1, ...arr2];
}
```

スプレッド構文により、`arr1` からすべての要素を取り出し、別の配列に展開すること
ができます。同様のことは `arr2` に対しても適用可能です。ここで重要なことは、スプ
レッド構文が使われる場所に配列やタプルの各要素を走査して展開するということです。

Variadic Tuple 型を使うことで、型システムにおいても同様の挙動をモデル化すること
ができます。2 つのジェネリックな配列を連結したい場合、スプレッド構文の後ろに両配
列を置いた新しい配列を返すことができます:

```ts
type Concat<T, U> = [...T, ...U];
```

まだ A rest element type must be an array type. というエラーが出てしまいますが、
これは引数の型が配列であるとコンパイラに伝えることで解決できます:

```ts
type Concat<T extends unknown[], U extends unknown[]> = [...T, ...U];
```

## 参考

- [Variadic Tuple Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
