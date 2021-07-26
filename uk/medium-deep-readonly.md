---
id: 9
title: Deep Readonly
lang: uk
level: medium
tags: readonly object-keys deep
---

## Завдання

Реалізувати тип `DeepReadonly<T>` який робить властивості об'єкту незмінними (рекурсивно!).
Наприклад:

```typescript
type X = {
  x: {
    a: 1
    b: 'hi'
  }
  y: 'hey'
}

type Expected = {
  readonly x: {
    readonly a: 1
    readonly b: 'hi'
  }
  readonly y: 'hey'
}

const todo: DeepReadonly<X> // should be same as `Expected`
```

## Розв'язок

Це завдання схоже з тим, що ми розв'язували в [`Readonly<T>`](./easy-readonly.md).
Відрізняється тільки тим, що тут потрібно це робити рекурсивно.

Почнемо з класичної реалізації і зробимо [`Readonly<T>`](./easy-readonly.md):

```typescript
type DeepReadonly<T> = { readonly [P in keyof T]: T[P] }
```

Але, як ви вже здогадалися, цей тип не зробить всі властивості незмінними, а тільки ті, що знаходяться на першому рівні вкладеності.
Причина в тому, що якщо `T[P]` це не примітив, а об'єкт, то його властивості залишаться неопрацьованими.

Тому, замінимо `T[P]` на рекурсивний виклик `DeepReadonly<T>`.
І оскільки ми вже почали використовувати рекурсію, не забуваємо про базовий випадок.
Алгоритм простий.
Якщо, `T[P]` - об'єкт, рухаємося в глибину й викликаємо `DeepReadonly`, в інакшому випадку — повертаємо `T[P]` без змін.

```typescript
type DeepReadonly<T> = { readonly [P in keyof T]: T[P] extends Record<string, unknown> ? DeepReadonly<T[P]> : T[P] }
```

## Посилання

- [Індексні типи](https://www.typescriptlang.org/docs/handbook/advanced-types.html#index-types)
- [Типи зіставлення](https://www.typescriptlang.org/docs/handbook/advanced-types.html#mapped-types)
- [Умовні типи](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Рекурсивні умовні типи](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
