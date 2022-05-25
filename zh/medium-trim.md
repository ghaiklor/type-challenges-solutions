---
id: 108
title: Trim
lang: zh
level: medium
tags: template-literal
---

## 挑战

实现`Trim<T>`，它接收一个字符串类型，并返回一个新字符串，其中两端的空白符都已被删除。

例如:

```ts
type trimmed = Trim<"  Hello World  ">; // expected to be 'Hello World'
```

## 解答

跟[`TrimLeft<T>`](./medium-trimleft.md)几乎是相同的任务。
我们这里用[模板字面量类型](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types) 在类型系统中对字符串进行建模

现在有三种情况：空格在字符串的左边，空格在字符串的右边，以及字符串两边都不含空格。
让我们先从左边有空格的情况开始建模。
通过结合模板字面量类型和条件类型，我们可以推断出不包含空字符串的其余部分。
在这种情况下，我们递归地继续移除左边的空格，直到没有空格时我们返回字符串而不做任何更改：

```ts
type Trim<S> = S extends ` ${infer R}` ? Trim<R> : S;
```

一旦左边没有空格，我们需要检查右边是否有空格，然后做相同的处理：

```ts
type Trim<S> = S extends ` ${infer R}`
  ? Trim<R>
  : S extends `${infer L} `
  ? Trim<L>
  : S;
```

这样，我们移除左边的空格，然后移除右边的空格。
直到没有空格，我们只返回字符串本身。

但是我们仍然会有失败的测试用例。
那是因为我们没有处理换行符和制表符。

我不想重复联合类型，所以我单独声明了一个联合类型，并用它替换了空格：

```ts
type Whitespace = " " | "\n" | "\t";
type Trim<S> = S extends `${Whitespace}${infer R}`
  ? Trim<R>
  : S extends `${infer L}${Whitespace}`
  ? Trim<L>
  : S;
```

## 参考

- [Union Types](https://www.typescriptlang.org/docs/handbook/2/everyday-types.html#union-types)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Type inference in conditional types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Recursive conditional types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
- [Template Literal Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types)
