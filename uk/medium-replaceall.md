---
id: 119
title: ReplaceAll
lang: uk
level: medium
tags: template-literal
---

## Завдання

Реалізувати `ReplaceAll<S, From, To>` який замінить всі збіги підрядка `From` на
рядок `To` в заданому рядку `S`. Наприклад:

```typescript
type replaced = ReplaceAll<"t y p e s", " ", "">; // expected to be 'types'
```

## Розв'язок

Це завдання має багато спільного з [`Replace`](./medium-replace.md). Там ми
замінювали збіг тільки один раз, а тут потрібно замінити всі.

Ділимо вхідний рядок `S` на три частини: підрядок до `From`, самий `From` и
підрядок після `From`. Щоб вивести їх, використовуємо рядкові тип-літерали й
умовні типи. Як тільки TypeScript виведе типи, він привласнить їх тип-параметрам
`L` і `R`. На їх основі, повертаємо новий рядковий тип-літерал, в якому
замінений `From` на `To`.

```typescript
type ReplaceAll<
  S extends string,
  From extends string,
  To extends string,
> = From extends ""
  ? S
  : S extends `${infer L}${From}${infer R}`
  ? `${L}${To}${R}`
  : S;
```

Цей розв'язок працює тільки з одним збігом, як в
[`Replace`](./medium-replace.md), але нам потрібно замінити всі. Цього можна
легко досягнути, передаючи наш новий тип-літерал рекурсивно в `ReplaceAll`.

```typescript
type ReplaceAll<
  S extends string,
  From extends string,
  To extends string,
> = From extends ""
  ? S
  : S extends `${infer L}${From}${infer R}`
  ? ReplaceAll<`${L}${To}${R}`, From, To>
  : S;
```

## Посилання

- [Умовні типи](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Виведення типів в умовних типах](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Рекурсивні умовні типи](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
- [Рядкові тип-літерали](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types)
