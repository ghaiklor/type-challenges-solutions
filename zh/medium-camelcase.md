---
id: 610
title: CamelCase
lang: zh
level: medium
tags: template-literal
---

## 挑战

将字符串转换为驼峰式。
例如：

```typescript
type camelCased = CamelCase<"foo-bar-baz">; // expected "fooBarBaz"
```

## 解答

有一个常见的模式，我们可以用来推断字符串的连字符（-）部分。
我们可以取得连字符（-）之前的部分-头部，和连字符（-）之后的部分-尾部。
让我们来推断这些部分。

```typescript
type CamelCase<S> = S extends `${infer H}-${infer T}` ? never : never;
```

如果没有这种模式呢？
我们返回输入的字符串，不做任何更改。

```typescript
type CamelCase<S> = S extends `${infer H}-${infer T}` ? never : S;
```

但是如果有这样的模式，我们需要删除连字符并将尾部首字母大写。
另外，我们不会忘记可能还有其他子字符串需要处理，所以我们递归地处理。

```typescript
type CamelCase<S> = S extends `${infer H}-${infer T}`
  ? `${H}${CamelCase<Capitalize<T>>}`
  : S;
```

现在的问题是我们不处理尾部已经首字母大写的情况。
我们可以通过检查尾部首字母是否大写来解决这个问题。

```typescript
type CamelCase<S> = S extends `${infer H}-${infer T}`
  ? T extends Capitalize<T>
    ? never
    : `${H}${CamelCase<Capitalize<T>>}`
  : S;
```

如果我们得到首字母大写的尾部，我们会怎么做?
我们需要保留连字符，跳过这个。
当然，我们也需要递归。

```typescript
type CamelCase<S> = S extends `${infer H}-${infer T}`
  ? T extends Capitalize<T>
    ? `${H}-${CamelCase<T>}`
    : `${H}${CamelCase<Capitalize<T>>}`
  : S;
```

我们得到了一个可以“驼峰式”模板文字的类型，很好!

## 参考

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Type inference in conditional types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Recursive Conditional Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
- [Template Literal Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types)
