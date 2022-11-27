---
id: 4260
title: AllCombinations
lang: uk
level: medium
tags: union
---

## Завдання

Реалізуйте тип `AllCombinations<S>`, який повертає всі комбінації рядків, які
використовують символи з `S` щонайбільше один раз. Наприклад:

```typescript
type AllCombinations_ABC = AllCombinations<"ABC">;
// should be '' | 'A' | 'B' | 'C' | 'AB' | 'AC' | 'BA' | 'BC' | 'CA' | 'CB' | 'ABC' | 'ACB' | 'BAC' | 'BCA' | 'CAB' | 'CBA'
```

## Розв'язок

Мені знадобився деякий час і кілька підказок від людей, щоб вирішити цю
проблему. У деяких моментах це виявилося досить складно. Я спробую пояснити це
якомога докладніше, але не можу гарантувати, що все буде зрозуміло, вибачте. Не
соромтеся обговорювати в коментарях і пропонувати свої пояснення та рішення,
дякую!

Отже, нам потрібно побудувати комбінації букв. Перше, що спадає на думку, це
використання об'єднання символів, щоб ми могли перебрати їх у типах зіставлення.
Щоб отримати об'єднання символів із рядка, ми можемо зазирнути в інше рішення,
яке ми маємо тут – [StringToUnion](./medium-string-to-union.md). Я не збираюся
тут вдаватися в подробиці. Якщо є щось незрозуміле, перегляньте рішення для
[StringToUnion](./medium-string-to-union.md).

Добре, ось тип, щоб отримати об’єднання символів із рядка:

```typescript
type StringToUnion<S> = S extends `${infer C}${infer R}`
  ? C | StringToUnion<R>
  : never;

type R0 = StringToUnion<"ABCD">;
// type R0 = "A" | "B" | "C" | "D"
```

У двох словах ми розбиваємо рядок на перший символ і решту рядка. Перший символ
йде як елемент об'єднання, тоді як решта рекурсивно переходить до того самого
типу. Це дає нам об'єднання символів, саме те, що нам потрібно.

Маючи об'єднання символів, їх буде легше перебрати. Почнемо з порожнього типу,
який нам потрібно реалізувати:

```typescript
type AllCombinations<S> = any;
```

Тут тип-параметр `S` містить рядок, з яким нам потрібно працювати. Давайте
додамо ще один тип-параметр для зберігання об'єднання символів і назвемо його
`U`:

```typescript
type AllCombinations<S, U = StringToUnion<S>> = any;
```

Отже, коли наш тип буде викликано з рядком у `S`, тип-параметр `U` буде
заповнено об'єднанням символів `S`. Давайте подивимося на це в дії:

```typescript
type R0 = AllCombinations<"ABCD">;
// type S = 'ABCD'
// type U = 'A' | 'B' | 'C' | 'D'
```

Щоб створити комбінацію, нам потрібно взяти один символ з об'єднання і додати до
нього інші комбінації. Це триватиме, доки не залишиться жодного символу. Отже,
ми почнемо з умовного типу, який перевіряє, чи об'єднання порожнє чи ні.
Пам'ятайте, що тип `StringToUnion` повертає `never`, якщо немає символів. Отже,
ця перевірка - це фактично перевірка типу `never`:

```typescript
type AllCombinations<S, U = StringToUnion<S>> = U extends never ? never : never;
```

Якщо об’єднання порожнє, для нас це означає, що символів не залишилося, і ми
можемо повернути порожній рядок:

```typescript
type AllCombinations<S, U = StringToUnion<S>> = U extends never ? "" : never;
```

В іншому випадку нам потрібно взяти символ з об'єднання та залишок. Цього можна
просто досягти, використовуючи дистрибутивні типи зіставлення. Але щоб не
перевантажувати вас, давайте додамо тип зіставлення, який поки що повертає
просто символ:

```typescript
type AllCombinations<S, U = StringToUnion<S>> = U extends never
  ? ""
  : { [C in U]: C };
```

З цим типом у нас є об'єднання типів об'єктів, де ключі та значення є символами
рядка. Наприклад:

