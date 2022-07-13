---
id: 2688
title: StartsWith
lang: zh
level: medium
tags: template-literal
---

## 挑战

实现 `StartsWith<T, U>`，接受 2 个字符串类型并返回 `T` 是否以 `U` 开头。例如：

```typescript
type a = StartsWith<"abc", "ac">; // expected to be false
type b = StartsWith<"abc", "ab">; // expected to be true
type c = StartsWith<"abc", "abcd">; // expected to be false
```

## 解答

了解 Typescript 中的模板字面量类型，解决方案就变得十分明显了。让我们从保存 `any`
类型的初始类型开始：

```typescript
type StartsWith<T, U> = any;
```

我们需要检查输入类型参数 `T` 是否以字面量 `U` 开始。我会先做的简单一些，通过使用
条件类型来检查 `T` 是否为 `U`：

```typescript
type StartsWith<T, U> = T extends `${U}` ? never : never;
```

如果输入类型参数 `T` 和类型参数 `U` 相同，我们会进入条件类型的 true 分支。但是，
我们不需要它们相等。我们需要检查它是否以 `U` 开始。换句话说，我们不关心字面量
`U` 后面是否有其它东西。因此，在这里使用 `any` 类型：

```typescript
type StartsWith<T, U> = T extends `${U}${any}` ? never : never;
```

如果类型 `T` 匹配以 `U` 开头的字符串的模式，则返回 `true` 类型，否则返回
`false`：

```typescript
type StartsWith<T, U> = T extends `${U}${any}` ? true : false;
```

我们通过了所有的测试用例，但是我们仍然得到了一个编译错误，说“Type ‘U’ is not
assignable to type ‘string | number | bigint | boolean | null | undefined’.”。那
是因为我们没有在泛型上添加一个约束来表明 `U` 是一个字符串。让我们添加它：

```typescript
type StartsWith<T, U extends string> = T extends `${U}${any}` ? true : false;
```

## 参考

- [Generics](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Generic Constraints](https://www.typescriptlang.org/docs/handbook/2/generics.html#generic-constraints)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Template Literal Types](https://www.typescriptlang.org/docs/handbook/2/template-literal-types.html)
