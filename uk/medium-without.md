---
id: 5117
title: Without
lang: uk
level: medium
tags: union array
---

## Завдання

Реалізуйте типізовану версію lodash `.without()`. `Without<T, U>` приймає масив `T`,
число або масив `U` і повертає масив без елементів `U`.

```typescript
type Res = Without<[1, 2], 1>; // expected to be [2]
type Res1 = Without<[1, 2, 4, 1, 5], [1, 2]>; // expected to be [4, 5]
type Res2 = Without<[2, 3, 2, 3, 2, 3, 2, 3], [2, 3]>; // expected to be []
```

## Розв'язок

Це завдання справді було цікавим. Нам потрібно реалізувати тип, який може
фільтрувати елементи з кортежу. Починаємо з порожнього типу:

```typescript
type Without<T, U> = any;
```

Оскільки нам потрібно працювати з конкретними елементами в кортежі,
я використовую виведення, щоб отримати конкретний елемент і решту кортежу:

```typescript
type Without<T, U> = T extends [infer H, ...infer T] ? never : never;
```

Маючи елемент із кортежу, ми можемо перевірити, чи цей елемент типу `U`.
Нам потрібна ця перевірка, щоб вирішити, додавати елемент до результату чи ні:

```typescript
type Without<T, U> = T extends [infer H, ...infer T]
  ? H extends U
    ? never
    : never
  : never;
```

Якщо він дорівнює вхідному типу `U`, це означає, що він нам не потрібен у кінцевому типі.
Тому ми просто пропускаємо його і повертаємо кортеж без нього. Але, оскільки нам також
потрібно обробити інші елементи, ми повертаємо не порожній кортеж, а кортеж із рекурсивним
викликом `Without`:

```typescript
type Without<T, U> = T extends [infer H, ...infer T]
  ? H extends U
    ? [...Without<T, U>]
    : never
  : never;
```

Таким чином, ми пропускаємо все, що відповідає `U` у нашому `T`.
У випадку коли ми не повинні пропускати елемент, ми повертаємо кортеж із цим елементом:

```typescript
type Without<T, U> = T extends [infer H, ...infer T]
  ? H extends U
    ? [...Without<T, U>]
    : [H, ...Without<T, U>]
  : never;
```

Залишився останній тип `never`, з яким ми маємо розібратися. Оскільки ми працюємо
з варіативними типами і `...` оператором, замість `never` ми повинні повертати порожній кортеж:

```typescript
type Without<T, U> = T extends [infer H, ...infer T]
  ? H extends U
    ? [...Without<T, U>]
    : [H, ...Without<T, U>]
  : [];
```

Ми отримали робоче рішення для випадку, коли `U` є примітивним типом. Але в завданні
також є випадок, коли він може бути кортежем чисел. Ми можемо це вирішити за допомогою
ще одного умовного типу для `U` в `H extends U`.

Якщо `U` — це кортеж, ми повертаємо всі елементи в ньому як об'єднання, інакше — просто `U`:

```typescript
type Without<T, U> = T extends [infer H, ...infer T]
  ? H extends (U extends number[] ? U[number] : U)
    ? [...Without<T, U>]
    : [H, ...Without<T, U>]
  : [];
```

Вітаю! Ми реалізували lodash-версію методу `.without()` у системі типів.

## Посилання

- [Дженерики](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Умовні типи](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Виведення в умовних типах](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Рекурсивні умовні типи](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
