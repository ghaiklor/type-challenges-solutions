---
id: 189
title: Awaited
lang: ja
level: easy
tags: promise
---

## 課題

Promise などのラップされた型があるとき、その中にある型を取得するにはどうすればよいでしょうか? たとえば `Promise<ExampleType>` から `ExampleType` を取得するにはどうすればよいでしょうか?

## 解答

TypeScript のそれほど知られていない機能を理解していることが要求される、興味深い課題です。

しかし、そのことを説明する前に、まず課題を分析しましょう。この課題の作者は、型をアンラップすることを求めています。アンラップとは何でしょうか? アンラップとは、ある型から内部の型を抽出することです。

例により説明します。`Promise<string>` という型があるとき、`Promise` 型をアンラップすると、`string` 型を得ます。外側の型から内側の型を取得したのです。

ここで、型を再帰的にアンラップする必要があることに注意してください。たとえば、`Promise<Promise<string>>` という型に対しては、`string` 型を返す必要があります。

それでは課題に入りましょう。まずは最も単純なケースから始めます。`Awaited` という型を、`Promise<string>` を受け取ったとき `string` を返すように定義します。その他の場合については、Promise ではないため `T` 自体を返すようにします:

```ts
type Awaited<T> = T extends Promise<string> ? string : T;
```

しかし、このアプローチには問題があります。この方法により対応できるのは文字列の `Promise` のみですが、実際は任意のケースについて対応できるようにする必要があるのです。そのためにはどうすればよいでしょうか? `Promise` に含まれる型が何であるかわからない場合、そこからどのように型を取得すればよいでしょうか?

こうした目的のために、TypeScript には Conditional 型の型推論があります! コンパイラに対し、「型の種類がわかったら、それを型変数に割り当ててください」と伝えることができるのです。詳しくは [Conditional 型の型推論について](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-8.html#type-inference-in-conditional-types)をご覧ください。

型推論を用いて、上の解答を書き換えましょう。Conditional 型において `Promise<string>` についてチェックするのではなく、`string` を `infer R` へと置き換えます。そこに何が入るかわからないからです。わかっていることは、ある型を内部にもつ `Promise<T>` であるということだけです。

TypeScript が `Promise` の内部の型を把握すると、その型は型変数 `R` に割り当てられ、true ブランチにおいて利用可能となります。そこで `R` を返却します:

```ts
type Awaited<T> = T extends Promise<infer R> ? R : T;
```

ほぼ完成ですが、このままでは `Promise<Promise<string>>` から `Promise<string>` が得られてしまいます。これを防ぐため、同じ処理を再帰的に繰り返す必要があります。これは `Awaited` 型自体を用いることで実現可能です:

```ts
type Awaited<T> = T extends Promise<infer R> ? Awaited<R> : T;
```

## 参考

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Type Inference in Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
