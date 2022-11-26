---
id: 3312
title: Parameters
lang: uk
level: easy
tags: infer tuple built-in
---

## Завдання

Реалізуйте вбудований тип `Parameters<T>`, не використовуючи його.

## Розв'язок

В цьому завданні нам потрібно отримати частину інформації з функції. А точніше,
параметри функції. Давайте почнемо з типу, який приймає загальний тип `T`, який
ми будемо використовувати для отримання параметрів:

```typescript
type MyParameters<T> = any;
```

Тепер, як ми можемо "отримати тип, про який ми ще не знаємо"? За допомогою
виведення! Але перш ніж використовувати його, давайте почнемо з простого
умовного типу, який перевіряє чи це функція:

```typescript
type MyParameters<T> = T extends (...args: any[]) => any ? never : never;
```

Тут ми перевіряємо, чи відповідає тип `T` функції з будь-якими аргументами та
будь-яким типом повернення. Тепер ми можемо замінити `any[]` у нашому списку
параметрів на виведення:

```typescript
type MyParameters<T> = T extends (...args: infer P) => any ? never : never;
```

Таким чином, компілятор TypeScript виводить список параметрів функції в тип `P`.
Залишилося його повернути:

```typescript
type MyParameters<T> = T extends (...args: infer P) => any ? P : never;
```

## Посилання

- [Дженерики](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Умовні типи](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Виведення в умовних типах](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
