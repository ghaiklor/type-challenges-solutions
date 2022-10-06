---
id: 5310
title: Join
lang: zh
level: medium
tags: array
---

## 挑战

在类型系统中实现 `Array.join` 。 `Join<T, U>` 接收一个数组 `T` 和一个分隔符 `U`
，并返回数组 `T` 中各元素与分隔符 `U` 连接后的结果。

例如：

```typescript
type Res = Join<["a", "p", "p", "l", "e"], "-">; // expected to be 'a-p-p-l-e'
type Res1 = Join<["Hello", "World"], " ">; // expected to be 'Hello World'
type Res2 = Join<["2", "2", "2"], 1>; // expected to be '21212'
type Res3 = Join<["o"], "u">; // expected to be 'o'
```

## 解答

乍一看，最简单的解决方案是枚举数组中的项并返回由其内容和分隔符组成的模板字符串类
型。

让我们从需要实现的空白类型开始：

```typescript
type Join<T, U> = any;
```

枚举数组的经典技巧是推断它的第一个元素和剩余元素，然后递归。让我们先添加推断逻辑
：

```typescript
type Join<T, U> = T extends [infer S, ...infer R] ? never : never;
```

这里我们推断了首个字符串元素（`S`）和剩余元素数组（`R`）。我们要如何处理推断出的
字符串呢？我们需要在它后面加上一个分隔符（来自类型参数`U`）。

```typescript
type Join<T, U> = T extends [infer S, ...infer R] ? `${S}${U}` : never;
```

有了这种类型，我们就可以在数组的第一个元素后添加分隔符。然后我们还需要递归连接数
组中剩余的元素，直至数组末尾。

```typescript
type Join<T, U> = T extends [infer S, ...infer R]
  ? `${S}${U}${Join<R, U>}`
  : never;
```

但是，当数组 `T` 中没有其他元素时，就会出现返回 `never` 的情况。在这种情况下，我
们应该返回一个空字符串，这样结果就是正常的字符串了。

```typescript
type Join<T, U> = T extends [infer S, ...infer R]
  ? `${S}${U}${Join<R, U>}`
  : "";
```

这似乎是一个可行的解决方案，但还存在一些编译器错误需要我们解决。第一个编译器错误
是
`Type 'S' is not assignable to type 'string | number | bigint | boolean | null | undefined'`
， 类型参数 `U` 也存在相同的错误。 我们可以给泛型加上类型约束来解决这个问题：

```typescript
type Join<T extends string[], U extends string | number> = T extends [
  infer S,
  ...infer R
]
  ? `${S}${U}${Join<R, U>}`
  : "";
```

上面的约束可以检查输入的类型参数是否符合我们的期望。但是我们推断的类型 `S` 和
`R` 还有编译错误，我们需要告诉编译器我们推断的这些类型是字符串：

```typescript
type Join<T extends string[], U extends string | number> = T extends [
  infer S extends string,
  ...infer R extends string[]
]
  ? `${S}${U}${Join<R, U>}`
  : "";
```

成功了，但是没有完全成功。。。我们得到的结果字符串尾部会多出一个不需要的分隔符。
参考下面例子的输入和结果：

```typescript
type R0 = Join<["a", "p", "p", "l", "e"], "-">;
// type R0 = "a-p-p-l-e-"
```

怎样将其移除呢？我们尝试将原来代码中直接拼接分隔符的逻辑，改为条件判断式的逻辑：

```typescript
type Join<T extends string[], U extends string | number> = T extends [
  infer S extends string,
  ...infer R extends string[]
]
  ? `${S}${R["length"] extends 0 ? never : never}${Join<R, U>}`
  : "";
```

我们通过查看剩余元素数组 `R` 的长度 `length` 属性来进行判断。如果其值为 0，那就
意味着剩余数组为空，我们就不需要分隔符：

```typescript
type Join<T extends string[], U extends string | number> = T extends [
  infer S extends string,
  ...infer R extends string[]
]
  ? `${S}${R["length"] extends 0 ? "" : never}${Join<R, U>}`
  : "";
```

剩余数组不为空的情况下，我们需要添加分隔符：

```typescript
type Join<T extends string[], U extends string | number> = T extends [
  infer S extends string,
  ...infer R extends string[]
]
  ? `${S}${R["length"] extends 0 ? "" : U}${Join<R, U>}`
  : "";
```

## 参考

- [Generics](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Generic Constraints](https://www.typescriptlang.org/docs/handbook/2/generics.html#generic-constraints)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Inferring within Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Variadic Tuple Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
- [Template Literal Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types)
- [Indexed Access Types](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)
- [Recursive Conditional Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
