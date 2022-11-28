---
id: 612
title: KebabCase
lang: zh
level: medium
tags: template-literal
---

## 挑战

将一个字符串转换为串式命名法（kebab-case）。例如：

```typescript
type kebabCase = KebabCase<"FooBarBaz">; // expected "foo-bar-baz"
```

## 解答

这个挑战与 ["CamelCase"](./hard-camelcase.md) 有很多共同之处。我们从类型推断开始
，我们需要知道首字母和剩下的尾部。

```typescript
type KebabCase<S> = S extends `${infer C}${infer T}` ? never : never;
```

一旦未匹配到就意味着我们全部转换完成。我们只需要原样返回输入的字符串。

```typescript
type KebabCase<S> = S extends `${infer C}${infer T}` ? never : S;
```

但是，一旦匹配到我们就需要处理 2 种情况。一种情况是没有首字母大写的尾部，一种情
况是有。为了检测这个，我们可以用内置类型 `Uncapitalize`。

```typescript
type KebabCase<S> = S extends `${infer C}${infer T}`
  ? T extends Uncapitalize<T>
    ? never
    : never
  : S;
```

如果我们有非首字母大写的尾部怎么办？假设我们有 “Foo” 或 “foo”，我们将首字母变成
小写，尾部保持不变。不要忘了继续处理剩余的字符串。

```typescript
type KebabCase<S> = S extends `${infer C}${infer T}`
  ? T extends Uncapitalize<T>
    ? `${Uncapitalize<C>}${KebabCase<T>}`
    : never
  : S;
```

现在剩下的情况就是有首字母大写的尾部，比如“fooBar”。我们需要将首字母变小写，然后
是连字符（-），然后继续递归的处理尾部。我们不需要使尾部首字母小写的原因是因为
`Uncapitalize<C>` 始终会使它变小写。

```typescript
type KebabCase<S> = S extends `${infer C}${infer T}`
  ? T extends Uncapitalize<T>
    ? `${Uncapitalize<C>}${KebabCase<T>}`
    : `${Uncapitalize<C>}-${KebabCase<T>}`
  : S;
```

## 参考

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Type inference in conditional types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Recursive Conditional Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
- [Template Literal Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types)
