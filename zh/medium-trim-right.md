---
id: 4803
title: Trim Right
lang: zh
level: medium
tags: template-literal
---

## 挑战

实现 `TrimRight<T>` ，它接收一个明确的字符串类型，并返回一个删除了尾部所有空格的
新字符串类型。例如：

```typescript
type Trimmed = TrimRight<"   Hello World    ">; // expected to be '   Hello World'
```

## 解答

这个挑战其实和另外的 [Trim](./medium-trim.md) 以及
[Trim Left](./medium-trimleft.md) 挑战很相似。但是这个挑战我们需要做的是移除尾部
的空格。

我们仍然以一个空白类型开始：

```typescript
type TrimRight<S extends string> = any;
```

如何检查字符串是否是以空格结束呢？我们可以通过一个输入字符串是否继承自尾部为空格
的模板字符串的条件语句来判断，模板字符串中末尾是一个空格：

```typescript
type TrimRight<S extends string> = S extends `${infer T} ` ? never : never;
```

注意这里的类型推断 `infer T`。如果字符串是以空格结尾的，我们需要获取没有空格的部
分。因此我们将除末尾空格之外的部分推断为类型 `T`：

获取到尾部不包含空格的部分，我们就可以返回它：

```typescript
type TrimRight<S extends string> = S extends `${infer T} ` ? T : never;
```

但是上面的方案只能处理结尾包含一个空格的情况，如果有多个空格该如何处理呢？要覆盖
这种情况，我们需要不断去除尾部空格直至尾部没有空格，通过递归调用本身可以轻松实
现：

```typescript
type TrimRight<S extends string> = S extends `${infer T} `
  ? TrimRight<T>
  : never;
```

现在，我们的类型将递归逐个删除尾部空格，直至尾部没有空格。然后进入 `false` 分
支。此步骤中意味着尾部没有空格，我们可以不作处理直接返回输入的字符串：

```typescript
type TrimRight<S extends string> = S extends `${infer T} ` ? TrimRight<T> : S;
```

我想这就是解答方案。但我们通过测试用例的错误提示看到还有一些缺陷。我们没有处理制
表符和换行符。我们新增一个叫做 `Whitespace` 的单独类型，列出所有要处理的字符：

```typescript
type Whitespace = " " | "\n" | "\t";
```

然后使用该类型替换我们工具类型内的空格字符串：

```typescript
type TrimRight<S extends string> = S extends `${infer T}${Whitespace}`
  ? TrimRight<T>
  : S;
```

最终解答如下所示：

```typescript
type Whitespace = " " | "\n" | "\t";
type TrimRight<S extends string> = S extends `${infer T}${Whitespace}`
  ? TrimRight<T>
  : S;
```

## 参考

- [Union Types](https://www.typescriptlang.org/docs/handbook/2/everyday-types.html#union-types)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Type inference in conditional types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Recursive conditional types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
- [Template Literal Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types)
