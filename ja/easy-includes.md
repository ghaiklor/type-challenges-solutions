---
id: 898
title: Includes
lang: ja
level: easy
tags: array
---

## 課題

型システムにより JavaScript の `Array.includes` 関数を実装してください。型は 2
つの引数を取り、真偽値 `true` または `false` を出力するものとします。

例:

```typescript
// expected to be `false`
type isPillarMen = Includes<["Kars", "Esidisi", "Wamuu", "Santana"], "Dio">;
```

## 解答

まず、タプル `T` と検索対象 `U` という 2 つの引数を受け取る型を書きましょう。

```typescript
type Includes<T, U> = never;
```

タプルの中から要素を見つけるためには、まずタプルをユニオンへと「変換」するのが得
策です。そのためには Indexed Access 型を使用します。`T[number]` にアクセスする
と、TypeScript は `T` のすべての要素からなるユニオンを返します。たとえば
`T = [1, 2, 3]` である場合、`T[number]` とすると `1 | 2 | 3` が返されます。

```typescript
type Includes<T, U> = T[number];
```

しかし、この時点では Type ‘number’ cannot be used to index type ‘T’ というエラー
が発生します。これは `T` に制約がないためです。`T` が配列であることを TypeScript
に伝える必要があります。

```typescript
type Includes<T extends unknown[], U> = T[number];
```

タプルの要素のユニオンを得られましたが、ユニオンの中に対象の要素が存在するかどう
かをチェックするためにはどうすればよいでしょうか? Distributive Conditional 型を
使いましょう! ユニオンに対して Conditional 型を使用すると、TypeScript は自動的に
ユニオンの各要素に対して条件を適用します。

たとえば `2 extends 1 | 2` と書いた場合、TypeScript はこれを `2 extends 1` と
`2 extends 2` という 2 つの Conditional 型に置き換えます。

これを使って `U` が `T[number]` に存在するかどうかをチェックし、存在する場合は
`true` を返すようにします。

```typescript
type Includes<T extends unknown[], U> = U extends T[number] ? true : false;
```

## 参考

- [Generics](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Generic Constraints](https://www.typescriptlang.org/docs/handbook/2/generics.html#generic-constraints)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Distributive Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#distributive-conditional-types)
- [Index Types](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)
