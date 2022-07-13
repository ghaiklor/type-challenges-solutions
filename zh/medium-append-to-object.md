---
id: 527
title: Append to Object
lang: zh
level: medium
tags: object-keys
---

## 挑战

实现一个向接口添加新字段的类型。该类型接受三个参数。输出应该是一个带有新字段的对
象。

例如：

```ts
type Test = { id: "1" };
type Result = AppendToObject<Test, "value", 4>; // expected to be { id: '1', value: 4 }
```

## 解答

当我们试图改变 TypeScript 中的对象接口时，通常交叉（intersection）类型会很有帮助
。这一挑战也不例外。我试着写了一个类型，它接受整个`T`和一个带有新属性的对象:

```typescript
type AppendToObject<T, U, V> = T & { [P in U]: V };
```

不幸的是，这个方案不能满足测试。它们期望的是一个普通（flat）类型而不是交叉
（intersection）类型。因此我们需要返回一个对象类型，其中包含所有属性和我们的新属
性。我将从映射`T`的属性开始:

```typescript
type AppendToObject<T, U, V> = { [P in keyof T]: T[P] };
```

现在，我们需要在`T`的属性中添加新属性`U`。这里有一个诀窍。没有什么可以阻止你将联
合传递给`in`操作符:

```typescript
type AppendToObject<T, U, V> = { [P in keyof T | U]: T[P] };
```

这样，我们就能得到`T`的所有属性加上属性`U`，这正是我们需要的。现在让我们通过
在`U`上添加一个约束来修复小错误:

```typescript
type AppendToObject<T, U extends string, V> = { [P in keyof T | U]: T[P] };
```

现在 TypeScript 唯一不能处理的是`P`可能不在`T`中，因为`P`是`T`和`U`的并集。我们
需要处理下这种情况，如果`P`来自于`T`，我们取`T[P]`，否则取`V`：

```typescript
type AppendToObject<T, U extends string, V> = {
  [P in keyof T | U]: P extends keyof T ? T[P] : V;
};
```

## 参考

- [Mapped Types](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Union Types](https://www.typescriptlang.org/docs/handbook/2/everyday-types.html#union-types)
