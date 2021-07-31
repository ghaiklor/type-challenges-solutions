---
id: 108
title: Trim
lang: uk
level: medium
tags: template-literal
---

## Завдання

Реалізувати `Trim<T>`, який приймає рядковий тип-літерал й повертає новий, в якому видалені пробіли з обох боків.
Наприклад:

```typescript
type trimmed = Trim<'  Hello World  '> // expected to be 'Hello World'
```

## Розв'язок

Завдання схоже на [`TrimLeft<T>`](./medium-trimleft.md).
Відрізняється тільки тим, що тут потрібно видалити пробіли з обох боків.
Використаємо ті ж рядкові тип-літерали, щоб змоделювати потрібну поведінку.

На відміну від [`TrimLeft<T>`](./medium-trimleft.md), тут три випадки: пробіли з лівого боку, пробіли з правого боку й рядок без пробілів.

Почнемо з моделювання ситуації, коли пробіли ліворуч.
Об'єднуючи рядкові тип-літерали з умовними типами, виводимо пробіл й решту рядка.
Продовжуючи виводити рекурсивно, позбавляємося від пробілів ліворуч.

```typescript
type Trim<S> = S extends ` ${infer R}` ? Trim<R> : S;
```

Коли пробіли з лівого боку прибрані, перевіримо чи є пробіли з правого боку й зробимо те саме.

```typescript
type Trim<S> = S extends ` ${infer R}` ? Trim<R> : S extends `${infer L} ` ? Trim<L> : S;
```

В такий спосіб прибираємо пробіли з лівого боку, потім — з правого боку.
Цей процес продовжується, поки пробілів не залишиться й ми повернемо вхідний рядок без змін.

Але, отримуємо помилку в тестах.
Це через те, що ми не опрацьовуємо випадок з перенесенням рядків й табуляцією.

Вирішимо це додаванням цих символів в об'єднання.
Щоб уникнути дублювання, винесемо це в окремий тип:

```typescript
type Whitespace = ' ' | '\n' | '\t';
type Trim<S> = S extends `${Whitespace}${infer R}` ? Trim<R> : S extends `${infer L}${Whitespace}` ? Trim<L> : S;
```

## Посилання

- [Об'єднання типів](https://www.typescriptlang.org/docs/handbook/2/everyday-types.html#union-types)
- [Умовні типи](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Виведення типів в умовних типах](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Рекурсивні умовні типи](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
- [Рядкові тип-літерали](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types)
