---
id: 3376
title: InOrder Traversal
lang: zh
level: medium
tags: object-keys
---

## 挑战

实现类型版本的二叉树按顺序遍历。例如：

```typescript
const tree1 = {
  val: 1,
  left: null,
  right: {
    val: 2,
    left: {
      val: 3,
      left: null,
      right: null,
    },
    right: null,
  },
} as const;

type A = InOrderTraversal<typeof tree1>; // [1, 3, 2]
```

## 解答

在二叉树的有序遍历中，我们遍历一个节点的子树，然后“访问”这个节点，然后遍历它的另一个子树。通常，我们会先遍历左子树，然后再遍历节点的右子树。

下面是二叉树按顺序遍历的伪代码：

```text
procedure in_order(p : reference to a tree node)
    if p !== null
        in_order(p.left)
        Visit the node pointed to by p
        in_order(p.right)
    end if
end procedure
```

下面是一个二叉树有序遍历示例：

```text
      A
    /   \
   B     C
 /   \
D     E

In-order Traversal: D, B, E, A, C
```

所以让我们先从实现伪代码开始。

```ts
type InOrderTraversal<T extends TreeNode | null> = T extends TreeNode
  ? never
  : never;
```

如果没有 `TreeNode`，则返回一个空数组。

```ts
type InOrderTraversal<T extends TreeNode | null> = T extends TreeNode
  ? never
  : [];
```

根据伪代码，我们递归遍历左子树直到碰到 `null`，这个时候，我们打印根节点并遍历右子树。

我们先创建一个帮助类型，它将递归遍历一个节点，直到遇到 `null`时返回一个空数组。

```ts
type Traverse<F, S extends keyof F> = F[S] extends TreeNode
  ? InOrderTraversal<F[S]>
  : [];
```

最后，我们利用这个帮助类型完成挑战。

```ts
type InOrderTraversal<T extends TreeNode | null> = T extends TreeNode
  ? [...Traverse<T, "left">, T["val"], ...Traverse<T, "right">]
  : [];
```

## 参考

- [Binary Tree Traversal](https://www.geeksforgeeks.org/tree-traversals-inorder-preorder-and-postorder/)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
