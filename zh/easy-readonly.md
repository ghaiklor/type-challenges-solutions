---
id: 7
title: Readonly
lang: zh
level: easy
tags: built-in readonly object-keys
---

## 挑战

实现内置的`Readonly<T>`泛型而不使用它。

构造一个将`T`所有属性设置为`readonly`的类型，这意味着该类型的属性不可以重新赋值
。

例如：

```ts
interface Todo {
  title: string;
  description: string;
}

const todo: MyReadonly<Todo> = {
  title: "Hey",
  description: "foobar",
};

todo.title = "Hello"; // Error: cannot reassign a readonly property
todo.description = "barFoo"; // Error: cannot reassign a readonly property
```

## 解答

我们需要使对象中的所有属性都是只读的。因此，我们需要迭代所有的属性，并为它们添加
一个修饰符。

我们将在这里使
用[映射类型](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)，
很简单。对于该类型的每个属性，我们获取它的键并为其添加一个`readonly`修饰符：

```ts
type MyReadonly<T> = { readonly [K in keyof T]: T[K] };
```

## 参考

- [Mapped Types](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
