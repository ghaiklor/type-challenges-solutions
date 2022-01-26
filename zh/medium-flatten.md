---
id: 459
title: Flatten
lang: en
level: medium
tags: array
---

## 挑战

在这个挑战中，你需要编写一个接受数组并返回拍平数组类型的泛型函数, 举个栗子:

```ts
type flatten = Flatten<[1, 2, [3, 4], [[[5]]]> // [1, 2, 3, 4, 5]
```

## 方案

该挑战的基本用例是一个空数组的情况。当我们输入一个空数组时，我们返回一个空数组， 反正它已经被拍平了。否则，返回`T` 本身:

```typescript
type Flatten<T> = T extends [] ? [] : T;
```

但是，如果 `T` 不是一个空数组，这意味着我们有一个包含元素的数组或元素本身。当它是一个包含元素的数组时，我们需要做什么？我们需要从它和尾巴中推断出其中一项。现在，我们可以只返回推断的项:

```typescript
type Flatten<T> = T extends []
  ? []
  : T extends [infer H, ...infer T]
  ? [H, T]
  : [T];
```

顺便说一句，请注意`T`不是带有元素的数组的情况。这意味着它根本不是一个数组，因此我们将其视为元素本身并包裹在一个数组中返回。

知道了我们数组的头部和尾部，我们可以一次又一次地递归调用`Flatten`并将这些推断出的项作为参数传过去。这样，我们将每一项展平，直到它不是数组并返回`[T]`该项本身：

```typescript
type Flatten<T> = T extends []
  ? []
  : T extends [infer H, ...infer T]
  ? [...Flatten<H>, ...Flatten<T>]
  : [T];
```

## 参考

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Type inference in conditional types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Recursive Conditional Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
- [Variadic Tuple Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
