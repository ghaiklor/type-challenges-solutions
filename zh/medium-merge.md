---
id: 599
title: Merge
lang: zh
level: medium
tags: object
---

## 挑战

将两个类型合并为一个新类型。
第二个类型的键将覆盖第一个类型的键。

例如：

```typescript
type Foo = {
  a: number;
  b: string;
};

type Bar = {
  b: number;
};

type merged = Merge<Foo, Bar>; // expected { a: number; b: number }
```

## 解答

这个挑战让我想起了[“append to object”](./medium-append-to-object.md)。
我们使用联合操作符从对象和字符串中收集所有属性。

在这里，我们可以使用相同的技巧来收集两个对象的所有属性名称。
因此，我们的映射类型保存来自两个对象的属性:

```typescript
type Merge<F, S> = { [P in keyof F | keyof S]: never };
```

有了两个对象的属性名，我们就可以开始获取它们的值类型了。
我们从 `S` 开始，因为它具有更高的优先级，它可以覆盖 `F` 中的值类型。
但我们还需要检查属性是否存在于 `S` 上:

```typescript
type Merge<F, S> = {
  [P in keyof F | keyof S]: P extends keyof S ? S[P] : never;
};
```

如果 `S` 中没有该属性，我们检查 `F` 上是否存在该属性，如果存在，我们从这里获得值类型:

```typescript
type Merge<F, S> = {
  [P in keyof F | keyof S]: P extends keyof S
    ? S[P]
    : P extends keyof F
    ? F[P]
    : never;
};
```

这样我们就可以合并两个对象，并使 `S` 具有更高优先级。

## 参考

- [Union Types](https://www.typescriptlang.org/docs/handbook/2/everyday-types.html#union-types)
- [keyof and Lookup Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-1.html#keyof-and-lookup-types)
- [Mapped Types](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
