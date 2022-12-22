---
id: 5821
title: MapTypes
lang: zh
level: medium
tags: map object utils
---

## 挑战

实现类型 `MapTypes<T, R>`，将对象 `T` 中的类型转换成由类型 `R` 定义的类型，其结构如下：

```typescript
type StringToNumber = {
  mapFrom: string; // value of key which value is string
  mapTo: number; // will be transformed for number
};
```

例如：

```typescript
type StringToNumber = { mapFrom: string; mapTo: number };
MapTypes<{ iWillBeANumberOneDay: string }, StringToNumber>; // gives { iWillBeANumberOneDay: number; }
```

注意用户可能提供类型的联合：

```typescript
type StringToNumber = { mapFrom: string; mapTo: number };
type StringToDate = { mapFrom: string; mapTo: Date };
MapTypes<{ iWillBeNumberOrDate: string }, StringToDate | StringToNumber>; // gives { iWillBeNumberOrDate: number | Date; }
```

如果该类型在映射中不存在，则保持原样：

```typescript
type StringToNumber = { mapFrom: string; mapTo: number };
MapTypes<
  { iWillBeANumberOneDay: string; iWillStayTheSame: Function },
  StringToNumber
>; // // gives { iWillBeANumberOneDay: number, iWillStayTheSame: Function }
```

## 解答

在这个挑战中，我们需要使用对象映射类型。我们需要枚举对象并将值类型从一个类型映射到另一个。

让我们先从实现空白类型开始：

```typescript
type MapTypes<T, R> = any;
```

类型参数 `T` 是我们需要去映射的对象， 参数 `R` 表示其映射关系。我们先给映射类型参数 `R` 增加泛型限制：

```typescript
type MapTypes<T, R extends { mapFrom: unknown; mapTo: unknown }> = any;
```

在实际进行映射之前，我们先从简单的映射类型复制输入类型 `T` 开始：

```typescript
type MapTypes<T, R extends { mapFrom: unknown; mapTo: unknown }> = {
  [P in keyof T]: T[P];
};
```

现在，在“复制”对象类型的基础上，我们可以开始添加一些映射。根据挑战要求，首先我们先检查值类型是否与 `mapFrom` 类型匹配：

```typescript
type MapTypes<T, R extends { mapFrom: unknown; mapTo: unknown }> = {
  [P in keyof T]: T[P] extends R["mapFrom"] ? never : never;
};
```

在这种情况下我们有一个匹配，这意味着我们需要用 `mapTo` 的类型替换当前值类型：

```typescript
type MapTypes<T, R extends { mapFrom: unknown; mapTo: unknown }> = {
  [P in keyof T]: T[P] extends R["mapFrom"] ? R["mapTo"] : never;
};
```

否则，如果没有匹配到，根据规则我们需要返回原类型：

```typescript
type MapTypes<T, R extends { mapFrom: unknown; mapTo: unknown }> = {
  [P in keyof T]: T[P] extends R["mapFrom"] ? R["mapTo"] : T[P];
};
```

至此，我们通过了除了那个联合类型之外的所有的测试用例。在挑战说明中指出可能指定映射为对象的联合类型。

因此，我们也需要对映射本身进行枚举。我们首先将 `R['mapTo']` 替换为条件类型。Typescript中的条件类型是可分发的（distributive），这意味着他会枚举联合类型中的每个元素。然而，他作用于条件类型开始的类型。因此，我们以类型参数 `R` 开始，并检查匹配的值类型：

```typescript
type MapTypes<T, R extends { mapFrom: unknown; mapTo: unknown }> = {
  [P in keyof T]: T[P] extends R["mapFrom"]
    ? R extends { mapFrom: T[P] }
      ? never
      : never
    : T[P];
};
```

可分发（distributive）条件类型会对 `R` 进行枚举，如果有匹配到值类型 `T[P]`，则返回对应的映射类型：

```typescript
type MapTypes<T, R extends { mapFrom: unknown; mapTo: unknown }> = {
  [P in keyof T]: T[P] extends R["mapFrom"]
    ? R extends { mapFrom: T[P] }
      ? R["mapTo"]
      : never
    : T[P];
};
```

## 参考

- [Generics](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Generic Constraints](https://www.typescriptlang.org/docs/handbook/2/generics.html#generic-constraints)
- [Mapped Types](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
- [Indexed Access Types](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
