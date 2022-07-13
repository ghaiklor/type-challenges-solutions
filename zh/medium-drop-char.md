---
id: 2070
title: Drop Char
lang: zh
level: medium
tags: template-literal infer
---

## 挑战

从字符串中剔除指定字符。

例如：

```typescript
type Butterfly = DropChar<" b u t t e r f l y ! ", " ">; // 'butterfly!'
```

## 解答

为了解决这个问题，我们需要了解模板字面量类型。你可以
在`TypeScript Handbook`中[了解更多](https://www.typescriptlang.org/docs/handbook/2/template-literal-types.html)。

使用模板字面量类型时，我们可以从字符串中推断所需的部分，并检查其是否是我们期望的
部分。让我们从最简单的情况开始 - 推断字符串的左侧部分和右侧部分。它们之间的分隔
符是所需的字符本身。

```typescript
type DropChar<S, C> = S extends `${infer L}${C}${infer R}` ? never : never;
```

使用这样的表示方法，我们会得到一个编译错
误`Type ‘C’ is not assignable to type ‘string | number | bigint | boolean | null | undefined’.`添
加一个泛型约束去修复它。

```typescript
type DropChar<S, C extends string> = S extends `${infer L}${C}${infer R}`
  ? never
  : never;
```

现在我们有了左右两部分以及字符`C`。由于我们需要删除`C`，因此我们返回没有它的左右
部分。

```typescript
type DropChar<S, C extends string> = S extends `${infer L}${C}${infer R}`
  ? `${L}${R}`
  : never;
```

这样我们就将目标字符从字符串中剔除了，为了删除其他部分含有的目标字符，我们需要递
归地调用该类型。

```typescript
type DropChar<S, C extends string> = S extends `${infer L}${C}${infer R}`
  ? DropChar<`${L}${R}`, C>
  : never;
```

我们涵盖了所有的情况，除了要剔除的目标字符串为空, 这时我们将整个字符串返回即可。

```typescript
type DropChar<S, C extends string> = S extends `${infer L}${C}${infer R}`
  ? DropChar<`${L}${R}`, C>
  : S;
```

## 参考

- [Template Literal Types](https://www.typescriptlang.org/docs/handbook/2/template-literal-types.html)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Inferring within Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
