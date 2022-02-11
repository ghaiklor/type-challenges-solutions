---
id: 12
title: Chainable Options
lang: zh
level: medium
tags: application
---

## 挑战

在 JavaScript 中我们通常会使用到可串联（Chainable/Pipline）的函数构造一个对象，
但在 TypeScript 中，你能合理的给它附上类型吗？

在这个挑战中，你可以使用任何你喜欢的方式实现这个类型 -- Interface, Type 或 Class 都行。你需要提供两个函数 `option(key, value)` 和 `get()`。
在 `option` 中你需要使用提供的 key 和 value 来扩展当前的对象类型，
通过 `get()` 获取最终结果。

例如：

```ts
declare const config: Chainable;

const result = config
  .option("foo", 123)
  .option("name", "type-challenges")
  .option("bar", { value: "Hello World" })
  .get();

// expect the type of result to be:
interface Result {
  foo: number;
  name: string;
  bar: {
    value: string;
  };
}
```

你只需要在类型层面实现这个功能，不需要实现任何 JS/TS 的实际逻辑。

你可以假设 `key` 只接受字符串而 `value` 接受任何类型，你只需要暴露它传递的类型而不需要进行任何处理。
同样的 `key` 只会被使用一次。

## 解答

这是一个非常有趣的挑战，并且在现实世界中也实际使用。
就我个人而言，我在实现不同的 Builder 模式时经常使用它。

作者要求我们做什么？
我们需要实现两个方法 `options(key, value)` 和 `get()`。
每次调用 `option(key, value)` 都必须在某处累加 `key` 和 `value` 的类型信息。
累加操作必须持续进行，直到调用 `get` 函数将累加的信息作为一个对象类型返回。

让我们从作者提供的接口开始：

```ts
type Chainable = {
  option(key: string, value: any): any;
  get(): any;
};
```

在我们开始累加类型信息前，如果能先得到它，那就太好了。
所以我们把 `key` 的 `string` 和 `value` 的 `any` 替换成类型参数，以便 TypeScript 可以推断出它们的类型并将其分配给类型参数：

```ts
type Chainable = {
  option<K, V>(key: K, value: V): any;
  get(): any;
};
```

很好！
我们现在有了关于 `key` 和 `value` 的类型信息。
TypeScript 会将 `key` 推断为字符串字面量类型，而将 `value` 推断为常见的类型。
例如，调用 `opiton('foo', 123)` 将得出的类型为：`key = 'foo'` 和 `value = number`。

我们有了信息后，把它存储在哪里呢？
它必须是一个在若干次方法调用中保持其状态的地方。
唯一的地方便是 `Chainable` 类型本身！

让我们为 `Chainable` 类型添加一个新的类型参数 `O`，并且不能忘记默认它是一个空对象。

```ts
type Chainable<O = {}> = {
  option<K, V>(key: K, value: V): any;
  get(): any;
};
```

现在最有趣的部分来了，注意！
我们希望 `option(key, value)` 返回 `Chainable` 类型本身（我们希望有可能进行链式调用，对吧），但是要将类型信息累加到其类型参数中。
让我们使用 [intersection types](https://www.typescriptlang.org/docs/handbook/2/objects.html#intersection-types) 将新的类型添加到累加器中：

```ts
type Chainable<O = {}> = {
  option<K, V>(key: K, value: V): Chainable<O & { [P in K]: V }>;
  get(): any;
};
```

还有一些小事情。
我们收到编译错误 "Type ‘K’ is not assignable to type ‘string | number | symbol’."。
这是因为我们没有约束类型参数 `K`，即它必须是一个 `string`；

```ts
type Chainable<O = {}> = {
  option<K extends string, V>(key: K, value: V): Chainable<O & { [P in K]: V }>;
  get(): any;
};
```

一切都准备好了！
现在，当开发人员调用 `get()` 函数时，它必须从 `Chainable` 返回类型参数 `O`，该参数有之前的 `option(key, value)` 数次调用后累加的类型信息：

```ts
type Chainable<O = {}> = {
  option<K extends string, V>(key: K, value: V): Chainable<O & { [P in K]: V }>;
  get(): O;
};
```

## 参考

- [Intersection Types](https://www.typescriptlang.org/docs/handbook/2/objects.html#intersection-types)
- [Mapped Types](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
- [Generics](https://www.typescriptlang.org/docs/handbook/2/generics.html)
