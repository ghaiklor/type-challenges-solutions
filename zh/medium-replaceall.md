---
id: 119
title: ReplaceAll
lang: zh
level: medium
tags: template-literal
---

## 挑战

实现 `ReplaceAll<S, From, To>` 将一个字符串 `S` 中的所有子字符串 `From` 替换为
`To`。

例如:

```ts
type replaced = ReplaceAll<"t y p e s", " ", "">; // expected to be 'types'
```

## 解答

本解答将基于 [`Replace`](../en/medium-replace.md)类型的解答。

输入字符串 `S` 必须被分成三部分。在`From`之前的最左边部分，From 本身，From 之后
的最右边部分。我们可以用条件类型和类型推断来做到这一点。

一旦字符串推断成功，我们就知道了各部分的组成，就可以返回由这些部分和所需的`To`构
造的新的模板字面量类型

```ts
type ReplaceAll<
  S extends string,
  From extends string,
  To extends string,
> = From extends ""
  ? S
  : S extends `${infer L}${From}${infer R}`
  ? `${L}${To}${R}`
  : S;
```

这个解决方案将替换单个匹配，但我们需要替换所有匹配。通过将新字符串作为类型本身的
类型参数(递归地)很容易就能实现这一点。

```ts
type ReplaceAll<
  S extends string,
  From extends string,
  To extends string,
> = From extends ""
  ? S
  : S extends `${infer L}${From}${infer R}`
  ? ReplaceAll<`${L}${To}${R}`, From, To>
  : S;
```

但是，在下一次递归调用中，字符可能会以意想不到的方式被替换。例如，调
用`ReplaceAll<"fooo", "fo", "f">`将导致`foo -> fo -> f`。因此，我们需要跟踪之前
的字符串。

```typescript
type ReplaceAll<
  S extends string,
  From extends string,
  To extends string,
  Before extends string = "",
> = From extends ""
  ? S
  : S extends `${Before}${infer L}${From}${infer R}`
  ? ReplaceAll<`${Before}${L}${To}${R}`, From, To, `${Before}${L}${To}`>
  : S;
```

## 参考

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Type inference in conditional types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Recursive Conditional Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
- [Template Literal Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types)
