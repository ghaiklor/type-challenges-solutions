---
id: 116
title: Replace
lang: zh
level: medium
tags: template-literal
---
## 挑战

实现 `Replace<S, From, To>` 将字符串 `S` 中的第一个子字符串 `From` 替换为 `To`。

例如:

```ts
type replaced = Replace<"types are fun!", "fun", "awesome">; // expected to be 'types are awesome!'
```

## 解答

我们有一个输入字符串`S`，我们需要找到`From` 的匹配并将其替换为`To`。这意味着我们需要将输入字符串分成三部分，并对每一部分进行推断。

让我们开始吧。我们从字符串的左边开始推断，直到找到`From`, `From`本身和它后面的所有内容都是右边的部分

```ts
type Replace<
  S,
  From extends string,
  To
> = S extends `${infer L}${From}${infer R}` ? S : S;
```

一旦推断成功，我们就找到了`From`和字符串周围的部分。因此，我们可以通过构造模板字面量的各个部分并替换匹配项来返回一个新的模板字面量。

```ts
type Replace<
  S,
  From extends string,
  To extends string
> = S extends `${infer L}${From}${infer R}` ? `${L}${To}${R}` : S;
```

除了`From`是空字符串的情况，上述解答没有问题。这里，TypeScript 不会推断这部分，我们通过为空字符串添加边界情况进行修复。

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
