---
id: 3326
title: BEM Style String
lang: zh
level: medium
tags: template-literal union tuple
---

## 挑战

块（Block）、元素（Element）、修饰符（Modifier）方法（BEM）是 CSS 中类的一种流行的命名规范。

例如，块组件将被表示为 `btn`，依赖于块的元素将被表示为 `btn_price`，变更块的样式的修饰符将被表示为 `btn--big` 或 `btn__price-warning`。

实现 `BEM<B, E, M>`，从这三个参数生成字符串联合。
其中 `B` 是一个字符串字面量，`E` 和 `M` 是字符串数组（可以为空）。

## 解答

在这个挑战中，我们被要求按照规则来制作一个特定的字符串。
我们必须遵循3条规则：块、元素和修饰符。
为了简化解决方案的整体外观，我提议将它们分为三个独立的类型。

我们从第一条开始 - 块（Block）：

```typescript
type Block<B extends string> = any;
```

这个很简单，因为我们需要做的只是返回一个包含输入类型参数的模板字符量类型：

```typescript
type Block<B extends string> = `${B}`;
```

下一个是元素（Element）。
它不像块一那样是一个模板字面量类型，因为有一种情况，即元素数组是空的。
所以我们需要检查数组是不回为空，如果是，就构造一个字符串。
由于知道空数组作为 `T[number]` 访问时会返回 `never` 类型，我们可以使用一个条件类型来检查它：

```typescript
type Element<E extends string[]> = E[number] extends never ? never : never;
```

如果元素数组是空的，我们只需要返回一个空的字符串字面是不是类型（不需要一个字符串前缀 `__`）：

```typescript
type Element<E extends string[]> = E[number] extends never ? `` : never;
```

一旦我们知道一个数组不是空的，我们需要添加一个前缀 `__`，然后在一个模板字面量类型中组合这些元素：

```typescript
type Element<E extends string[]> = E[number] extends never ? `` : `__${E[number]}`;
```

同样的逻辑我们也适用于最后一个 -- 修饰符（Modifier）。
如果带有修饰符的数组是空的，就返回空的字符串字面量类型。
否则，返回一个带有修饰符的联合的前缀：

```typescript
type Modifier<M extends string[]> = M[number] extends never ? `` : `--${M[number]}`;
```

剩下的就是在我们的初始类型中结合这三个类型：

```typescript
type BEM<B extends string, E extends string[], M extends string[]> = `${Block<B>}${Element<E>}${Modifier<M>}`
```

完整的解答，包括所有4个类型，像这样：

```typescript
type Block<B extends string> = `${B}`;
type Element<E extends string[]> = E[number] extends never ? `` : `__${E[number]}`;
type Modifier<M extends string[]> = M[number] extends never ? `` : `--${M[number]}`;
type BEM<B extends string, E extends string[], M extends string[]> = `${Block<B>}${Element<E>}${Modifier<M>}`;
```

## 参考

- [Generics](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Generic Constraints](https://www.typescriptlang.org/docs/handbook/2/generics.html#generic-constraints)
- [Template Literal Types](https://www.typescriptlang.org/docs/handbook/2/template-literal-types.html)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
