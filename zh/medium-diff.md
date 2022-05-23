---
id: 645
title: Diff
lang: zh
level: medium
tags: object
---

## 挑战

获取两个接口类型中的差值属性。

例如：

```typescript
type Foo = {
  name: string;
  age: string;
};

type Bar = {
  name: string;
  age: string;
  gender: number;
};

type test0 = Diff<Foo, Bar>; // expected { gender: number }
```

## 解答

这个挑战要求我们基于对象进行操作。
所以有极大可能，映射类型可以发挥作用。

让我们从映射类型开始，在这里我们迭代两个对象的属性联合（union）。
毕竟在计算差值之前，我们需要收集两个对象的所有属性。

```typescript
type Diff<O, O1> = { [P in keyof O | keyof O1]: never };
```

当我们遍历这些属性的时候，我们需要检查这个属性是否存在于`O` 或者 `O1`。
所以我们在这里需要添加一个条件类型来找出我们需要从哪里获取值类型。

```typescript
type Diff<O, O1> = {
  [P in keyof O | keyof O1]: P extends keyof O
    ? O[P]
    : P extends keyof O1
    ? O1[P]
    : never;
};
```

太棒了！
我们得到了一个对象，它是两个对象所有属性的联合。
剩下的最后一件事是过滤掉那些在两个对象上都存在的属性。

我们如何获得两个对象上存在的所有属性呢？
交叉类型！
我们先获取交叉类型，然后把它从我们的映射类型`P`中剔除

```typescript
type Diff<O, O1> = {
  [P in keyof O | keyof O1 as Exclude<P, keyof O & keyof O1>]: P extends keyof O
    ? O[P]
    : P extends keyof O1
    ? O1[P]
    : never;
};
```

## 参考

- [Mapped Types](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
- [Key remapping in Mapped Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#key-remapping-in-mapped-types)
- [Union Types](https://www.typescriptlang.org/docs/handbook/2/everyday-types.html#union-types)
- [Intersection Types](https://www.typescriptlang.org/docs/handbook/2/objects.html#intersection-types)
- [Index Types](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [keyof and Lookup Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-1.html#keyof-and-lookup-types)
