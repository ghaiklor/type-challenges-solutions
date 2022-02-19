---
id: 3312
title: Parameters
lang: zh
level: easy
tags: infer tuple built-in
---

## 挑战

实现内置的 `Parameters<T>` 泛型而不使用它。

## 解答

这个挑战要求我们从函数中获取部分信息。
更确切地说，是函数的参数。
我们首先声明一个接受泛型类型 `T` 的类型，我们将使用它来获取参数:

```typescript
type MyParameters<T> = any
```

那么，“获得我们还不知道的类型”的正确方法是什么?
通过使用推断!
但在使用它之前，让我们先从一个简单的条件类型来匹配函数:

```typescript
type MyParameters<T> = T extends (...args: any[]) => any ? never : never
```

这里，我们检查类型 `T` 是否与函数的任何参数和任何返回类型匹配。
现在，我们可以利用推断替换掉参数列表中的 `any[]`:

```typescript
type MyParameters<T> = T extends (...args: infer P) => any ? never : never
```

这样，TypeScript编译器就会推断出函数的参数列表，并将其赋值给类型 `P`。
剩下的就是从分支返回类型:

```typescript
type MyParameters<T> = T extends (...args: infer P) => any ? P : never
```

## 参考

- [Generics](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Inferring within Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
