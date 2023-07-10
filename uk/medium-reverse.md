---
id: 3192
title: Reverse
lang: uk
level: medium
tags: tuple
---

## Завдання

Реалізуйте типізовану версію `Array.reverse()`. Наприклад:

```typescript
type a = Reverse<["a", "b"]>; // ['b', 'a']
type b = Reverse<["a", "b", "c"]>; // ['c', 'b', 'a']
```

## Розв'язок

Перевернути кортеж простіше, ніж здається. Вам потрібно отримати останній
елемент кортежу і поставити його першим в інший кортеж. Рекурсивне продовження
цієї операції дає нам зворотний кортеж у кінці.

Ми починаємо з типу, в який потрібно додати реалізацію:

```typescript
type Reverse<T> = any;
```

Тепер, як ми говорили раніше, нам потрібно отримати останній елемент кортежу та
його решту. Для цього застосуйте виведення в умовних типах:

```typescript
type Reverse<T> = T extends [...infer H, infer T] ? never : never;
```

Зверніть увагу на `...` оператор, який ми маємо в першій частині кортежу. За
допомогою цієї конструкції ми говоримо: "TypeScript, дай нам весь кортеж без
останнього елемента, а останній елемент признач тип-параметру `T`". Маючи
останній елемент, ми можемо створити новий кортеж і вставити в нього `T`:

```typescript
type Reverse<T> = T extends [...infer H, infer T] ? [T] : never;
```

Таким чином, ми отримуємо останній елемент як перший. Але нам потрібно
застосувати ту саму операцію до інших елементів у кортежі. Це легко досягти,
викликавши `Reverse` знову рекурсивно:

```typescript
type Reverse<T> = T extends [...infer H, infer T] ? [T, Reverse<H>] : never;
```

Але виклик `Reverse` дасть нам кортеж всередині кортежу, і чим частіше ми його
викликаємо, тим більшу глибину отримуємо. Це не те, чого ми хочемо. Натомість
нам потрібно отримати звичайний кортеж. Ми можемо це зробити, застосувавши
оператор `...` до результату типу `Reverse`:

```typescript
type Reverse<T> = T extends [...infer H, infer T] ? [T, ...Reverse<H>] : never;
```

Що робити, якщо тип-параметр `T` не відповідає нашому шаблону? У цьому випадку
ми повертаємо порожній кортеж, щоб не зламати `...` оператор:

```typescript
type Reverse<T> = T extends [...infer H, infer T] ? [T, ...Reverse<H>] : [];
```

## Посилання

- [Дженерики](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Умовні типи](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Виведення в умовних типах](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Рекурсивні умовні типи](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
- [Варіативні типи](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
