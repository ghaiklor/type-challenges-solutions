---
id: 3376
title: Inorder Traversal
lang: en
level: medium
tags: object-keys
---

## Challenge

Implement the type version of binary tree inorder traversal.

For example:

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
} as const

type A = InorderTraversal<typeof tree1> // [1, 3, 2]
```

## Solution

In an inorder traversal of a binary tree, we traverse one subtree of a node, then "visit" the node, and then traverse its other subtree. Usually, we traverse the node's left subtree first and then traverse the node's right subtree.

Below is the pseudocode for inorder traversal of a binary tree:

```text
procedure inorder(p : reference to a tree node)
    if p !== null
        inorder(p.left)
        Visit the node pointed to by p
        inorder(p.right)
    end if
end procedure
```

Here's an example of an inorder traversal of a binary tree:

```text
      A
    /   \
   B     C
 /   \
D     E

Inorder Traversal: D, B, E, A, C
```

So let's start by implementing the pseudocode.

```ts
type InorderTraversal<T extends TreeNode | null> = T extends TreeNode ? never : never
```

In case we don't have a `TreeNode`, we return an empty array.

```ts
type InorderTraversal<T extends TreeNode | null> = T extends TreeNode ? never : []
```

As per our pseudocode, we recursively traverse the left subtree until we hit `null` and when we do, we print the root node and traverse its right subtree.

Let's create a type helper which will recursively inorder traverse a node until it hits `null` at which point we'll return an empty array.

```ts
type Traverse<F, S extends keyof F> = F[S] extends TreeNode ? InorderTraversal<F[S]> : []
```

Finally, let's utilize this type helper in our solution.

```ts
type InorderTraversal<T extends TreeNode | null> = T extends TreeNode ? [...Traverse<T, 'left'>, T['val'], ...Traverse<T, 'right'>] : []
```

## References

- [Binary Tree Traversal](https://www.geeksforgeeks.org/tree-traversals-inorder-preorder-and-postorder/)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
