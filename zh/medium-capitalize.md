---
id: 110
title: Capitalize
lang: zh
level: medium
tags: template-literal
---

## 挑战

实现 `Capitalize<T>` 将字符串的第一个字母转换为大写，其余部分保持原样。

例如：

```ts
type capitalized = Capitalize<"hello world">; // expected to be 'Hello world'
```

## 解答

起初，我并不明白这个挑战。
我们无法为字符串字面量实现字符大写的通用解答。
因此，如果使用内置的 `Capitalize` 类型，就很直接了当了：

```ts
type MyCapitalize<S extends string> = Capitalize<S>;
```

我相信，这不是本意。
我们不能使用内置的 `Capitalize` 类型，我们也无法实现通用的解答。
没有这些，我们怎么能让字符大写呢？
当然，使用字典！

为了使解答更简单，我只为需要的字符制作了一个字典，即 `f`：

```ts
interface CapitalizedChars {
  f: "F";
}
```

现在，我们有了一个字典，让我们来推断类型的第一个字符。
我们使用经典的条件类型来构造并推断：

```ts
type Capitalize<S> = S extends `${infer C}${infer T}` ? C : S;
```

现在类型参数 `C` 有了第一个字符。
我们需要检查这个字符是否存在于我们的字典中。
如果是，我们从字典中返回大写的字符，否则我们返回第一个字符且不做任何变更。

```ts
interface CapitalizedChars {
  f: "F";
}
type Capitalize<S> = S extends `${infer C}${infer T}`
  ? `${C extends keyof CapitalizedChars ? CapitalizedChars[C] : C}${T}`
  : S;
```

## 参考

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Type inference in conditional types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Template Literal Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types)
- [keyof and Lookup Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-1.html#keyof-and-lookup-types)
