---
id: 1042
title: IsNever
lang: zh
level: medium
tags: union utils
---

## 挑战

实现类型 `IsNever<T>`，该类型接受输入类型`T`。如果T的类型解析为`never`，请返回`true`，否则返回`false`。

例如：

```typescript
type A = IsNever<never>; // expected to be true
type B = IsNever<undefined>; // expected to be false
type C = IsNever<null>; // expected to be false
type D = IsNever<[]>; // expected to be false
type E = IsNever<number>; // expected to be false
```

## 解答

这里最直观的解法是利用条件类型来检查该类型是否可以赋值给`never`

如果类型`T`可以赋值给`never`，返回`true`，否则返回`false`。

```typescript
type IsNever<T> = T extends never ? true : false;
```

遗憾的是，我们没有通过`never`本身的测试用例，这是为什么呢？

 `never`类型表示从未出现的值的类型。`never`类型是TypeScript中任何其他类型的子类型，因此可以将`never`类型赋值给任何类型。然而，没有类型是`never`的子类型，这意味着除了`never`本身以外，不能将其他类型赋值给`never`。

这就引出了另一个问题：如果我们不能将除`never`外的其他类型赋值给`never`，那么我们如何检查某类型是否可以赋值给`never`呢？

我们何不创建内部含有`never`的另外一种类型呢? 如果我们不是检查类型`T`能否赋值给`never`，而是检查该类型能否赋值给包含`never`的元组类型呢?在这种情况下，在形式上我们不会将任何类型赋值给`never`。

```typescript
type IsNever<T> = [T] extends [never] ? true : false;
```

有了上述名为`<IsNever>`的解决方案，我们可以通过测试并实现泛型类型来检查传入类型是否为`never`。

## 参考

- [never type](https://www.typescriptlang.org/docs/handbook/2/narrowing.html#the-never-type)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Generics](https://www.typescriptlang.org/docs/handbook/2/generics.html)
