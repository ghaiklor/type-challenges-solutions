---
id: 268
title: If
lang: ja
level: easy
tags: utils
---

## 課題

条件 `C`、真の場合の返り値の型 `T`、偽の場合の返り値の型 `F` を受け取る `If` を実装してください。`C` は `true` または `false` であることが期待されますが、`T` と `F` はどんな型でも構いません。

例:

```ts
type A = If<true, "a", "b">; // expected to be 'a'
type B = If<false, "a", "b">; // expected to be 'b'
```

## 解答

TypeScript の [Conditional 型](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)を使用するタイミングは、型に対して if 文を使用する必要がある場合です。まさしくここで求められていることに合致します。

条件を表わす型が `true` である場合 true ブランチに、そうでない場合は false ブランチに入ります:

```ts
type If<C, T, F> = C extends true ? T : F;
```

しかしこのままでは、`C` に割り当てられる型は boolean 型のみであることを示す制約がないため、コンパイルエラーが発生します。これに対処するため、型変数 `C` に `extends boolean` を追加します:

```ts
type If<C extends boolean, T, F> = C extends true ? T : F;
```

## 参考

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
