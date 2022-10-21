---
id: 3060
title: Unshift
lang: ja
level: easy
tags: array
---

## 課題

`Array.unshift()` に対応する型を実装してください。

例:

```typescript
type Result = Unshift<[1, 2], 0>; // [0, 1, 2]
```

## 解答

この課題は [Push の課題](./easy-push.md)と多くの共通点があります。そこでは、配列のすべての要素を取得するために Variadic Tuple 型を使用しました。

ここでもほぼ同じことをおこないますが、順序が異なります。まず、入力された配列のすべての要素を取得しましょう:

```typescript
type Unshift<T, U> = [...T];
```

このスニペットのままでは、A rest element type must be an array type というコンパイルエラーが発生します。型変数に対する制約を追加し、エラーを修正しましょう:

```typescript
type Unshift<T extends unknown[], U> = [...T];
```

この時点で、入力された配列と同じ配列を得ることができています。あとはタプルの先頭に要素を追加すれば完成です。やってみましょう:

```typescript
type Unshift<T extends unknown[], U> = [U, ...T];
```

以上により、型システムにおいて unshift 関数を実装することができました!

## 参考

- [Generics](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Generic Constraints](https://www.typescriptlang.org/docs/handbook/2/generics.html#generic-constraints)
- [Variadic Tuple Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