```typescript
type R0 = AllCombinations<"ABCD">;
// type R0 = { A: "A"; } | { B: "B"; } | { C: "C"; } | { D: "D"; }
```

Компілятор скаржиться на те, що "Type 'U' is not assignable to type 'string |
number | symbol'". Додавши обмеження над дженериком `U`, ми можемо це виправити:

```typescript
type AllCombinations<S, U extends string = StringToUnion<S>> = U extends never
  ? ""
  : { [C in U]: C };
```

Тепер, маючи об'єкти для кожного символу, ми можемо почати замінювати один
символ комбінаціями. Отже, замість `C` як значення нам потрібно мати рядок, який
починається з `C` та інших комбінацій:

```typescript
type AllCombinations<S, U extends string = StringToUnion<S>> = U extends never
  ? ""
  : { [C in U]: `${C}${AllCombinations<never, never>}` };
```

Однак під час рекурсивного виклику типу `AllCombinations` я ставлю два типи
`never` як параметри. Давайте подумаємо, що нам потрібно туди передати.

Перший тип-параметр `S` використовується як вхідний рядок, тому нам на нього
байдуже на цьому кроці, оскільки ми маємо об'єднання його символів. Другий
тип-параметр використовується як символи, з якими нам потрібно працювати. Маючи
один із них уже на місці (`C`), нам потрібно передати решту без нього. Тому ми
виключаємо `C` з об'єднання:

```typescript
type AllCombinations<S, U extends string = StringToUnion<S>> = U extends never
  ? ""
  : { [C in U]: `${C}${AllCombinations<never, Exclude<U, C>>}` };
```

Оскільки `U` є об'єднанням, нам потрібно переконатися, що умовний тип не
застосовуватиме дистрибутивність до нього під час перевірки на тип `never`. Для
цього ми беремо його у квадратні дужки. Інакше він не перевірятиме на тип
`never`. Є інше рішення, де ви можете прочитати про це більше -
[IsNever](./medium-isnever.md).

```typescript
type AllCombinations<S, U extends string = StringToUnion<S>> = [U] extends [
  never
]
  ? ""
  : { [C in U]: `${C}${AllCombinations<never, Exclude<U, C>>}` };
```

На цьому етапі у нас є комбінації символів у формі об'єктів. Щоб перетворити їх
назад в об'єднання, ми можемо використати індексні типи для типу об'єкта та
отримати все, що є в ключах `U`:

```typescript
type AllCombinations<S, U extends string = StringToUnion<S>> = [U] extends [
  never
]
  ? ""
  : { [C in U]: `${C}${AllCombinations<never, Exclude<U, C>>}` }[U];
```

Таким чином ми отримали не об'єкти у формі ключ-значення, а об'єднання всіх
значень об'єкта, які є нашими комбінаціями.

Останньою частиною головоломки є порожній рядок, доданий до нашого об’єднання:

```typescript
type AllCombinations<S, U extends string = StringToUnion<S>> = [U] extends [
  never
]
  ? ""
  : "" | { [C in U]: `${C}${AllCombinations<never, Exclude<U, C>>}` }[U];
```

Весь розв'язок з обома типами:

```typescript
type StringToUnion<S> = S extends `${infer C}${infer R}`
  ? C | StringToUnion<R>
  : never;

type AllCombinations<S, U extends string = StringToUnion<S>> = [U] extends [
  never
]
  ? ""
  : "" | { [C in U]: `${C}${AllCombinations<never, Exclude<U, C>>}` }[U];
```

## Посилання

- [Дженерики](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Обмеження дженериків](https://www.typescriptlang.org/docs/handbook/2/generics.html#generic-constraints)
- [Умовні типи](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Виведення типів в умовних типах](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Дистрибутивні умовні типи](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#distributive-conditional-types)
- [Рядкові тип-літерали](https://www.typescriptlang.org/docs/handbook/2/template-literal-types.html)
- [Об'єднання типів](https://www.typescriptlang.org/docs/handbook/2/everyday-types.html#union-types)
- [Типи зіставлення](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
