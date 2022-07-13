---
id: 949
title: AnyOf
lang: uk
level: medium
tags: array
---

## Завдання

Реалізувати функцію `any` із мови Python на рівні типів. Тип приймає кортеж й
повертає `true`, якщо будь-який із елементів кортежу `true`. Якщо ж кортеж
порожній, то повертаємо `false`. Наприклад:

```typescript
type Sample1 = AnyOf<[1, "", false, [], {}]>; // expected to be true
type Sample2 = AnyOf<[0, "", false, [], {}]>; // expected to be false
```

## Розв'язок

Моя перша ідея була використати
[дистрибутивні умовні типи](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#distributive-conditional-types).

Ми можемо використати синтаксис `T[number]` для того, щоб взяти об'єднання всіх
елементів з кортежу. Маючи об'єднання елементів, переберемо кожен із них, й на
кожній ітерації будемо повертати `false` або `true` в залежності від типу
елемента. У випадку, якщо всі ітерації повернуть `false`, ми отримаємо тип
`false`. Але, якщо у нас буде хоч один `true`, то ми отримаємо `boolean`. Тому
що `false | true = boolean`. Перевіряючи що ми отримали в результаті, `false` чи
`boolean`, ми можемо зрозуміти, чи є `true` в об'єднанні.

Але, як виявилося, реалізація такого підходу виглядає не дуже добре. Оцініть
самі:

```typescript
type AnyOf<T extends readonly any[], I = T[number]> = (
  I extends any ? (I extends Falsy ? false : true) : never
) extends false
  ? false
  : true;
```

Тому я задумався, а чи можемо ми вирішити це простішим способом? Щоб, хоч якось,
можна було зрозуміти, що відбувається, і не загубитися в майбутньому.
Виявляється, ми можемо!

Давайте згадувати про виведення типів в кортежах і про варіативні типи.
Пам'ятаєте, ми їх використовували в розв'язках таких задач як
[Last](./medium-last.md) чи [Pop](./medium-pop.md) і їм подібні.

Почнемо з виведення одного елементу із кортежу й решти, що є в хвості:

```typescript
type AnyOf<T extends readonly any[]> = T extends [infer H, ...infer T]
  ? never
  : never;
```

Як ми можемо перевірити, що наший `H` це `false`? Для початку, давайте створимо
новий тип, в якому вкажемо елементи, які ми вважаємо `false`:

```typescript
type Falsy = 0 | "" | false | [] | { [P in any]: never };
```

Маючи такий тип, ми можемо використати умовний тип для перевірки, чи входить `H`
в їх число:

```typescript
type AnyOf<T extends readonly any[]> = T extends [infer H, ...infer T]
  ? H extends Falsy
    ? never
    : never
  : never;
```

Що нам робити, якщо тип виявився `false`? Для нашого завдання це означає, що
`true` ще не знайдено й ми продовжимо його шукати. Реалізуємо це через
рекурсивний виклик типу з хвостом із кортежу, в якості аргументу.

```typescript
type AnyOf<T extends readonly any[]> = T extends [infer H, ...infer T]
  ? H extends Falsy
    ? AnyOf<T>
    : never
  : never;
```

Підходимо все ближче до розв'язку проблеми. Що якщо елемент `H` це не `false`?
Тоді це `true`, ми знайшли його! Якщо ми знайшли `true` в кортежі, то
продовжувати немає сенсу й ми просто повертаємо `true`.

```typescript
type AnyOf<T extends readonly any[]> = T extends [infer H, ...infer T]
  ? H extends Falsy
    ? AnyOf<T>
    : true
  : never;
```

Останній стан, який у ми ще не опрацювали - порожній кортеж. У випадку з
порожнім кортежом, наше виведення не спрацює. В такому випадку, як і вказано в
умові завдання, ми повертаємо `false`.

```typescript
type AnyOf<T extends readonly any[]> = T extends [infer H, ...infer T]
  ? H extends Falsy
    ? AnyOf<T>
    : true
  : false;
```

Таким чином ми реалізували функцію `any` з Python на рівні системи типів у
TypeScript. Ось повний розв'язок завдання:

```typescript
type Falsy = 0 | "" | false | [] | { [P in any]: never };

type AnyOf<T extends readonly any[]> = T extends [infer H, ...infer T]
  ? H extends Falsy
    ? AnyOf<T>
    : true
  : false;
```

## Посилання

- [Типи об'єднань](https://www.typescriptlang.org/docs/handbook/2/everyday-types.html#union-types)
- [Умовні типи](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Виведення в умовних типах](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Дженерики](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Варіативні типи](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
