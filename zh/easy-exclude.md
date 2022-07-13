---
id: 43
title: Exclude
lang: zh
level: easy
tags: built-in
---

## 挑战

实现内置的`Exclude<T, U>`。从`T`中排除`U`指定的类型。例如：

```ts
type T0 = Exclude<"a" | "b" | "c", "a">; // expected "b" | "c"
type T1 = Exclude<"a" | "b" | "c", "a" | "b">; // expected "c"
```

## 解答

这里重要的细节是 TypeScript 中的条件类型
是[可分配的](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#distributive-conditional-types)。

所以当你在写`T extends U`且`T`是联合类型时，实际上发生的是 TypeScript 遍历联合类
型`T`并将条件应用到每个元素上。

因此，这个解答是非常直接的。我们检查`T`如果可以分配给`U`则跳过：

```ts
type MyExclude<T, U> = T extends U ? never : T;
```

## 参考

- [Distributive Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#distributive-conditional-types)
