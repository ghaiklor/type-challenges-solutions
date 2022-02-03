---
id: 949
title: AnyOf
lang: zh
level: medium
tags: array
---

## 挑战

在类型系统实现类似于 Python 的 `any` 函数。
这个类型接受一个数组，如果数组中的任一元素为真，则类型返回 `true`。
如果数组为空，则返回 `false`。
例如：

```typescript
type Sample1 = AnyOf<[1, "", false, [], {}]>; // expected to be true
type Sample2 = AnyOf<[0, "", false, [], {}]>; // expected to be false
```

## 解答

看到这个挑战后，我第一个想法是使用 [distributive conditional types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#distributive-conditional-types).

我们可以使用 `T[number]` 语法来获取一个元组中所有元素组成的联合。
有了这元素组成的联合后，我们对它进行迭代，得出一个 `false` 或 `true` 联合。
如果所有元素都返回 `false`，我们会得出 `false` 的类型字面量。
但是，即使只有一个 `true`-y 元素，结果也就产生了 `true` 的类型字面量。
因此，`false` 和 `true` 类型字面量构成了我们的联合类型，其产出则是 `boolean`。
通过检查联合类型的产出与 `false` 类型字面量之间的继承关系，以判断是否存在 `true` 元素。

但是，这个实现被证明是非常古怪的。
我不喜欢它，看一看：

```typescript
type AnyOf<T extends readonly any[], I = T[number]> = (
  I extends any ? (I extends Falsy ? false : true) : never
) extends false
  ? false
  : true;
```

所以我开始思考，我们是否可以让它更易于维护呢？
事实证明我们可以。
让我们回忆一下从元组类型中推断与可变元组类型相结合的情况。
记得我们在解 [Last](./medium-last.md) 挑战或 [Pop](./medium-pop.md) 之类的问题时使用过这些。

我们从推断元组中的单一元素开始，并推断族中其余的元素：

```typescript
type AnyOf<T extends readonly any[]> = T extends [infer H, ...infer T]
  ? never
  : never;
```

我们如何检查推断的元素 `H` 是否为 false-y？
首先，我们可以构造一个表示 falsy-y 的类型。
我们称它为 `Falsy`：

```typescript
type Falsy = 0 | "" | false | [] | { [P in any]: never };
```

有了一个表示 falsy-y 值的类型，我们可以只使用条件类型来检查 `H` 是否从该类型中扩展：

```typescript
type AnyOf<T extends readonly any[]> = T extends [infer H, ...infer T]
  ? H extends Falsy
    ? never
    : never
  : never;
```

如果元素是 false-y，我们该怎么做？
这意味着，我们仍在试图检查是否至少有一个 true-y 元素。
所以我们可以继续递归：

```typescript
type AnyOf<T extends readonly any[]> = T extends [infer H, ...infer T]
  ? H extends Falsy
    ? AnyOf<T>
    : never
  : never;
```

最后，一量我们看到有元素不是 false-y，就意味着它是 true-y。
由于我们已经知道存在 true-y 元素，因此继续递归就没有意思了。
所以我们只需要通过返回 `true` 类型字面量来既定出递归：

```typescript
type AnyOf<T extends readonly any[]> = T extends [infer H, ...infer T]
  ? H extends Falsy
    ? AnyOf<T>
    : true
  : never;
```

最后的状态是当我们有一个空无组时。
在这种情况下，我们的推断将不起作用，这意味着绝对没有 true-y 元素。
在这种情况下，我们可以返回 `false`。

```typescript
type AnyOf<T extends readonly any[]> = T extends [infer H, ...infer T]
  ? H extends Falsy
    ? AnyOf<T>
    : true
  : false;
```

这就是我们在类型系统中实现的 `AnyOf` 函数的方式。
以下是整个实现，供参考：

```typescript
type Falsy = 0 | "" | false | [] | { [P in any]: never };

type AnyOf<T extends readonly any[]> = T extends [infer H, ...infer T]
  ? H extends Falsy
    ? AnyOf<T>
    : true
  : false;
```

## 参考

- [Union Types](https://www.typescriptlang.org/docs/handbook/2/everyday-types.html#union-types)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Inferring within Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Generics](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Variadic Tuple Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
