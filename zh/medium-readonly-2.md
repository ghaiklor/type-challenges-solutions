---
id: 8
title: Readonly 2
lang: zh
level: medium
tags: readonly object-keys
---

## Challenge

实现一个通用的`MyReadonly2<T, K>`，它带有两种类型的参数`T`和`K`。`K`指定为`T`的属性的子集，对应的属性是只读（`readonly`）的。如果未提供`K`，则应使所有属性都变为只读，就像普通的`Readonly<T>`一样。

例如:

```ts
interface Todo {
  title: string;
  description: string;
  completed: boolean;
}

const todo: MyReadonly2<Todo, "title" | "description"> = {
  title: "Hey",
  description: "foobar",
  completed: false,
};

todo.title = "Hello"; // Error: cannot reassign a readonly property
todo.description = "barFoo"; // Error: cannot reassign a readonly property
todo.completed = true; // OK
```

## 解答

这个挑战是`Readonly<T>`挑战的延续，一切都非常相同，除了需要添加一个新的类型参数`K`，以便我们可以将指定的对应属性设为只读。

我们从最简单的例子开始，即`K`是一个空集合，因此没有任何属性需要设置为只读。我们只需要返回`T`就好了。

```ts
type MyReadonly2<T, K> = T;
```

现在我们需要处理这样一种情况：即在`K`中提供对应属性，我们利用`&`操作符使两种类型产生[交集](https://www.typescriptlang.org/docs/handbook/2/objects.html#intersection-types)：一个是之前提到的类型`T`,另一个是含有只读属性的类型。

```ts
type MyReadonly2<T, K> = T & { readonly [P in K]: T[P] };
```

看起来是一种解决方案，但是我们得到一个编译错误：`Type ‘P’ cannot be used to index type ‘T’`。这是对的，因为我们没有对`K`设置约束，它应该是  “`T`中的每一个键”  组成的联合类型的子类型。

```ts
type MyReadonly2<T, K extends keyof T> = T & { readonly [P in K]: T[P] };
```

正常工作啦?
🙅‍不!

我们还没有处理当`K`什么都没有设置的情况，该情况下我们的类型必须和通常的`Readonly<T>`表现得一样。为了修复这个问题，我们将`K`的默认值设为"`T`的所有键"。

```ts
type MyReadonly2<T, K extends keyof T = keyof T> = T & {
  readonly [P in K]: T[P];
};
```

## 参考

- [Intersection types](https://www.typescriptlang.org/docs/handbook/2/objects.html#intersection-types)
- [Mapped Types](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
- [Index Types](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)
- [Using type parameters in generic constraints](https://www.typescriptlang.org/docs/handbook/2/generics.html#using-type-parameters-in-generic-constraints)
