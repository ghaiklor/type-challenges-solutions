---
id: 527
title: Append to Object
lang: uk
level: medium
tags: object-keys
---

## Завдання

Реалізуйте тип, що додає нове поле до інтерфейсу.
Тип приймає три аргументи.
Повертає об'єкт з доданим полем.

Наприклад:

```ts
type Test = { id: '1' }
type Result = AppendToObject<Test, 'value', 4> // expected to be { id: '1', value: 4 }
```

## Розв'язок

Коли ми хочемо змінити об'єкти/інтерфейси в TypeScript, зазвичай для цього бувають корисні типи перетину (intersection types).
Ця задача не виняток.
Я спробував написати тип, що приймає `T` та об'єкт з новою властивістю:

```typescript
type AppendToObject<T, U, V> = T & { [P in U]: V }
```

На жаль, це рішення не задовольняє тести.
Вони очікують плоский тип, а не перетин.
Тому нам необхідно повернути об'єкт, в якому є всі властивості разом з нашою новою.
Почнемо з того, що повернемо властивості `T`:

```typescript
type AppendToObject<T, U, V> = { [P in keyof T]: T[P] }
```

Тепер нам потрібно додати до властивостей `T` нову властивість `U`.
Для цього ми можемо передати об'єднання типів оператору `in`:

```typescript
type AppendToObject<T, U, V> = { [P in keyof T | U]: T[P] }
```

Таким чином ми отримаємо всі властивості з `T` разом з властивостями `U`, саме те, що нам потрібно.
Виправимо незначні помилки обмеживши `U`:

```typescript
type AppendToObject<T, U extends string, V> = { [P in keyof T | U]: T[P] }
```

Останнє, що TypeScript не може гарантувати - це те, що `P` може не бути в `T`, бо `P` - об'єднання `T` і `U`.
Нам необхідно додати перевірку: якщо `P` з `T` - отримаємо `T[P]`, в іншому випадку `V`:

```typescript
type AppendToObject<T, U extends string, V> = { [P in keyof T | U]: P extends keyof T ? T[P] : V }
```

## Посилання

- [Типи співставлення](https://www.typescriptlang.org/docs/handbook/advanced-types.html#mapped-types)
- [Умовні типи](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Об'єднання типів](https://www.typescriptlang.org/docs/handbook/2/everyday-types.html#union-types)
