---
id: 5821
title: MapTypes
lang: uk
level: medium
tags: map object utils
---

## Завдання

Реалізуйте `MapTypes<T, R>`, який перетворить типи в об'єкті `T` на інші типи,
визначені типом `R`, який має таку структуру:

```typescript
type StringToNumber = {
  mapFrom: string; // value of key which value is string
  mapTo: number; // will be transformed for number
};
```

Наприклад:

```typescript
type StringToNumber = { mapFrom: string; mapTo: number };
MapTypes<{ iWillBeANumberOneDay: string }, StringToNumber>; // gives { iWillBeANumberOneDay: number; }
```

Майте на увазі, що користувач може надати об’єднання типів:

```typescript
type StringToNumber = { mapFrom: string; mapTo: number };
type StringToDate = { mapFrom: string; mapTo: Date };
MapTypes<{ iWillBeNumberOrDate: string }, StringToDate | StringToNumber>; // gives { iWillBeNumberOrDate: number | Date; }
```

Якщо тип не існує у нашій мапі, залиште його як є:

```typescript
type StringToNumber = { mapFrom: string; mapTo: number };
MapTypes<
  { iWillBeANumberOneDay: string; iWillStayTheSame: Function },
  StringToNumber
>; // // gives { iWillBeANumberOneDay: number, iWillStayTheSame: Function }
```

## Розв'язок

Якщо типи об'єктів у завданні, то на допомогу приходять типи зіставлення! Нам
потрібно перебрати властивості об'єкту і перевизначити типи їхніх значень.

Почнемо з порожнього типу, який нам потрібно реалізувати:

```typescript
type MapTypes<T, R> = any;
```

Тип-параметр `T` містить тип об'єкта, який нам потрібно обробити, а `R` містить
правила трансформації типів. Давайте визначимо інтерфейс трансформації як
обмеження над дженериком `R`:

```typescript
type MapTypes<T, R extends { mapFrom: unknown; mapTo: unknown }> = any;
```

Перш ніж робити якісь перетворення, давайте почнемо з простого типу зіставлення,
який копіює вхідний `T`:

```typescript
type MapTypes<T, R extends { mapFrom: unknown; mapTo: unknown }> = {
  [P in keyof T]: T[P];
};
```

Тепер, маючи тип, який "копіює" тип об'єкта, ми можемо почати додавати туди
якісь перетворення. Спочатку давайте перевіримо, чи тип значення збігається з
типом `mapFrom` відповідно до специфікації завдання:

```typescript
type MapTypes<T, R extends { mapFrom: unknown; mapTo: unknown }> = {
  [P in keyof T]: T[P] extends R["mapFrom"] ? never : never;
};
```

Якщо вони збігаються, це означає, що нам потрібно замінити цей тип на тип із
`mapTo`:

```typescript
type MapTypes<T, R extends { mapFrom: unknown; mapTo: unknown }> = {
  [P in keyof T]: T[P] extends R["mapFrom"] ? R["mapTo"] : never;
};
```

В іншому випадку, згідно зі специфікацією нам потрібно залишити тип як є:

```typescript
type MapTypes<T, R extends { mapFrom: unknown; mapTo: unknown }> = {
  [P in keyof T]: T[P] extends R["mapFrom"] ? R["mapTo"] : T[P];
};
```

На даний момент ми проходимо всі тести, окрім того, що стосується об'єднання. У
специфікації завдання зазначено, що існує можливість вказати правила
трансформації як об'єднання об'єктів.

Отже, нам потрібно перебрати правила трансформації теж. Для цього ми можемо
почати із заміни `R['mapTo']` на умовний тип. Умовні типи в TypeScript є
дистрибутивними, тобто вони перебиратимуть кожен елемент в об'єднанні. Однак це
стосується типу, який стоїть на початку умовного типу. Отже, ми починаємо з
тип-параметру `R` і перевіряємо чи він збігається із типом значення:

```typescript
type MapTypes<T, R extends { mapFrom: unknown; mapTo: unknown }> = {
  [P in keyof T]: T[P] extends R["mapFrom"]
    ? R extends { mapFrom: T[P] }
      ? never
      : never
    : T[P];
};
```

Дистрибутивні умовні типи виконуватимуть прохід по `R`, і якщо в якийсь момент
буде збіг із типом значення `T[P]`, ми його повертаємо:

```typescript
type MapTypes<T, R extends { mapFrom: unknown; mapTo: unknown }> = {
  [P in keyof T]: T[P] extends R["mapFrom"]
    ? R extends { mapFrom: T[P] }
      ? R["mapTo"]
      : never
    : T[P];
};
```

## Посилання

- [Дженерики](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Обмеження дженериків](https://www.typescriptlang.org/docs/handbook/2/generics.html#generic-constraints)
- [Типи зіставлення](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
- [Індексні типи](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)
- [Умовні типи](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
