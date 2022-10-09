---
id: 4
title: Pick
lang: ja
level: easy
tags: union built-in
---

## 課題

組み込みの `Pick<T, K>` を使用せず、`T` から `K` のプロパティを抽出する型を実装してください。

例:

```ts
interface Todo {
  title: string;
  description: string;
  completed: boolean;
}

type TodoPreview = MyPick<Todo, "title" | "completed">;

const todo: TodoPreview = {
  title: "Clean room",
  completed: false,
};
```

## 解答

この課題を解くためには、Lookup 型と Mapped 型を使う必要があります。

Lookup 型により、名前を用いてある型から別の型を抽出することができます。これはあるオブジェクトからそのキーにより値を取得することと似ています。

Mapped 型により、ある型に含まれるプロパティを新しい型へと変換することができます。

TypeScript のウェブサイト上で [Lookup 型](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-1.html#keyof-and-lookup-types)と [Mapped 型](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)に関する説明をさらに読み、その挙動について理解しておきましょう。

以上で TypeScript には Lookup 型と Mapped 型が存在することがわかりました。では、要求された型をどのように実装すればいいでしょうか?

ユニオン `K` からすべてのプロパティを抜き出し、各値について走査し、それらのみをキーとする新たな型を返す必要があります。これはまさしく Mapped 型の挙動と一致します。

値の型自体を変更する必要はありません。与えられた型から型情報を抜き出さなければなりませんが、それには Lookup 型を使うことができます:

```ts
type MyPick<T, K extends keyof T> = { [P in K]: T[P] };
```

ここで表現していることは、「`K` からすべてのプロパティを抜き出し、各値の名前を `P` とした上で、新しいオブジェクトのキーを `P` とし、またそれに対応する値の型を、入力された型 `T` から得られるものとする」ということです。最初は理解することが難しいかもしれません。もし何かわからないことがあれば、もう一度説明を読み直し、順を追って理解していってください。

## 参考

- [Lookup Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-1.html#keyof-and-lookup-types)
- [Mapped Types](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
- [Indexed Types](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)
