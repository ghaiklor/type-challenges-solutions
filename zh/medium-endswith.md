---
id: 2693
title: EndsWith
lang: zh
level: medium
tags: template-literal
---

## 挑战

实现 `EndsWith<T, U>` ，它接受两个字符串类型，并返回 `T` 是否以 `U` 结尾：

```typescript
type R0 = EndsWith<"abc", "bc">; // true
type R1 = EndsWith<"abc", "abc">; // true
type R2 = EndsWith<"abc", "d">; // false
```

## 解答

这个挑战属于中等难度，但我认为它不应该出现在这里。
它更像一个简单难度的而不是中等难度的。
但是，我又有什么资格去评判。

我们需要检查字符串是否以特定的字符串结束。
很明显模板字面量类型会很有用。

让我们从模板字面量类型开始，它可以包含任何字符串。
在这一点上，我们不关心内容，所以我们在这里使用 `any` 类型：

```typescript
type EndsWith<T extends string, U extends string> = T extends `${any}`
  ? never
  : never;
```

在这个语句中，我们说“嘿，编译器，检查字面量类型 `T` 是否从 `any` 类型扩展的”。
结果为真，它是扩展的。

现在，让我们添加一个需要检查的子字符串。
我们通过类型参数 `U` 传递子字符串，我们需要检查它是否在字符串的结尾。
就这样：

```typescript
type EndsWith<T extends string, U extends string> = T extends `${any}${U}`
  ? never
  : never;
```

通过使用这样的结构，我们检查字符串是否从 `any` 扩展，以 `U` 结尾。
简单，剩下的就是根据结果返回布尔类型。

```typescript
type EndsWith<T extends string, U extends string> = T extends `${any}${U}`
  ? true
  : false;
```

## 参考

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Template Literal Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types)
