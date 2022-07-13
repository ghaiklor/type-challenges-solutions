---
id: 2595
title: PickByType
lang: uk
level: medium
tags: object
---

## Завдання

З вхідного параметру `T` виберіть ті властивості, які можна привласнити до `U`.
Наприклад:

```typescript
type OnlyBoolean = PickByType<
  {
    name: string;
    count: number;
    isReadonly: boolean;
    isEnable: boolean;
  },
  boolean
>; // { isReadonly: boolean; isEnable: boolean; }
```

## Розв'язок

В цій проблемі нам потрібно перебрати всі ключі об'єкта. В момент перебору, нам
потрібно відфільтрувати й залишити тільки ті ключі, які можна привласнити до
`U`. Очевидно, що почати нам потрібно з типів зіставлення.

Так що давайте почнемо з того, що зробимо копію вхідного об'єкту:

```typescript
type PickByType<T, U> = { [P in keyof T]: T[P] };
```

Спочатку, ми отримали всі ключі з `T` й застосували до них ітерацію. Під час
кожної ітерації, TypeScript візьме ключ й привласнить його до тип параметру `P`.
Маючи цей ключ, ми можемо отримати потрібний нам тип з використанням конструкції
`T[P]`.

Тепер, застосовуючи фільтр до цієї ітерації, ми можемо залишити тільки потрібні
нам ключі. Коли я кажу "фільтр", я маю на увазі перевизначення ключа в цій
ситуації. Ми можемо перевизначити ключ під час кожної ітерації й залишити тільки
ті що нас цікавлять:

```typescript
type PickByType<T, U> = {
  [P in keyof T as T[P] extends U ? never : never]: T[P];
};
```

Зверніть увагу на ключове слово `as`. Це оператор, який замінить наший тип `P`
на тип вказаний за допомогою `as`. І нас нічого не зупиняє від того, щоб
написати умовний тип після `as`. За допомогою умовного типу ми й перевіримо нашу
умову.

У випадку, якщо тип значення із об'єкту привласнюється до типу, який вказаний в
`U` - залишаємо ключ без змін. Але, якщо тип не привласнюється, то в такому
випадку ми повинні його ігнорувати - повертаємо `never`:

```typescript
type PickByType<T, U> = { [P in keyof T as T[P] extends U ? P : never]: T[P] };
```

Таким чином, ми реалізували тип, який може фільтрувати ключ об'єктів по їх
типам.

## Посилання

- [Типи зіставлення](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
- [Перевизначення ключів за допомогою as](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html#key-remapping-via-as)
- [Умовні типи](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [keyof й типи пошуку](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-1.html#keyof-and-lookup-types)
