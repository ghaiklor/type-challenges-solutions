---
id: 4471
title: Zip
lang: uk
level: medium
tags: tuple
---

## Завдання

У цьому завданні ви повинні реалізувати тип `Zip<T, U>`, де `T` і `U` мають бути `Tuple`:

```typescript
// expected to be [[1, true], [2, false]]
type R = Zip<[1, 2], [true, false]>;
```

## Розв'язок

Почнемо з порожнього типу, який ми будемо використовувати для реалізації.
Тип-параметр `T` використовується, щоб отримати перший кортеж,
який нам потрібно з'єднати, а `U` - другий:

```typescript
type Zip<T, U> = any;
```

Перш ніж приступити до реалізації, дозвольте мені навести вам приклад того,
що тут означає з'єднати. Наприклад, якщо у вас є кортеж `[1, 2]` і кортеж `[true, false]`,
вам потрібно об'єднати перші елементи кортежу в новий кортеж - `[1, true]`.
Потім зробити те ж саме, але з другими - `[2, false]`.
Зрештою, помістіть ці кортежі в інший кортеж - `[[1, true], [2, false]]`.
Ось що означає з'єднати.

Як бачите, нам потрібно мати можливість отримати перший елемент кортежу.
Ми можемо зробити це за допомогою виведення! Візьмемо перший кортеж `T` і
виведемо з нього елемент (`TI`) та хвіст (`TT`):

```typescript
type Zip<T, U> = T extends [infer TI, ...infer TT] ? never : never;
```

Але у нас є ще один кортеж, який ми не врахували. Тож робимо те саме для `U` —
виводимо елемент (`UI`) й хвіст (`UT`):

```typescript
type Zip<T, U> = T extends [infer TI, ...infer TT]
  ? U extends [infer UI, ...infer UT]
    ? never
    : never
  : never;
```

Якщо в обох кортежах є елемент і хвіст, ми можемо з'єднати їх разом.
Для цього ми повертаємо кортеж із `TI` і `UI`:

```typescript
type Zip<T, U> = T extends [infer TI, ...infer TT]
  ? U extends [infer UI, ...infer UT]
    ? [TI, UI]
    : never
  : never;
```

Проблема в тому, що ми не обробляємо інші елементи. Ми просто отримуємо один кортеж, і все.
Щоб вирішити це, нам потрібно знову викликати `Zip` з хвостами кортежів. Крім того,
не забувайте, що нам потрібен кортеж з кортежів, тому ми знову загортаємо його в квадратні дужки:

```typescript
type Zip<T, U> = T extends [infer TI, ...infer TT]
  ? U extends [infer UI, ...infer UT]
    ? [[TI, UI], Zip<TT, UT>]
    : never
  : never;
```

Добре мати тип, який можна викликати рекурсивно. Але використовуючи тип `Zip`,
ми отримуємо в кінці кортеж кортежів, який опиняється всередині нашого кортежу кортежів.
Нам це не потрібно. Тож розгортаємо результат виклику `Zip`:

```typescript
type Zip<T, U> = T extends [infer TI, ...infer TT]
  ? U extends [infer UI, ...infer UT]
    ? [[TI, UI], ...Zip<TT, UT>]
    : never
  : never;
```

Останнє питання, на яке потрібно відповісти - що робити, коли хвоста більше немає?
Замість того, щоб повертати тип `never`, ми можемо повернути лише порожній кортеж, щоб
не зламати рекурсивний виклик.

```typescript
type Zip<T, U> = T extends [infer TI, ...infer TT]
  ? U extends [infer UI, ...infer UT]
    ? [[TI, UI], ...Zip<TT, UT>]
    : []
  : [];
```

## Посилання

- [Умовні типи](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Виведення в умовних типах](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Варіативні типи](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
