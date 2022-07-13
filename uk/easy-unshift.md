---
id: 3060
title: Unshift
lang: uk
level: easy
tags: array
---

## Завдання

Реалізувати типізовану версію `Array.unshift()`. Наприклад:

```typescript
type Result = Unshift<[1, 2], 0>; // [0, 1, 2]
```

## Розв'язок

Це завдання має багато спільного з іншим завданням - [Push](./easy-push.md).
Там, ми використали варіативні типи, щоб взяти всі елементи з масиву.

В цьому завданні ми робимо те ж саме, але в іншому порядку. Спочатку, давайте
візьмемо всі елементи з вхідного масиву:

```typescript
type Unshift<T, U> = [...T];
```

З цією частиною коду, ми отримуємо помилку компіляції "A rest element type must
be an array type". Полагодимо її, додавши обмеження на тип параметрі:

```typescript
type Unshift<T extends unknown[], U> = [...T];
```

Тепер у нас є елементи вхідного масиву в нашому кортежі. Все, що нам потрібно,
це додати новий елемент в початок кортежу:

```typescript
type Unshift<T extends unknown[], U> = [U, ...T];
```

Таким чином, ми реалізували функцію `unshift()` в системі типів TypeScript!

## Посилання

- [Дженерики](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Обмеження не дженериках](https://www.typescriptlang.org/docs/handbook/2/generics.html#generic-constraints)
- [Варіативні типи](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
