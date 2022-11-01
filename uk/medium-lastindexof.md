---
id: 5317
title: LastIndexOf
lang: uk
level: medium
tags: array
---

## Завдання

Реалізуйте типізовану версію `Array.lastIndexOf`. `LastIndexOf<T, U>` приймає
масив `T`, будь-який `U` й повертає індекс останнього `U` в масиві `T`. Наприклад:

```typescript
type Res1 = LastIndexOf<[1, 2, 3, 2, 1], 2>; // 3
type Res2 = LastIndexOf<[0, 0, 0], 2>; // -1
```

## Розв'язок

Щоб знайти останній індекс у кортежі, ми можемо просто почати з перерахування
його з правого боку, доки не знайдемо елемент. Після цього, маючи збіг,
дізнаємося його позицію. Звучить досить просто, тож почнемо.

Як зазвичай, порожній тип для початку:

```typescript
type LastIndexOf<T, U> = any;
```

У цьому типі ми маємо два тип-параметри `T` і `U`, де `T` — це кортеж, а `U` — елемент,
який ми шукаємо. Почнемо з умовного типу, де ми виводимо дві частини кортежу. Одна частина
є останнім елементом (`I`), а інша — залишком (`R`):

```typescript
type LastIndexOf<T, U> = T extends [...infer R, infer I] ? never : never;
```

Коли у нас є елемент з правого боку, ми можемо перевірити, чи він дорівнює елементу,
який ми шукаємо. Для цього є вбудований тип `Equal`:

```typescript
type LastIndexOf<T, U> = T extends [...infer R, infer I]
  ? Equal<I, U> extends true
    ? never
    : never
  : never;
```

Що станеться, якщо вони однакові? Це означає, що елемент знайдено, але який в нього індекс? Ну,
індекс такий же, як і довжина залишку ліворуч, чи не так? Тому ми можемо використовувати
довжину залишку як індекс:

```typescript
type LastIndexOf<T, U> = T extends [...infer R, infer I]
  ? Equal<I, U> extends true
    ? R["length"]
    : never
  : never;
```

Якщо збігу немає, ми повинні продовжувати шукати індекс рекурсивно:

```typescript
type LastIndexOf<T, U> = T extends [...infer R, infer I]
  ? Equal<I, U> extends true
    ? R["length"]
    : LastIndexOf<R, U>
  : never;
```

Нарешті, якщо збігів взагалі не знайдено, ми повертаємо `-1` як відповідь:

```typescript
type LastIndexOf<T, U> = T extends [...infer R, infer I]
  ? Equal<I, U> extends true
    ? R["length"]
    : LastIndexOf<R, U>
  : -1;
```

## Посилання

- [Дженерики](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Умовні типи](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Виведення в умовних типах](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Індексні типи](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)
- [Рекурсивні умовні типи](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
- [Варіативні типи](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
