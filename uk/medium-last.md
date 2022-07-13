---
id: 15
title: Last of Array
lang: uk
level: medium
tags: array
---

## Завдання

Створити тип `Last<T>` який приймає масив `T` і повертає тип останнього
елемента. Наприклад:

```typescript
type arr1 = ["a", "b", "c"];
type arr2 = [3, 2, 1];

type tail1 = Last<arr1>; // expected to be 'c'
type tail2 = Last<arr2>; // expected to be 1
```

## Розв'язок

Щоб отримати останній елемент масиву, потрібно перебрати всі елементи до
останнього.

Для цього використаємо
[варіативні типи](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types).

Знаючи варіативні типи, рішення очевидне. Беремо елементи від першого, доки не
дійдемо до останнього. Комбінуючи це з
[виведенням типів в умовних типах](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types),
рішення стає доволі простим:

```typescript
type Last<T extends any[]> = T extends [...infer X, infer L] ? L : never;
```

## Посилання

- [Умовні типи](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Виведення типів в умовних типах](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Варіативні типи](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
