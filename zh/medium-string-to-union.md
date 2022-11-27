---
id: 531
title: String to Union
lang: zh
level: medium
tags: union string
---

## 挑战

实现 `StringToUnion` 类型。它接收 `string` 类型参数，输出其所有字符的联合
（union）。

For example: 比如：

```typescript
type Test = "123";
type Result = StringToUnion<Test>; // expected to be "1" | "2" | "3"
```

## 解答

在这个挑战中，我们需要遍历每个字符并把它加到联合（union）中。遍历字符串很容易，
我们需要做的是推断出字符串的两个部分，首字符和其余部分：

```typescript
type StringToUnion<T extends string> = T extends `${infer C}${infer T}`
  ? never
  : never;
```

在这里，我们将获得 2 个类型参数 `C` 和 `T`（字符和尾部）。为了继续遍历字符串，我
们递归地调用它并将尾部作为参数传入：

```typescript
type StringToUnion<T extends string> = T extends `${infer C}${infer T}`
  ? StringToUnion<T>
  : never;
```

剩下的就是联合（union）本身了。我们需要添加第一个字符到联合（union）。在基本情况
下，`StringToUnion`会返回`C | never`，我们只需要将`C`添加到联合（union）中：

```typescript
type StringToUnion<T extends string> = T extends `${infer C}${infer T}`
  ? C | StringToUnion<T>
  : never;
```

## 参考

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Type inference in conditional types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Recursive Conditional Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
- [Template Literal Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types)
- [Union Types](https://www.typescriptlang.org/docs/handbook/2/everyday-types.html#union-types)
