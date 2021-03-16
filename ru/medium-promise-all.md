---
id: 20
title: Promise.all
lang: ru
level: medium
tags: array built-in
---

## Проблема

Типизировать функцию `Promise.all`, которая принимает массив из `PromiseLike` объектов.
Типом возврата должен быть `Promise<T>`, где `T` это массив из типов результатов выполненных обещаний.
Например:

```typescript
const promise1 = Promise.resolve(3);
const promise2 = 42;
const promise3 = new Promise<string>((resolve, reject) => {
  setTimeout(resolve, 100, 'foo');
});

// expected to be `Promise<[number, number, string]>`
const p = Promise.all([promise1, promise2, promise3] as const)
```

## Решение

Начнём с малого - функция которая возвращает `Promise<T>`.

```typescript
declare function PromiseAll<T>(values: T): Promise<T>
```

Теперь, давайте подумаем, как вычислить типы выполненных обещаний.
Есть такая деталь, как то, что `values` это массив.
Выразим это в наших типах.
Используя вариативные типы, укажем, что `values` это массив, а `T` элементы этого массива:

```typescript
declare function PromiseAll<T extends unknown[]>(values: [...T]): Promise<T>
```

Получаем ошибку “Argument of type ‘readonly [1, 2, 3]’ is not assignable to parameter of type ‘[1, 2, 3]’.“.
Это потому, что наш `values` не ожидает модификатор `readonly` в параметре.
Починим это, добавив модификатор к параметру функции:

```typescript
declare function PromiseAll<T extends unknown[]>(values: readonly [...T]): Promise<T>
```

У нас есть решение, которое даже работает на одном тесте, а на других нет.
Всё потому, что этот тест не содержит в себе `Promise`.
Мы возвращаем такой же массив, какой мы получили в `values`.
Но как только мы получаем `Promise`, как элемент `values`, решение перестает работать.

Распакуем `Promise`, вместо того, чтобы возвращать его без изменений.
Заменим `Promise<T>` на условный тип, который проверяет, является ли элемент `Promise`.
Если да, возвращаем внутренний тип `Promise`, иначе - тип без изменений.

```typescript
declare function PromiseAll<T extends unknown[]>(values: readonly [...T]): Promise<T extends Promise<infer R> ? R : T>
```

Решение ещё не рабочее, потому что `T` это не объединение, а кортеж.
Условные типы не являются дистрибутивными на кортежах, поэтому наша проверка не срабатывает.

Делаем свой перебор через сопоставляющие типы, в котором и проверяем, является ли элемент `Promise` или нет.

```typescript
declare function PromiseAll<T extends unknown[]>(values: readonly [...T]): Promise<{ [P in keyof T]: T[P] extends Promise<infer R> ? R : T[P] }>
```

## Что почитать

- [Вариативные типы](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
- [Сопоставляющие типы](https://www.typescriptlang.org/docs/handbook/advanced-types.html#mapped-types)
- [Индексные типы](https://www.typescriptlang.org/docs/handbook/advanced-types.html#index-types)
- [Условные типы](https://www.typescriptlang.org/docs/handbook/advanced-types.html#conditional-types)
- [Выведение типов в условных типах](https://www.typescriptlang.org/docs/handbook/advanced-types.html#type-inference-in-conditional-types)
