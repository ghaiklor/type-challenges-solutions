---
id: 529
title: Absolute
lang: uk
level: medium
tags: math template-literal
---

## Завдання

Реалізуйте тип `Absolute`.
Він має приймати `string`, `number` або `bigint`. Результатом повинно бути додатне число у вигляді рядка.

Наприклад:

```typescript
type Test = -100;
type Result = Absolute<Test>; // expected to be "100"
```

## Розв'язок

Найлегший спосіб отримати модуль числа - це конвертувати число в рядок й прибрати знак "-".
Я не жартую, в буквальному сенсі прибрати "-" з рядка.

Почнемо з перевірки чи є знак "-" на початку рядка. Якщо так, то виводимо все що залишилося, використовуючи умовні типи.
В інакшому випадку, у нас додатне число, тому повертаємо його без змін:

```typescript
type Absolute<T extends number | string | bigint> = T extends `-${infer N}` ? N : T;
```

Таким чином, якщо вкажемо `T = “-50”`, це відповідатиме нашому шаблону `“-<N>”` де `N` буде `"50"`, й ми його повернемо.

Та ми бачимо, що деякі з тестів все ще не проходять.
Це тому, що ми не завжди повертаємо рядки.
Наприклад, якщо передати додатне число, воно не збіжиться з рядком в умовному типі й повернеться число замість рядка.

Виправимо це, загорнувши тип `T` в рядковий тип-літерал, перед тим, як його повертати.

```typescript
type Absolute<T extends number | string | bigint> = T extends `-${infer N}` ? N : `${T}`;
```

Все ще не проходять тести...
Ми не опрацьовуємо випадок, коли `T` це від'ємне число.
Число знову не співпадає з нашою умовою, виведення не спрацьовує й ми повертаємо негативне число, тільки в рядку.
Щоб подолати це, загорнемо число в рядковий тип-літерал на початку:

```typescript
type Absolute<T extends number | string | bigint> = `${T}` extends `-${infer N}` ? N : `${T}`;
```

В результаті, ми отримали тип, який приймає `number`, `string`, `bigint` й конвертує їх в рядок.
Потім він виводить частину рядка без знаку "-", або повертає його без змін.

## Посилання

- [Рядкові тип літерали](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types)
- [Умовні типи](https://www.typescriptlang.org/docs/handbook/advanced-types.html#conditional-types)
- [Виведення типів в умовних типах](https://www.typescriptlang.org/docs/handbook/advanced-types.html#type-inference-in-conditional-types)
