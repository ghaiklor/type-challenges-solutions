---
id: 2852
title: OmitByType
lang: uk
level: medium
tags: object
---

## Завдання

Виберіть властивості з `T`, тип яких не збігається з `U`. Наприклад:

```typescript
type OmitBoolean = OmitByType<
  {
    name: string;
    count: number;
    isReadonly: boolean;
    isEnable: boolean;
  },
  boolean
>; // { name: string; count: number }
```

## Розв'язок

Приклад у цьому завданні вже дає підказку, що нам потрібно працювати з типами
зіставлення. Маючи один тип об'єкта, нам потрібно створити інший, який буде
підмножиною першого.

Ми почнемо з порожнього типу, який потрібно реалізувати:

```typescript
type OmitByType<T, U> = any;
```

Метою тут є створення підмножини, тому давайте почнемо з копії всього об'єкта.
Це класична реалізація, яка використовує типи зіставлення:

```typescript
type OmitByType<T, U> = { [P in keyof T]: T[P] };
```

Тут відбувається перерахування всіх властивостей із тип-параметру `T`, які
переходять у створений нами новий тип об'єкта. Таким чином ми маємо копію.

Тепер нам потрібно якось відфільтрувати деякі властивості. Для цього ми можемо
використати перевизначення. Нам потрібно перевірити, чи тип значення збігається
з `U`:

```typescript
type OmitByType<T, U> = {
  [P in keyof T as T[P] extends U ? never : never]: T[P];
};
```

Якщо тип значення відповідає наданому в тип-параметрі `U`, нам потрібно
повернути тип `never`. Таким чином, цю властивість не буде включено до нового
об'єкта. А якщо типи не збігаються, нам потрібно повернути її як є:

```typescript
type OmitByType<T, U> = { [P in keyof T as T[P] extends U ? never : P]: T[P] };
```

## Посилання

- [Дженерики](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Типи зіставлення](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
- [Перевизначення ключів за допомогою as](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html#key-remapping-via-as)
- [Умовні типи](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
