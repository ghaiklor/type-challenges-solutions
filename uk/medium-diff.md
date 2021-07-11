---
id: 645
title: Diff
lang: uk
level: medium
tags: object
---

## Завдання

Обчисліть різницю між об'єктами `O` & `O1`.
Наприклад:

```typescript
type Foo = {
  name: string
  age: string
}

type Bar = {
  name: string
  age: string
  gender: number
}

type test0 = Diff<Foo, Bar> // expected { gender: number }
```

## Розв'язок

Очевидно, що в нашому завданні потрібно маніпулювати об'єктами.
Тому, ймовірно, типи зіставлення тут зіграють свою роль.

Почнемо з типу, в якому перебираємо об'єднання властивостей двох об'єктів.
Перш ніж шукати різницю двох об'єктів, потрібно зібрати всі їх властивості.

```typescript
type Diff<O, O1> = { [P in keyof O | keyof O1]: never }
```

Коли ми перебираємо ключі першого чи другого об'єкта, перевіряємо чи існує властивість на тому чи іншому об'єкті.
Додамо умовний тип, в якому перевіримо наявність властивостей в об'єктах:

```typescript
type Diff<O, O1> = { [P in keyof O | keyof O1]: P extends keyof O ? O[P] : P extends keyof O1 ? O1[P] : never }
```

Чудово!
У нас є об'єкт, який містить в собі об'єднання двох об'єктів.
Останнє, що потрібно зробити — відфільтрувати ті властивості, які існують у двох об'єктах одночасно.

Але як ми можемо знати які властивості існують у двох об'єктах?
Типи перетинів!
Візьмемо перетин властивостей двох об'єктів, й виключимо типи в перетині з нашого типу `P`:

```typescript
type Diff<O, O1> = { [P in keyof O | keyof O1 as Exclude<P, keyof O & keyof O1>]: P extends keyof O ? O[P] : P extends keyof O1 ? O1[P] : never }
```

## Посилання

- [Типи зіставлення](https://www.typescriptlang.org/docs/handbook/advanced-types.html#mapped-types)
- [Перепризначення в типах зіставлення](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#key-remapping-in-mapped-types)
- [Типи об'єднань](https://www.typescriptlang.org/docs/handbook/unions-and-intersections.html#union-types)
- [Типи перетинів](https://www.typescriptlang.org/docs/handbook/unions-and-intersections.html#intersection-types)
- [Індексні типи](https://www.typescriptlang.org/docs/handbook/advanced-types.html#index-types)
- [Умовні типи](https://www.typescriptlang.org/docs/handbook/advanced-types.html#conditional-types)
- [keyof й типи пошуку](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-1.html#keyof-and-lookup-types)
