---
id: 2595
title: PickByType
lang: zh
level: medium
tags: object
---

## 挑战

从 `T` 中选择一组类型可赋值给 `U` 的属性。
例如:

```typescript
type OnlyBoolean = PickByType<
  {
    name: string;
    count: number;
    isReadonly: boolean;
    isEnable: boolean;
  },
  boolean
>; // { isReadonly: boolean; isEnable: boolean; }
```

## 解答

在这个挑战中，我们需要遍历对象，过滤出那些只可赋值给 `U` 的字段。
很明显，我们确实需要从映射类型开始。

我们从创建一个对象，复制对象 `T` 所有的键值开始：

```typescript
type PickByType<T, U> = { [P in keyof T]: T[P] };
```

首先，我们从 `T` 中获得所有的键，并对它们进行迭代。
在每次迭代时，TypeScript 都会将键赋值给类型 `P`。
有了键，我们就可以通过查找类型 `T[P]` 来获取值类型。

现在，对迭代应用一个过滤器将允许我们只找到那些可赋值给 `U` 的。

当我说过滤器时，我指的是键的重新映射。
我们可以利用它检查该键是否是我们需要的键:

```typescript
type PickByType<T, U> = {
  [P in keyof T as T[P] extends U ? never : never]: T[P];
};
```

注意 `as` 关键字，它是重新映射开始的关键字。
在该关键字之后，我们可以编写一个条件类型来检查值类型。
如果值类型可赋值给类型 `U`，则原样返回该键。
但是，如果值类型不能赋值给 `U`，则返回 `never`:

```typescript
type PickByType<T, U> = { [P in keyof T as T[P] extends U ? P : never]: T[P] };
```

这样，我们就创建了一个根据值类型过滤键的类型。

## 参考

- [Mapped Types](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
- [Key remapping via as](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html#key-remapping-via-as)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [keyof and Lookup Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-1.html#keyof-and-lookup-types)
