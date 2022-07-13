---
id: 8
title: Readonly 2
lang: zh
level: medium
tags: readonly object-keys
---

## Challenge

实现一个通用的`MyReadonly2<T, K>`，它带有两种类型的参数`T`和`K`。`K`指定的`T`的
属性集，应该设置为只读。如果未提供`K`，则应使所有属性都变为只读，就像普通
的`Readonly<T>`一样。

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

这个挑战是`Readonly<T>`挑战的延续，除了需要添加一个新的类型参数`K`，以便我们可以
将指定的属性设为只读外，一切都基本相同。

我们从最简单的例子开始，即`K`是一个空集合，因此没有任何属性需要设置为只读。我们
只需要返回`T`就好了。

```ts
type MyReadonly2<T, K> = T;
```

现在我们需要处理这样一种情况：即在`K`中提供对应属性，我们利用`&`操作符使两种类型
产
生[交集](https://www.typescriptlang.org/docs/handbook/2/objects.html#intersection-types)：
一个是之前提到的类型`T`,另一个是含有只读属性的类型。

```ts
type MyReadonly2<T, K> = T & { readonly [P in K]: T[P] };
```

看起来是一种解决方案，但是我们得到一个编译错误
：`Type ‘P’ cannot be used to index type ‘T’`。这是对的，因为我们没有对`K`设置约
束，它应该是 “`T`中的每一个键” :

```ts
type MyReadonly2<T, K extends keyof T> = T & { readonly [P in K]: T[P] };
```

正常工作啦? 🙅‍ 不!

我们还没有处理当`K`什么都没有设置的情况，该情况下我们的类型必须和通常
的`Readonly<T>`表现得一样。为了修复这个问题，我们将`K`的默认值设为"`T`的所有键
"。

```ts
// solution-1
type MyReadonly2<T, K extends keyof T = keyof T> = T & {
  readonly [P in K]: T[P];
};
// 即：
type MyReadonly2<T, K extends keyof T = keyof T> = Omit<T, K> & Readonly<T>;
```

你可能发现`solution-1`在 TypeScript 4.5 及以上的版本中不能正常工作，因为原本的行
为在 TypeScript 中是一个 bug（
在[microsoft/TypeScript#45122](https://github.com/microsoft/TypeScript/issues/45122)中
列出，
在[microsoft/TypeScript#45263](https://github.com/microsoft/TypeScript/pull/45263)中
被修复，在 TypeScript 4.5 版本中正式发布）。从概念上来说，交叉类型意味着 "与"，
因此`{readonly a: string} & {a: string}`与`{a: string}`应该是相等的，也就是说属
性`a`是可读且可写的。

在 TypeScript 4.5 之前， TypeScript 有着相反的不正确的行为，也就是说在交叉类型中
，一些成员的属性是只读的，但在另外成员中同名属性是可读可写的，最终对象的相应属性
却是只读的，这种行为是不正确的，但这已经被修复了。因此这也就解释了为什
么`solution-1`不能正常工作。想要解决这个问题，可以像下面这样写：

```ts
//Solution-2
type MyReadonly2<T, K extends keyof T = keyof T> = Omit<T, K> & {
  readonly [P in K]: T[P];
};
//i.e.
type MyReadonly2<T, K extends keyof T = keyof T> = Omit<T, K> & Readonly<T>;
```

因为`K`中的键都没有在`keyof Omit<T, K>`中出现过，因此`solution-2`能够向相应属性
添加`readonly`修饰符。

## 参考

- [Intersection types](https://www.typescriptlang.org/docs/handbook/2/objects.html#intersection-types)
- [Mapped Types](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
- [Index Types](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)
- [Using type parameters in generic constraints](https://www.typescriptlang.org/docs/handbook/2/generics.html#using-type-parameters-in-generic-constraints)
