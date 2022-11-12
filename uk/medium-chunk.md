---
id: 4499
title: Chunk
lang: uk
level: medium
tags: tuple
---

## Завдання

Ви знаєте `lodash`? `Chunk` — дуже корисна функція, давайте її реалізуємо.
`Chunk<T, N>` приймає два обов'язкові тип-параметри. `T` має бути `кортежем`,
а `N` має бути `цілим числом >= 1`. Наприклад:

```typescript
type R0 = Chunk<[1, 2, 3], 2>; // expected to be [[1, 2], [3]]
type R1 = Chunk<[1, 2, 3], 4>; // expected to be [[1, 2, 3]]
type R2 = Chunk<[1, 2, 3], 1>; // expected to be [[1], [2], [3]]
```

## Розв'язок

Це завдання було міцним горішком. Але врешті-решт я знайшов рішення, яке легко зрозуміти, як на мене.
Ми починаємо з порожнього типу, який описує контракт:

```typescript
type Chunk<T, N> = any;
```

Оскільки нам потрібно накопичувати фрагменти кортежу, здається доцільним мати необов'язковий
тип-параметр `A`, який накопичуватиме фрагмент розміром `N`. За замовчуванням тип-параметр `A`
буде порожнім кортежем:

```typescript
type Chunk<T, N, A extends unknown[] = []> = any;
```

Маючи порожній акумулятор, який ми будемо використовувати як тимчасовий фрагмент,
ми можемо почати розділяти `T` на частини - перший елемент кортежу та решту:

```typescript
type Chunk<T, N, A extends unknown[] = []> = T extends [infer H, ...infer T]
  ? never
  : never;
```

Маючи частини кортежу `T`, ми можемо перевірити, чи акумулятор необхідного розміру.
Для цього, ми перевіряємо властивість `length`. Це працює, тому що ми
маємо обмеження на тип-параметр `A`, яке говорить, що це кортеж.

```typescript
type Chunk<T, N, A extends unknown[] = []> = T extends [infer H, ...infer T]
  ? A["length"] extends N
    ? never
    : never
  : never;
```

Якщо акумулятор порожній або в ньому недостатньо елементів, нам потрібно продовжувати
розділяти `T`, доки він не матиме потрібного розміру. Для цього ми продовжуємо рекурсивно
викликати тип `Chunk` із новим акумулятором. Ми передаємо в нього `A` та елемент `H` з `T`:

```typescript
type Chunk<T, N, A extends unknown[] = []> = T extends [infer H, ...infer T]
  ? A["length"] extends N
    ? never
    : Chunk<T, N, [...A, H]>
  : never;
```

Рекурсивний виклик продовжується до тих пір, поки ми не отримаємо акумулятор необхідного
розміру `N`. Це наш перший фрагмент, який нам потрібно повернути в результаті. Отже, ми
повертаємо новий кортеж із акумулятором у ньому:

```typescript
type Chunk<T, N, A extends unknown[] = []> = T extends [infer H, ...infer T]
  ? A["length"] extends N
    ? [A]
    : Chunk<T, N, [...A, H]>
  : never;
```

При цьому ми ігноруємо решту кортежу `T`. Отже, нам потрібно додати ще один
рекурсивний виклик до нашого результату `[A]`, який очистить акумулятор і почне
той самий процес:

```typescript
type Chunk<T, N, A extends unknown[] = []> = T extends [infer H, ...infer T]
  ? A["length"] extends N
    ? [A, Chunk<T, N>]
    : Chunk<T, N, [...A, H]>
  : never;
```

Ця рекурсивна магія триває, доки в кортежі `T` не буде елементів.
У такому випадку ми просто повертаємо все, що залишилося в акумуляторі.
Це потрібно, тому що ми можемо мати випадок, коли розмір акумулятора буде меншим за `N`,
й ми втратимо елементи якщо його не повернемо.

```typescript
type Chunk<T, N, A extends unknown[] = []> = T extends [infer H, ...infer T]
  ? A["length"] extends N
    ? [A, Chunk<T, N>]
    : Chunk<T, N, [...A, H]>
  : [A];
```

Є ще один випадок, коли втрачається елемент `H`. Коли ми отримали акумулятор необхідного
розміру, ми ігноруємо виведений `H`. Щоб це виправити, нам потрібно передавати `H` в наступний `Chunk`:

```typescript
type Chunk<T, N, A extends unknown[] = []> = T extends [infer H, ...infer T]
  ? A["length"] extends N
    ? [A, Chunk<[H, ...T], N>]
    : Chunk<T, N, [...A, H]>
  : [A];
```

Це рішення працює для деяких тестів, що чудово. Однак у нас є випадок, коли рекурсивний
виклик типу `Chunk` повертає кортежі в кортежі в кортежі (через рекурсивні виклики).
Щоб виправити це, давайте додамо `...` до нашого `Chunk<[H, ...T], N>`:

```typescript
type Chunk<T, N, A extends unknown[] = []> = T extends [infer H, ...infer T]
  ? A["length"] extends N
    ? [A, ...Chunk<[H, ...T], N>]
    : Chunk<T, N, [...A, H]>
  : [A];
```

Всі тести пройдено! Ура... крім граничного випадку з порожнім кортежем.
Це лише граничний випадок, і ми можемо додати умовний тип, щоб його покрити.
Якщо акумулятор порожній у базовому випадку, ми повертаємо порожній кортеж.
В іншому випадку повертаємо сам акумулятор, як і раніше:

```typescript
type Chunk<T, N, A extends unknown[] = []> = T extends [infer H, ...infer T]
  ? A["length"] extends N
    ? [A, ...Chunk<[H, ...T], N>]
    : Chunk<T, N, [...A, H]>
  : A[number] extends never
  ? []
  : [A];
```

Це все, що нам потрібно, щоб реалізувати lodash-версію функції `.chunk()` у системі типів!

## Посилання

- [Дженерики](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Обмеження дженериків](https://www.typescriptlang.org/docs/handbook/2/generics.html#generic-constraints)
- [Умовні типи](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Виведення типів в умовних типах](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Варіативні типи](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
- [Індексні типи](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)
