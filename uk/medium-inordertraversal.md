---
id: 3376
title: InOrder Traversal
lang: uk
level: medium
tags: object-keys
---

## Завдання

Реалізуйте типізовану версію симетричного(in-order) обходу бінарного дерева. Наприклад:

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

## Розв'язок

Під час симетричного обходу бінарного дерева ми проходимо одне піддерево вузла, 
потім «відвідуємо» вузол, а потім обходимо його інше піддерево. Зазвичай ми спочатку 
обходимо ліве піддерево вузла, а потім обходимо праве.

Нижче наведено псевдокод для симетричного обходу бінарного дерева:

```text
procedure in_order(p : reference to a tree node)
    if p !== null
        in_order(p.left)
        Visit the node pointed to by p
        in_order(p.right)
    end if
end procedure
```

Ось приклад симетричного обходу бінарного дерева:

```text
      A
    /   \
   B     C
 /   \
D     E

In-order Traversal: D, B, E, A, C
```

Отже, почнемо з реалізації псевдокоду.

```ts
type InOrderTraversal<T extends TreeNode | null> = T extends TreeNode
  ? never
  : never;
```

Якщо у нас немає `TreeNode`, ми повертаємо порожній масив.

```ts
type InOrderTraversal<T extends TreeNode | null> = T extends TreeNode
  ? never
  : [];
```

Згідно з нашим псевдокодом, ми рекурсивно обходимо ліве піддерево, 
доки не досягнемо значення `null`, і коли ми це зробимо, ми друкуємо кореневий 
вузол і обходимо його праве піддерево.

Давайте створимо допоміжний тип, який рекурсивно обходитиме вузол, доки він не досягне 
значення `null`, після чого ми повернемо порожній масив.

```ts
type Traverse<F, S extends keyof F> = F[S] extends TreeNode
  ? InOrderTraversal<F[S]>
  : [];
```

Нарешті, давайте використаємо цей допоміжний тип в нашому розв'язку.

```ts
type InOrderTraversal<T extends TreeNode | null> = T extends TreeNode
  ? [...Traverse<T, "left">, T["val"], ...Traverse<T, "right">]
  : [];
```

## Посилання

- [Обхід бінарного дерева](https://www.geeksforgeeks.org/tree-traversals-inorder-preorder-and-postorder/)
- [Умовні типи](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
