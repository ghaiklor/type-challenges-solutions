---
id: 5140
title: Trunc
lang: uk
level: medium
tags: template-literal
---

## Завдання

Реалізуйте типізовану версію `Math.trunc`, яка приймає рядок або число та
повертає цілу частину числа шляхом видалення дробової частини. Наприклад:

```typescript
type A = Trunc<12.34>; // 12
```

## Розв'язок

Ми можемо легко отримати частину числа перед крапкою, якщо саме число буде
рядком. В такому випадку, потрібно просто розділити рядок через крапку та взяти
першу частину.

Завдяки рядковим тип-літералам у TypeScript це легко зробити. Отже, спочатку ми
почнемо з порожнього типу, який нам потрібно реалізувати:

```typescript
type Trunc<T> = any;
```

У нас є єдиний тип-параметр, який прийматиме саме число. Як ми вже говорили,
буде легко отримати першу частину, розділивши рядок, тому нам потрібно
перетворити число в рядок:

```typescript
type Trunc<T> = `${T}`;
```

Отримуємо помилку: “Type 'T' is not assignable to type 'string | number | bigint
| boolean | null | undefined”. Щоб виправити це, додамо обмеження над
тип-параметром `T`:

```typescript
type Trunc<T extends number | string> = `${T}`;
```

Тепер у нас є рядкове представлення нашого числа. Далі ми можемо використати
умовний тип, щоб перевірити, чи рядок має крапку. Якщо так, ми виведемо його
частини:

```typescript
type Trunc<T extends number | string> = `${T}` extends `${infer R}.${infer _}`
  ? never
  : never;
```

За допомогою цієї перевірки ми можемо розрізняти випадки, коли крапка існує, а
коли її немає.

У випадку коли крапка існує, ми отримаємо фрагмент перед крапкою в тип-параметрі
`R` і зможемо його повернути, ігноруючи частину після крапки:

```typescript
type Trunc<T extends number | string> = `${T}` extends `${infer R}.${infer _}`
  ? R
  : never;
```

Але що повертати, якщо крапки в рядку немає? Ну, це означає, що немає чого
обрізати, тому ми повертаємо вхідний тип без змін:

```typescript
type Trunc<T extends number | string> = `${T}` extends `${infer R}.${infer _}`
  ? R
  : `${T}`;
```

Таким чином, ми проходимо всі тести на момент написання розв'язку!

## Посилання

- [Дженерики](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Обмеження дженериків](https://www.typescriptlang.org/docs/handbook/2/generics.html#generic-constraints)
- [Рядкові тип-літерали](https://www.typescriptlang.org/docs/handbook/2/template-literal-types.html)
- [Умовні типи](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Виведення в умовних типах](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
