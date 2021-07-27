---
id: 1042
title: IsNever
lang: uk
level: medium
tags: union utils
---

## Завдання

Реалізувати тип `IsNever<T>`, який приймає тип `T`.
Якщо тип `T` це `never`, повернути `true`, інакше - `false`.
Наприклад:

```typescript
type A = IsNever<never> // expected to be true
type B = IsNever<undefined> // expected to be false
type C = IsNever<null> // expected to be false
type D = IsNever<[]> // expected to be false
type E = IsNever<number> // expected to be false
```

## Розв'язок

Розв'язок в лоб — перевірити, чи можна привласнити тип `T` до `never` за допомогою умовних типів.
Якщо `T` привласнюється до `never`, повертаємо `true`, в інакшому випадку - `false`.

```typescript
type IsNever<T> = T extends never ? true : false
```

На жаль, не проходимо тест `never`.
Чому?

Тип `never` являє собою тип значень, які ніколи не повинні статися.
Тип `never` це підтип кожного типу в TypeScript, тобто, можна привласнити `never` до кожного типу.
Але, немає ні одного типу, який був би підтипом `never`, інакше кажучи, нічого не можна привласнити до `never` (крім самого `never`).

Це призводить до іншої проблеми.
Як можна перевірити, що тип `T` можна привласнити до `never`, якщо ми не можемо привласнювати до `never`?

Створімо новий тип з `never` всередині, чому ні?
Що, якщо, ми будемо перевіряти, що тип `T` привласнюється не до самого `never`, а до кортежу з `never` всередині?
В такому випадку, формально, ми не будемо намагатися привласнити кожен тип до `never`.

```typescript
type IsNever<T> = [T] extends [never] ? true : false
```

З таким трюком, хаком, креативним рішенням, називайте як хочете; ми реалізували тип, який може перевірити, чи є `T` типом `never`.

## Посилання

- [Тип never](https://www.typescriptlang.org/docs/handbook/2/narrowing.html#the-never-type)
- [Умовні типи](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Дженерики](https://www.typescriptlang.org/docs/handbook/2/generics.html)
