---
id: 116
title: Replace
lang: zh
level: medium
tags: template-literal
---

## 挑战

实现 `Replace<S, From, To>` 将字符串 `S` 中的第一个子字符串 `From` 替换为 `To` 。

例如:

```ts
type replaced = Replace<"types are fun!", "fun", "awesome">; // expected to be 'types are awesome!'
```

## 解答

我们有一个输入字符串`S`, 我们需要找到与`From`匹配的字段并将其替换为`To`。这意味着我们需要将字符串分割为三个部分，并对其中的每个部分进行推断。

让我们开始吧。推断字符串左侧部分直到找到`From`, `From`本身及其之后的部分都被当做右侧部分。

```ts
type Replace<
  S,
  From extends string,
  To
> = S extends `${infer L}${From}${infer R}` ? S : S;
```

一旦推断成功，就会找到`From`，得到字符串周围的部分。因此，我们可以通过构造模板字面量类型的各个部分并替换匹配项来返回一个新的模板字面量类型。

```ts
type Replace<
  S,
  From extends string,
  To extends string
> = S extends `${infer L}${From}${infer R}` ? `${L}${To}${R}` : S;
```

解决方案没有任何问题，除非'`From `是一个空字符串。在此处TypeScript不会进行推断，我们通过为空字符串添加边界情况来进行修复。

```ts
type Replace<
  S extends string,
  From extends string,
  To extends string
> = From extends ""
  ? S
  : S extends `${infer L}${From}${infer R}`
  ? `${L}${To}${R}`
  : S;
```

## 参考

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Type inference in conditional types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Template Literal Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types)
