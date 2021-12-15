---
id: 189
title: Awaited
lang: zh
level: easy
tags: promise
---

## 挑战

如果我们有一个包装类型，比如`Promise`
我们如何获得包装类型的内部类型?
例如，如果我们有`Promise<ExampleType>`如何得到`ExampleType` ?

## 解法

这是一个非常有趣的挑战，它要求我们了解TypeScript的一个被低估的特性，恕我直言。

但是，在说明我的意思之前，让我们来分析一下这个挑战。
作者要求我们展开类型。
什么是展开?
展开是从另一个类型中提取内部类型。

让我用一个例子来说明。
如果你有一个类型`Promise<string>`，展开`Promise `类型将得到类型`string `。
我们从外部类型得到其内部类型。

注意，你还需要递归地展开类型。
例如，如果你有类型`Promise<Promise<string>>`，你需要返回类型`string `。

现在，言归正传。
我将从最简单的例子开始。
如果我们的`Awaited`类型得到`Promise<string>`，我们需要返回`string`，否则我们返回`T`本身，因为它不是一个Promise:

```ts
type Awaited<T> = T extends Promise<string> ? string : T;
```

但是有一个问题。
这样，我们只能处理`string`类型在`Promise`中的情况，而我们需要的是可以处理任何情况。
怎么做呢?
在我们不知道类型的情况下，如何从`Promise`获取类型?

出于这些目的，TypeScript在条件类型中有类型推断功能!
你可以对编译器说"嘿，一旦你知道了类型是什么，请把它赋给我的类型参数"。
你可以在这里阅读更多关于[条件类型中的类型推断](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-8.html#type-inference-in-conditional-types)。


了解了类型推断之后，我们可以更新我们的解法。
我们没有在条件类型中检查`Promise<string>`，而是将`string`替换为`infer R`，因为我们不知道那里必须有什么。
我们只知道它是`Promise<T>`，其内部包含某种类型。

一旦TypeScript确定了`Promise`中的类型，它就会把它赋给我们的类型参数`R`，并在“true”分支中可用。
我们正是从这里返回它的：

```ts
type Awaited<T> = T extends Promise<infer R> ? R : T;
```

我们几乎完成了，但从类型`Promise<Promise<string>>`我们得到类型`Promise<string>`。
因此，我们需要递归地重复相同的过程，这是通过调用`Awaited`本身来实现的:

```ts
type Awaited<T> = T extends Promise<infer R> ? Awaited<R> : T;
```

## 参考

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Type Inference in Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
