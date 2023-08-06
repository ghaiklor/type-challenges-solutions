---
id: 3326
title: BEM Style String
lang: uk
level: medium
tags: template-literal union tuple
---

## Завдання

Методологія Блок, Елемент, Модифікатор (БЕМ) — це популярне правило іменування
класів у CSS.

Наприклад, компонент блоку буде представлений як `btn`, елемент, який залежить
від блоку, буде представлений як `btn__price`, модифікатор, який змінює стиль
блоку, буде представлений як `btn--big` або `btn__price--warning`.

Реалізуйте `BEM<B, E, M>`, який генеруватиме об'єднання рядків із цих трьох
параметрів. Де `B` — рядковий літерал, `E` і `M` — це масиви рядків (можуть бути
порожніми).

## Розв'язок

У цьому завданні нас просять створити певний рядок, дотримуючись правил. Є 3
правила, яких ми повинні дотримуватися: Блок, Елемент і Модифікатор. Щоб
спростити загальний вигляд рішення, я пропоную розділити їх на три окремі типи.

Почнемо з першого - Блок:

```typescript
type Block<B extends string> = any;
```

Це досить просто, тому що все, що нам тут потрібно зробити, це просто повернути
рядковий тип-літерал, що містить параметр вхідного типу:

```typescript
type Block<B extends string> = `${B}`;
```

Наступний — Елемент. Це не рядковий тип-літерал, як це було з Блоком, тому що ми
маємо випадок, коли масив елементів порожній. Тому нам потрібно перевірити, чи
масив не порожній, і якщо так, створити рядок. Знаючи, що порожній масив
повертає тип `never`, коли до нього звертаються як `T[number]`, ми можемо
перевірити його за допомогою умовного типу:

```typescript
type Element<E extends string[]> = E[number] extends never ? never : never;
```

Якщо масив з елементами порожній, ми просто повертаємо порожній тип-літерал (нам
не потрібен рядок із префіксом `__`):

```typescript
type Element<E extends string[]> = E[number] extends never ? `` : never;
```

Коли ми знаємо, що масив не порожній, нам потрібно додати префікс `__`, а потім
об’єднати ці елементи в тип-літерал:

```typescript
type Element<E extends string[]> = E[number] extends never
  ? ``
  : `__${E[number]}`;
```

Ту саму логіку ми застосовуємо до останнього - Модифікатора. У випадку, якщо
масив з модифікаторами порожній - повертаємо порожній тип-літерал. В іншому
випадку повертаємо префікс із об’єднанням модифікаторів:

```typescript
type Modifier<M extends string[]> = M[number] extends never
  ? ``
  : `--${M[number]}`;
```

Залишилося об’єднати ці 3 типи в наш початковий тип:

```typescript
type BEM<
  B extends string,
  E extends string[],
  M extends string[],
> = `${Block<B>}${Element<E>}${Modifier<M>}`;
```

Повне рішення, яке включає всі 4 типи, виглядає так:

```typescript
type Block<B extends string> = `${B}`;
type Element<E extends string[]> = E[number] extends never
  ? ``
  : `__${E[number]}`;
type Modifier<M extends string[]> = M[number] extends never
  ? ``
  : `--${M[number]}`;
type BEM<
  B extends string,
  E extends string[],
  M extends string[],
> = `${Block<B>}${Element<E>}${Modifier<M>}`;
```

## Посилання

- [Дженерики](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Обмеження дженериків](https://www.typescriptlang.org/docs/handbook/2/generics.html#generic-constraints)
- [Рядкові тип-літерали](https://www.typescriptlang.org/docs/handbook/2/template-literal-types.html)
- [Умовні типи](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
