---
id: 5360
title: Unique
lang: uk
level: medium
tags: array
---

## Завдання

Реалізуйте типізовану версію `Lodash.uniq()`. `Unique<T>` приймає масив `T`, й повертає його
без повторюваних значень.

```typescript
type Res = Unique<[1, 1, 2, 2, 3, 3]>; // expected to be [1, 2, 3]
type Res1 = Unique<[1, 2, 3, 4, 4, 5, 6, 7]>; // expected to be [1, 2, 3, 4, 5, 6, 7]
type Res2 = Unique<[1, "a", 2, "b", 2, "a"]>; // expected to be [1, "a", 2, "b"]
```

## Розв'язок

У цьому завданні нам потрібно реалізувати lodash-версію функції `.uniq()` у системі типів. 
Наш тип повинен приймати єдиний тип-параметр, який є кортежем елементів. Нам потрібно відфільтрувати
дублікати звідти та залишити лише унікальні елементи.

Почну з порожнього типу:

```typescript
type Unique<T> = any;
```

Щоб перевірити, чи є елемент унікальним у кортежі, спочатку нам потрібно його дістати.
Для цього ми будемо використовувати виведення в умовних типах.

Однак ми зробимо це у зворотному порядку. Зверніть увагу на порядок унікальних елементів в
очікуваному результаті. Якщо ми напишемо `[infer H, ...infer T]`, наш кінцевий результат буде
не в правильному порядку. Отже, я спочатку дістаю останній елемент кортежу:

```typescript
type Unique<T> = T extends [...infer H, infer T] ? never : never;
```

Тепер, маючи елемент у тип-параметрі `T`, що ми повинні перевірити? 
Ми повинні перевірити, чи присутній елемент `T` в іншій частині кортежу `H`:

```typescript
type Unique<T> = T extends [...infer H, infer T]
  ? T extends H[number]
    ? never
    : never
  : never;
```

Маючи умовний тип `T extends H[number]`, ми можемо перевірити, чи присутній тип `T` в
об'єднанні елементів `H`. Якщо так, це означає, що `T` є дублікатом і його потрібно пропустити.
Тобто ми просто повертаємо все, що залишилося в `H`:

```typescript
type Unique<T> = T extends [...infer H, infer T]
  ? T extends H[number]
    ? [...Unique<H>]
    : never
  : never;
```

Але якщо його немає в `H` - це унікальний елемент! У цьому випадку ми включаємо `T` в кортеж:

```typescript
type Unique<T> = T extends [...infer H, infer T]
  ? T extends H[number]
    ? [...Unique<H>]
    : [...Unique<H>, T]
  : never;
```

Останній випадок – це коли вхідний тип-параметр `T` не кортеж. Тут ми просто
повертаємо порожній кортеж, щоб не зламати рекурсивний виклик:

```typescript
type Unique<T> = T extends [...infer H, infer T]
  ? T extends H[number]
    ? [...Unique<H>]
    : [...Unique<H>, T]
  : [];
```

Таким чином ми реалізували тип, який може повертати кортеж з унікальними елементами в ньому.

## Посилання

- [Дженерики](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Умовні типи](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Виведення в умовних типах](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Рекурсивні умовні типи](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
