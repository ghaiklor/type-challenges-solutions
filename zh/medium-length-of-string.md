---
id: 298
title: Length of String
lang: zh
level: medium
tags: template-literal
---

## 挑战

计算字符串的长度，其行为类似于`String#length`。

例如：

```typescript
type length = LengthOfString<"Hello, World">; // expected to be 12
```

## 解答

起初，我尝试使用一个简单的解决方案 - 通过索引类型访问属性`length`。
我想，也许TypeScript足够聪明，可以获得该值。

```typescript
type LengthOfString<S extends string> = S["length"];
```

很不幸，不行。推导的类型是`number`而非数字字面量类型。所以我们需要考虑一些别的事情。

如果我们递归地推导第一个字符以及剩余的字符串直到没有第一个字符为止会怎样？
那样，递归本身即是我们的计数器。
让我们首先编写一个类型推导首字符和字符串的剩余部分：

```typescript
type LengthOfString<S extends string> = S extends `${infer C}${infer T}`
  ? never
  : never;
```

类型参数`C`获取字符串首字母，`T`获取剩余部分。
我们对剩余部分递归调用类型本身，直到没有字符串时停止：

```typescript
type LengthOfString<S extends string> = S extends `${infer C}${infer T}`
  ? LengthOfString<T>
  : never;
```

问题是我们不知道把计数器存放在哪里。
显然，我们可以添加另一个类型参数来累积计数，但TypeScript不提供在类型系统中操作数字的选项。
如果添加另一个类型参数并增加其值就太好了。

我们可以将类型参数设定为包含字符的元组，并在每次递归时使用首字符填充它：

```typescript
type LengthOfString<
  S extends string,
  A extends string[]
> = S extends `${infer C}${infer T}` ? LengthOfString<T, [C, ...A]> : never;
```

我们将字符串字面量转换为包含其字符的元组，并将其保存在新的类型参数中。
一旦我们遇到没有字符的情形（递归退出），我们只需要返回元组的长度：

```typescript
type LengthOfString<
  S extends string,
  A extends string[]
> = S extends `${infer C}${infer T}`
  ? LengthOfString<T, [C, ...A]>
  : A["length"];
```

通过引入另一个类型参数，我们破坏了测试。因为我们的类型目前需要2个类型参数而不再是1个。
让我们通过给我们的类型参数增加空元组默认值来解决它。

```typescript
type LengthOfString<
  S extends string,
  A extends string[] = []
> = S extends `${infer C}${infer T}`
  ? LengthOfString<T, [C, ...A]>
  : A["length"];
```

## 参考

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Type inference in conditional types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Recursive Conditional Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
- [Template Literal Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types)
- [Variadic Tuple Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
- [Index Types](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)
