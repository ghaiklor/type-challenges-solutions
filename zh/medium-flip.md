---
id: 4179
title: Flip
lang: zh
level: medium
tags: object-keys
---

## 挑战

在类型系统中实现 `翻转对象的键与值`，例如：

```ts
Flip<{ a: "x"; b: "y"; c: "z" }>; // {x: 'a', y: 'b', z: 'c'}
Flip<{ a: 1; b: 2; c: 3 }>; // {1: 'a', 2: 'b', 3: 'c'}
Flip<{ a: false; b: true }>; // {false: 'a', true: 'b'}
```

在这个挑战中，我们不需要处理对象嵌套的情况，也不需要处理原对象值（如数组）不能用作新对象键的情况。

## 解答

我们先来实现第一步，把原对象的键用作新对象的值：

```ts
type Flip<T> = { [P in keyof T]: P };
// {key: key, ...}
```

接下来，我们只需要把新对象的键改成原对象的值即可完成挑战。这里我们需要使用 [“as” 语法](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#key-remapping-in-mapped-types)：

```ts
type Flip<T> = {
  [P in keyof T as T[P] extends AllowedTypes ? T[P] : never]: P;
};
// {value: key, ...}
```

这里 `AllowedTypes` 需包含可用作对象键的所有类型。根据题目的测试用例，我们需要包含 `string`、`number` 和 `boolean`：

```ts
type AllowedTypes = string | number | boolean;
```

但目前我们还不能通过测试，因为在这个挑战中，新对象的键只能为字符串。因此我们只需要把 `T[P]` 转成字符串即可：

```ts
type Flip<T> = {
  [P in keyof T as T[P] extends AllowedTypes ? `${T[P]}` : never]: P;
};
```

## 参考

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Key remapping in mapped types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#key-remapping-in-mapped-types)
- [Mapped Types](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
