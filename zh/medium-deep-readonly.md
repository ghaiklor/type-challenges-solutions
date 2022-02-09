---
id: 9
title: Deep Readonly
lang: zh
level: medium
tags: readonly object-keys deep
---

## 挑战

实现一个通用的 `DeepReadonly<T>` 以递归的方式只读化（`readonly`）对象及其子对象的每个属性。

你可以假设在这个挑战中我们只处理对象。
无需要考虑数组、函数、类等。
但是，你仍然可以通过尽可能多的覆盖不同的案例来挑战自己。

例如：

```ts
type X = {
  x: {
    a: 1;
    b: "hi";
  };
  y: "hey";
};

type Expected = {
  readonly x: {
    readonly a: 1;
    readonly b: "hi";
  };
  readonly y: "hey";
};

const todo: DeepReadonly<X>; // should be same as `Expected`
```

## 解答

在这个挑战中，我们需要创建相同的 [`Readonly<T>`](./easy-readonly.md) 类型。
唯一的区别是我们需要使它递归化。

让我们从经典开始，实现常规的 [`Readonly<T>`](./easy-readonly.md) 类型：

```ts
type DeepReadonly<T> = { readonly [P in keyof T]: T[P] };
```

但是，正如你已经知道的，这个类型不会将所有内容都设为只读，仅是没有深度的字段。
原因是当我们的 `T[P]` 不是原始类型，而是一个对象时，它会按原样传递它，且不会将其属性设为只读。

因此，我们需要将 `T[P]` 替换为 `DeepReadonly<T>` 的递归用法。
不过，在使用递归时不要忘记基本情况。

算法很简单。
如果 `T[P]` 是一个对象，我们继续调用 `DeepReadonly`，否则返回 `T[P]`

```ts
type DeepReadonly<T> = {
  readonly [P in keyof T]: T[P] extends Record<string, unknown>
    ? DeepReadonly<T[P]>
    : T[P];
};
```

## 参考

- [Index Types](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)
- [Mapped Types](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Recursive Conditional Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
