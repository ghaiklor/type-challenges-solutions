---
id: 3062
title: Shift
lang: uk
level: medium
tags: array
---

## Завдання

Реалізуйте типізовану версію `Array.shift()`. Наприклад:

```typescript
type Result = Shift<[3, 2, 1]>; // [2, 1]
```

## Розв'язок

Ще одне завдання в основі якого маніпулювання кортежами. У цьому випадку нам
потрібно розділити елемент з початку кортежу та решту - хвіст.
Починаємо з порожнього типу:

```typescript
type Shift<T> = any;
```

Щоб отримати перший елемент кортежу та його решту, ми можемо використати виведення
в умовних типах:

```typescript
type Shift<T> = T extends [infer _, ...infer T] ? never : never;
```

Перший елемент називається `_`, тому що він для нас не важливий. Однак нам важлива
решту кортежу, яка є "зміщеною". Таким чином, ми повертаємо його з правдивої гілки умовного типу:

```typescript
type Shift<T> = T extends [infer _, ...infer T] ? T : never;
```

Якщо тип-параметр `T` не відповідає заданому шаблону, повертаємо порожній кортеж,
оскільки немає що зміщувати:

```typescript
type Shift<T> = T extends [infer _, ...infer T] ? T : [];
```

## Посилання

- [Дженерики](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Умовні типи](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Виведення в умовних типах](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Варіативні типи](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
