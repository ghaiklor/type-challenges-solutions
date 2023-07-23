---
id: 8640
title: Number Range
lang: uk
level: medium
tags: union number
---

## Завдання

Іноді ми хочемо обмежити діапазон чисел... Наприклад:

```typescript
type result = NumberRange<2, 9>; // | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9
```

## Розв'язок

Я люблю виклики, пов'язані з арифметикою, і водночас ненавиджу їх. Вони складні
й побудовані на обхідних рішеннях. Я люблю їх за те, що вони складні, і
ненавиджу їх за те, що вони побудовані на обхідних рішеннях.

У будь-якому випадку, почнемо з цифр. Нам потрібно отримати об'єднання чисел,
конкретних чисел. Щоб отримати об'єднання чисел, ми можемо просто використати
типи пошуку. Наприклад, маючи кортеж із діапазоном 0-5 і використовуючи тип
пошуку для типу `number`, ми можемо отримати об'єднання:

```typescript
type R0 = [0, 1, 2, 3, 4, 5][number];
// R0 is 0 | 1 | 2 | 3 | 4 | 5
```

Це означає, що ми можемо вирішити завдання, якщо у нас є кортеж із потрібними
числами всередині. Як його створити?

Ми можемо почати зі створення кортежу певної довжини. Давайте назвемо тип, який
його створює - `Tuple`. Тип матиме єдиний тип-параметр `L`, який ми можемо
використовувати для визначення довжини кортежу:

```typescript
type Tuple<L extends number> = any;
```

Наприклад, ми хочемо створити кортеж довжиною 2. Отже, наш параметр типу `L`
буде 2. Що з ним потрібно порівнювати?

Маючи кортеж, ми можемо використовувати типи пошуку, щоб отримати властивість
`length`. Він поверне довжину кортежу як число. А якщо довжина кортежу дорівнює
параметру типу `L` – маємо:

```typescript
type Tuple<L extends number> = A["length"] extends L ? never : never;
```

Давайте додамо тип-параметр `A` (Accumulator) до нашого типу і за замовчуванням
зробимо його порожнім, щоб виправити помилку компіляції про те, що тип-параметр
`A` не визначено:

```typescript
type Tuple<L extends number, A extends never[] = []> = A["length"] extends L
  ? never
  : never;
```

Тепер, маючи акумулятор довжини 0 і необхідної довжини 2, ми не задовольняємо
умову. У такому випадку ми викликаємо себе рекурсивно, але вставляємо елемент в
акумулятор, поки його довжина не дорівнюватиме необхідній:

```typescript
type Tuple<L extends number, A extends never[] = []> = A["length"] extends L
  ? never
  : Tuple<L, [...A, never]>;
```

Як тільки ми отримаємо потрібну довжину акумулятора, ми пройдемо умовний тип і
зможемо його повернути:

```typescript
type Tuple<L extends number, A extends never[] = []> = A["length"] extends L
  ? A
  : Tuple<L, [...A, never]>;
```

Користуватися типом досить просто. Наприклад, передаючи 5 як довжину кортежу, ми
отримуємо 5 `never`:

```typescript
type R0 = Tuple<5>;
// R0 is [never, never, never, never, never]
```

У нас є тип, який створює кортеж необхідної довжини, заповнений типом `never`. А
тепер повернемося до завдання.

Існують `L` і `H` параметри, які вказують мінімум і максимум діапазону:

```typescript
type NumberRange<L, H> = any;
```

Створення кортежу довжини `L`, заповненого `never`, дасть нам діапазон 0-L, який
поміщається в акумулятор `A` за замовчуванням:

```typescript
type NumberRange<
  L extends number,
  H extends number,
  A extends number[] = Tuple<L>,
> = any;
```

Перебуваючи зараз у позиції `L`, нам потрібно почати заповнювати кортеж
фактичними числами, які ми будемо використовувати для об'єднання пізніше.
Оскільки наші значення в кортежі відповідають індексам, які вони мають, ми
можемо просто використовувати властивість `length` як значення:

```typescript
type NumberRange<
  L extends number,
  H extends number,
  A extends number[] = Tuple<L>,
> = [...A, A["length"]];
```

Отже, ми отримали всі `never` до `L`, а тепер ми отримуємо фактичні числа від
`L` і більше. Це потрібно повторювати рекурсивно, доки ми не дійдемо до позиції
`H`. Отже, ми перевіряємо, чи дорівнює довжина акумулятора `H`, і якщо ні –
рекурсія:

```typescript
type NumberRange<
  L extends number,
  H extends number,
  A extends number[] = Tuple<L>,
> = A["length"] extends H ? never : NumberRange<L, H, [...A, A["length"]]>;
```

На даний момент ми маємо кортеж типів `never` до позиції `L` і фактичних чисел
до позиції `H`. Єдине, що залишилося, це повернути побудований акумулятор у
випадку, якщо довжина дорівнює `H`:

```typescript
type NumberRange<
  L extends number,
  H extends number,
  A extends number[] = Tuple<L>,
> = A["length"] extends H ? A : NumberRange<L, H, [...A, A["length"]]>;
```

Однак акумулятор не включає останній елемент. Тому ми додаємо значення `length`
до кортежу також:

```typescript
type NumberRange<
  L extends number,
  H extends number,
  A extends number[] = Tuple<L>,
> = A["length"] extends H
  ? [...A, A["length"]]
  : NumberRange<L, H, [...A, A["length"]]>;
```

На даний момент у нас є потрібний кортеж. Він має діапазон типу `never` від `0`
до `L` і чисел від `L` до `H`. Тип `never` ігнорується в об'єднанні, тому ми не
думаємо про це. Єдине, що залишилося, це використати тип пошуку з типом `number`
і отримати об'єднання:

```typescript
type NumberRange<
  L extends number,
  H extends number,
  A extends number[] = Tuple<L>,
> = A["length"] extends H
  ? [...A, A["length"]][number]
  : NumberRange<L, H, [...A, A["length"]]>;
```

Повне рішення, включаючи тип `Tuple`:

```typescript
type Tuple<L extends number, A extends never[] = []> = A["length"] extends L
  ? A
  : Tuple<L, [...A, never]>;

type NumberRange<
  L extends number,
  H extends number,
  A extends number[] = Tuple<L>,
> = A["length"] extends H
  ? [...A, A["length"]][number]
  : NumberRange<L, H, [...A, A["length"]]>;
```

Я знаю, спочатку важко все це зрозуміти. Не поспішайте, перечитайте це кілька
разів, слідуйте коду, і ви зрозумієте це миттєво.

## Посилання

- [Дженерики](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Обмеження дженериків](https://www.typescriptlang.org/docs/handbook/2/generics.html#generic-constraints)
- [Індексні типи](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)
- [Умовні типи](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Варіативні типи](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
- [Рекурсивні умовні типи](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
