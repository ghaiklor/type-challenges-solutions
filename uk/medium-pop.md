---
id: 16
title: Pop
lang: uk
level: medium
tags: array
---

## Завдання

Реалізувати тип `Pop<T>`, який приймає масив `T` та повертає масив без останнього елемента.
Наприклад:

```typescript
type arr1 = ['a', 'b', 'c', 'd']
type arr2 = [3, 2, 1]

type re1 = Pop<arr1> // expected to be ['a', 'b', 'c']
type re2 = Pop<arr2> // expected to be [3, 2]
```

## Розв'язок

Розділимо масив на дві частини: від початку до останнього елемента й останній елемент.
Потім позбуваємось від останнього елемента і повертаємо першу частину.

Для цього скористаємось [варіативними типами](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types).
Комбінуючи їх з [виведенням типів в умовних типах](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types), виводимо потрібні частини массиву:

```typescript
type Pop<T extends any[]> = T extends [...infer H, infer T] ? H : never;
```

У випадку, коли `T` можна присвоїти до масиву, який можна поділити на дві частини, повертаємо його першу частину, інакше повертаємо `never`.

## Посилання

- [Умовні типи](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Виведення типів в умовних типах](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Варіативні типи](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
