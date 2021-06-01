---
id: 20
title: Promise.all
lang: uk
level: medium
tags: array built-in
---

## Завдання

Типізувати функцію `PromiseAll`, яка приймає масив `PromiseLike` об'єктів і повертає `Promise<T>`, де `T`, це масив типів результату виконання `Promise`.

```typescript
const promise1 = Promise.resolve(3);
const promise2 = 42;
const promise3 = new Promise<string>((resolve, reject) => {
  setTimeout(resolve, 100, 'foo');
});

// expected to be `Promise<[number, number, string]>`
const p = Promise.all([promise1, promise2, promise3] as const)
```

## Розв'язок

Почнемо з простого – функція що повертає `Promise<T>`.

```typescript
declare function PromiseAll<T>(values: T): Promise<T>
```

Тепер треба придумати, як вирахувати типи з виконаних `Promise`.
Почнемо з факту, що `values` це масив.
Виразимо це в наших типах.

Використовуючи [варіативні типи](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types) вказуємо, що `values` це масив, а `T` елементи цього масиву:

```typescript
declare function PromiseAll<T extends unknown[]>(values: [...T]): Promise<T>
```

Отримуємо помилку “Argument of type ‘readonly [1, 2, 3]’ is not assignable to parameter of type ‘[1, 2, 3]’.“.
Тому що `values` не очікує модифікатор `readonly` в параметрі.
Виправимо це, додавши модифікатор до параметра функції:

```typescript
declare function PromiseAll<T extends unknown[]>(values: readonly [...T]): Promise<T>
```

В нас є рішення, яке проходить один з тестів.
Це тому, що цей тест не містить `Promise`.
Ми повертаємо такий самий масив, який ми отримали в `values`.
Але як тільки ми отримуємо `Promise`, як елемент `values`, наше рішення перестає працювати.

Це тому, що ми не розгорнули `Promise`, а повернули його.
Замінимо тип `T` на умовний тип, який буде перевіряти, чи є елемент `Promise`.
Якщо елемент це `Promise` то повертаємо внутрішній тип, інакше – тип без змін.

```typescript
declare function PromiseAll<T extends unknown[]>(values: readonly [...T]): Promise<T extends Promise<infer R> ? R : T>
```

Рішення досі неробоче, тому що `T`, не об'єднання, а кортеж.
Тож, потрібно проітерувати всі елементи кортежу і перевірити, є поточний елемент `Promise` чи ні.

```typescript
declare function PromiseAll<T extends unknown[]>(values: readonly [...T]): Promise<{ [P in keyof T]: T[P] extends Promise<infer R> ? R : T[P] }>
```

## Посилання

- [Варіативні типи](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
- [Типи співставлення (mapped types)](https://www.typescriptlang.org/docs/handbook/advanced-types.html#mapped-types)
- [Типи пошуку/індексні типи](https://www.typescriptlang.org/docs/handbook/advanced-types.html#index-types)
- [Умовні типи](https://www.typescriptlang.org/docs/handbook/advanced-types.html#conditional-types)
- [Виведення типів в умовних типах](https://www.typescriptlang.org/docs/handbook/advanced-types.html#type-inference-in-conditional-types)
