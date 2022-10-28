---
id: 7
title: Readonly
lang: ja
level: easy
tags: built-in readonly object-keys
---

## 課題

組み込みの `Readonly<T>` を使用せず、与えられた `T` のすべてのプロパティを
`readonly` とするような型、すなわち、すべてのプロパティを再割り当て不能とするよ
うな型を実装してください。

例:

```ts
interface Todo {
  title: string;
  description: string;
}

const todo: MyReadonly<Todo> = {
  title: "Hey",
  description: "foobar",
};

todo.title = "Hello"; // Error: cannot reassign a readonly property
todo.description = "barFoo"; // Error: cannot reassign a readonly property
```

## 解答

オブジェクトのすべてのプロパティを読み取り専用とする必要があります。つまり、すべ
てのプロパティについて走査し、修飾子を付加する必要があります。

ここでは
[Mapped 型](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)を
使用するだけであり、それほど難しくはありません。与えられた型の各プロパティについ
て、そのキーを取り出し、`readonly` 修飾子を付加します:

```ts
type MyReadonly<T> = { readonly [K in keyof T]: T[K] };
```

## 参考

- [Mapped Types](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
