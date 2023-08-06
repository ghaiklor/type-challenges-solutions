---
id: 4
title: Pick
lang: zh
level: easy
tags: union built-in
---

## 挑战

实现内置的`Pick<T, K>`而不使用它。

通过从`T`中选取属性集`K`来构建一个类型。

例如：

```ts
interface Todo {
  title: string;
  description: string;
  completed: boolean;
}

type TodoPreview = MyPick<Todo, "title" | "completed">;

const todo: TodoPreview = {
  title: "Clean room",
  completed: false,
};
```

## 解答

为了解出这个挑战，我们需要使用查找类型和映射类型。

查找类型允许我们通过名称从另一个类型中提取一个类型。类似于使用键值从一个对象中获
取值。

映射类型允许我们将一个类型中的每个属性转换为一个新类型。

你可以在 TypeScript 网
站[lookup types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-1.html#keyof-and-lookup-types)和[mapped types](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)上
了解更多它们得信息，并了解它们在做什么。

现在，我们知道 TypeScript 中有查找类型和映射类型。如何实现所需的类型?

我们需要从联合（union）`K`取得所有内容，进行遍历，并返回一个仅包含这些键的新类
型。这正是映射类型所做的事。

尽管我们需要从原始类型中获取它的类型，值的类型本身并没有变化。这就是查找类型的用
处所在：

```ts
type MyPick<T, K extends keyof T> = { [P in K]: T[P] };
```

我们说“从`K`中获取所有内容，命名为`P`并将其作为我们新对象的一个新键，其值类型取
自输入类型”。一开始理解很难，所以你一旦不理解什么，就尝试重读一遍，再一步步的在
脑海里思考。

## 参考

- [Lookup Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-1.html#keyof-and-lookup-types)
- [Mapped Types](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
- [Indexed Types](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)
