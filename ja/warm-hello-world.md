---
id: 13
title: Hello, World
lang: ja
level: warm
tags: warm-up
---

## 課題

Type Challenges では、型システム自体を使用してアサーションをおこないます。

この課題では、以下のコードを変更して (型チェックエラーなしで) テストをパスさせる必要があります。

```ts
// expected to be string
type HelloWorld = any;
```

```ts
// you should make this work
type test = Expect<Equal<HelloWorld, string>>;
```

## 解答

この課題は、プレイグラウンドの使い方や課題への取り組み方などに慣れるためのウォームアップです。ここで求められていることは、`any` の代わりに `string` を指定することだけです:

```ts
type HelloWorld = string;
```

## 参考

- [Typed JavaScript at Any Scale](https://www.typescriptlang.org)
- [The TypeScript Handbook](https://www.typescriptlang.org/docs/handbook/intro.html)
- [TypeScript for Java/C# Programmers](https://www.typescriptlang.org/docs/handbook/typescript-in-5-minutes-oop.html)
- [TypeScript for Functional Programmers](https://www.typescriptlang.org/docs/handbook/typescript-in-5-minutes-func.html)
