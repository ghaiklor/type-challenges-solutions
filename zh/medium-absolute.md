---
id: 529
title: Absolute
lang: zh
level: medium
tags: math template-literal
---

## 挑战

实现`Absolute`类型。该类型接受一个`string`,`number`或`bigint`类型，返回值是一个
正数的字符串形式。

例如:

```typescript
type Test = -100;
type Result = Absolute<Test>; // expected to be "100"
```

## 解答

获得一个数字的绝对值最简单的方法是将其转换为字符串并去掉“-”号。我不是在开玩笑，
只是去掉“-”号。

我们可以通过检查该类型模板字面量中是否含有“-”号来处理。如果有，则推断出没有“-”号
的部分，否则返回类型本身：

```typescript
type Absolute<T extends number | string | bigint> = T extends `-${infer N}`
  ? N
  : T;
```

因此，如果我们给定类型`T = “-50”`，它将匹配到`“-<N>”`，其中`N`恰好就是“50”。这就
是它的工作原理。

现在，我们可以看到一些测试仍然失败。这是因为我们并不是每次都返回字符串。当提供一
个正数时，它将不会匹配到字面量并返回数字，但是我们需要返回的是字符串。

让我们通过将`T`包装在字面量类型中来解决这个问题：

```typescript
type Absolute<T extends number | string | bigint> = T extends `-${infer N}`
  ? N
  : `${T}`;
```

尽管如此，一些测试还是失败了。我们没有处理`T`为负数（number）的情况。数字
（number）不会匹配到该字面量条件类型，所以它会将负数作为字符串返回。为了克服这个
问题，我们可以将数字转换为字符串：

```typescript
type Absolute<T extends number | string | bigint> = `${T}` extends `-${infer N}`
  ? N
  : `${T}`;
```

结果，我们得到了一个接受任意`number`, `string`, `bigint`类型并将其转换为字符串。
然后推导出没有“-”号的数字并返回，或者只是返回没有更改的字符串。

## 参考

- [Template Literal Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Type inference in conditional types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
