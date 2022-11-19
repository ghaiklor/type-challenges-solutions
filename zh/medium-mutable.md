---
id: 2793
title: Mutable
lang: zh
level: medium
tags: readonly object-keys
---

## 挑战

实现泛型 `Mutable<T>` ，使 `T` 中所有属性都是可变的。

比如：

```typescript
interface Todo {
  readonly title: string;
  readonly description: string;
  readonly completed: boolean;
}

// { title: string; description: string; completed: boolean; }
type MutableTodo = Mutable<T>;
```

## 解答

我认为这个挑战不应该属于中等类别。我毫无困难的解决了它。不管怎样，我们将解出所有的挑战。

我们知道有一种类型在对象的属性上带有只读的修饰符。
这个修饰符和我们之前的[Readonly challenge](./easy-readonly.md)一样。
然而，这次要求我们从类型中去掉该修饰符。

让我们先从最简单的开始，使用映射类型原样复制这个类型：

```typescript
type Mutable<T> = { [P in keyof T]: T[P] };
```

现在它是带有只读修饰符的 `T` 的副本。我们怎样去掉他们呢？
好吧，记得在上一次的挑战中为了加上它们，我们只是把关键字 `readonly` 加到映射类型上：

```typescript
type Mutable<T> = { readonly [P in keyof T]: T[P] };
```

TypeScript隐式地给 `readonly` 关键字加了一个 `+`，意思是我们向属性添加修饰符。
但在我们这个例子中，我们需要丢弃它，于是我们用 `-` 代替：

```typescript
type Mutable<T> = { -readonly [P in keyof T]: T[P] };
```

这样，我们实现了一种类型，可以从属性中丢弃只读修饰符。

## 参考

- [Mapped Types](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
- [Mapping Modifiers](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html#mapping-modifiers)
