---
id: 14
title: First of Array
lang: ja
level: easy
tags: array
---

## 課題

配列 `T` を受け取り、その最初の要素の型を返すような `First<T>` を実装してください。

例:

```ts
type arr1 = ["a", "b", "c"];
type arr2 = [3, 2, 1];

type head1 = First<arr1>; // expected to be 'a'
type head2 = First<arr2>; // expected to be 3
```

## 解答

Lookup 型を使用して `T[0]` と書くことをまず思い付いたかもしれません:

```ts
type First<T extends any[]> = T[0];
```

しかし、ここで考慮すべきエッジケースがあります。空の配列を渡した場合、要素がないため `T[0]` は期待通り動作しないのです。

そのため、配列の最初の要素にアクセスする前に、配列が空であるかどうかをチェックする必要があります。
これは TypeScript の [Conditional 型](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html) によって実現することができます。

Conditional 型の考え方はとてもシンプルです。`extends` の左にある型を右側の型に割り当てることができる場合、true ブランチに入ります。そうでない場合は false ブランチに入ります。

配列が空であるかどうかをチェックし、空である場合は何も返さず、その他の場合は配列の最初の要素を返すようにしましょう:

```ts
type First<T extends any[]> = T extends [] ? never : T[0];
```

## 参考

- [Indexed Types](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
