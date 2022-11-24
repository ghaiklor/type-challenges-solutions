---
id: 5140
title: Trunc
lang: zh
level: medium
tags: template-literal
---

## 挑战

实现类型版本 `Math.trunc`。它接受字符串或数字，删除数字的小数部分返回整数部分。
例如：

```typescript
type A = Trunc<12.34>; // 12
```

## 解答

如果一个数字本身是字符串，那么很容易得到小数点之前的部分。这种方式只是用点分割字符串得到第一部分。

多亏 Typescript 中的模板字面量类型, 这样做很容易。首先，我们将从需要实现的初始类型开始：

```typescript
type Trunc<T> = any;
```

我们有一个将接受数字本身的类型参数。我们讨论过，通过分割字符串容易得到第一部分，所以我们需要将数字转换成字符串：

```typescript
type Trunc<T> = `${T}`;
```

得到一个报错，“Type 'T' is not assignable to type 'string | number | bigint
| boolean | null | undefined”。为了解决这个问题，我们给类型参数 `T` 增加一个泛型约束限制其为数字或字符串：

```typescript
type Trunc<T extends number | string> = `${T}`;
```

现在，我们有了数字的字符串表示。接下来，我们可以使用条件类型检查字符串是否带有小数点。
如果有，我们将推断出它们：

```typescript
type Trunc<T extends number | string> = `${T}` extends `${infer R}.${infer _}`
  ? never
  : never;
```

有个这个检查，我们可以区分有小数点和没有小数点的情况。

当小数点存在，我们取得小数点前面的部分 `R` 并返回，忽略小数点后面的部分：

```typescript
type Trunc<T extends number | string> = `${T}` extends `${infer R}.${infer _}`
  ? R
  : never;
```

但是如果字符串中没有小数点返回什么呢？它意味着没有什么需要截取，所以我们原样返回输入类型：

```typescript
type Trunc<T extends number | string> = `${T}` extends `${infer R}.${infer _}`
  ? R
  : `${T}`;
```

这样，我们的方案现在通过了所有的测试用例！

## 参考

- [Generics](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Generic Constraints](https://www.typescriptlang.org/docs/handbook/2/generics.html#generic-constraints)
- [Template Literal Types](https://www.typescriptlang.org/docs/handbook/2/template-literal-types.html)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Inferring within Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
