---
id: 3057
title: Push
lang: ja
level: easy
tags: array
---

## 課題

ジェネリクスにより `Array.push` を実装してください。

例:

```typescript
type Result = Push<[1, 2], "3">; // [1, 2, '3']
```

## 解答

これは簡単です。配列に要素を追加する型を実装するためには、2 つのことをおこなう必
要があります。配列のすべての要素を取得することと、そこに新たな要素を追加すること
です。

配列のすべての要素を取得するためには、Variadic Tuple 型を使用します。入力された
型 `T` と同じ要素を持つ配列を返してみましょう:

```typescript
type Push<T, U> = [...T];
```

A rest element type must be an array type というコンパイルエラーが出ます。これ
は、Variadic Tuple 型を配列でない型に適用することはできないということを意味しま
す。配列のみを取り扱うことを示すために、ジェネリクスに関する制約を追加しましょ
う:

```typescript
type Push<T extends unknown[], U> = [...T];
```

これで、入力された配列のコピーが型変数 `T` に入ります。残るのは `U` の要素を追加
することだけです:

```typescript
type Push<T extends unknown[], U> = [...T, U];
```

以上により、型システムにおいて push 演算を実装することができました。

## 参考

- [Generics](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Variadic Tuple Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
