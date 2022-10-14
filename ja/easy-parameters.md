---
id: 3312
title: Parameters
lang: ja
level: easy
tags: infer tuple built-in
---

## 課題

組み込みの `Parameters<T>` を、`Parameters<T>` 自体を使わずに実装してください。

## 解答

この課題では、関数についての情報、より正確には関数のパラメータを取得する必要があります。まず、パラメータを取得するために使用するジェネリック型 `T` を受け取る型を宣言してみましょう:

```typescript
type MyParameters<T> = any;
```

さて、「未知の型を取得する」ための適切な方法は何でしょうか? そう、`infer` を使えばいいのです! しかしその前に、関数をマッチさせるシンプルな Conditional 型を作成しておきましょう:

```typescript
type MyParameters<T> = T extends (...args: any[]) => any ? never : never;
```

ここでは型 `T` が、任意の引数と任意の型の戻り値をもつ関数とマッチするかどうかをチェックしています。これにより、パラメータリストの `any[]` を `infer` により置き換えることができます:

```typescript
type MyParameters<T> = T extends (...args: infer P) => any ? never : never;
```

こうすることで、TypeScript コンパイラは関数のパラメータリストを推論し、型 `P` に割り当てます。あとは true ブランチから型を返せば完了です:

```typescript
type MyParameters<T> = T extends (...args: infer P) => any ? P : never;
```

## 参考

- [Generics](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Inferring within Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
