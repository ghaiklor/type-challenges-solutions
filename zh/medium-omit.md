---
id: 3
title: Omit
lang: zh
level: medium
tags: union built-in
---

## 挑战

实现内置的 `Omit<T, K>` 泛型而不使用它。通过从 `T` 中选取所有属性，然后删除 `K`
来构造一个类型。例如：

```ts
interface Todo {
  title: string;
  description: string;
  completed: boolean;
}

type TodoPreview = MyOmit<Todo, "description" | "title">;

const todo: TodoPreview = {
  completed: false,
};
```

## 解答

我们这里需要返回一个新的对象类型，但不指定键。显然，这提示我们需要在这里使
用[映射类型（mapped types）](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)。

我们需要映射对象的每个属性并构造一个新类型。让我们从基础开始，构建相同的对象：

```ts
type MyOmit<T, K> = { [P in keyof T]: T[P] };
```

在这里，我们遍历了 `T` 中的所有键，将其映射到类型 `P`，并使其成为新对象的键，同
时值为 `T[P]` 类型。

这样，我们就可以遍历所有的键，但是我们需要过滤掉那些我们不感兴趣的键。

为了实现这一点，我们可
以[使用 “as” 语法重新映射键类型](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#key-remapping-in-mapped-types):

```ts
type MyOmit<T, K> = { [P in keyof T as P extends K ? never : P]: T[P] };
```

我们映射 `T` 的所有属性，如果属性在 `K` 联合中，我们返回 “never” 类型作为它的键
，否则返回键本身。这样，我们就可以过滤掉属性并获得所需的对象类型。

## 参考

- [Mapped Types](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
- [Index Types](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Key remapping in mapped types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#key-remapping-in-mapped-types)
