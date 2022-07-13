---
id: 106
title: Trim Left
lang: zh
level: medium
tags: template-literal
---

## 挑战

实现 `TrimLeft<T>` ，它接收确定的字符串类型并返回一个新的字符串，其中新返回的字
符串删除了原字符串开头的空白字符串。

例如:

```ts
type trimmed = TrimLeft<"  Hello World  ">; // expected to be 'Hello World  '
```

## 解答

当你需要在类型中用到模板字符串时，你需要用到
[模板字面量类型](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types).
它允许在类型系统中对字符串进行建模。

我们这里有两种情况：左边有空格的字符串和没有空格的字符串。如果我们有空格，我们需
要推断字符串的另一部分并再次检查它是否有空格。否则，我们返回推断的部分而不做任何
更改。

让我们编写一个条件类型，以便我们可以使用类型推断并将其与模板字面量类型结合起来：

```ts
type TrimLeft<S> = S extends ` ${infer T}` ? TrimLeft<T> : S;
```

事实证明，这不是完整的解答。一些测试用例没有通过。那是因为我们没有处理换行符和制
表符。让我们用这三个的联合替换空格来解决这个问题：

```ts
type TrimLeft<S> = S extends `${" " | "\n" | "\t"}${infer T}` ? TrimLeft<T> : S;
```

## 参考

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Type inference in conditional types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Recursive Conditional Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
- [Template Literal Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types)
