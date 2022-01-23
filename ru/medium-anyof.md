---
id: 949
title: AnyOf
lang: ru
level: medium
tags: array
---

## Проблема

Реализовать функцию `any` из языка Python на уровне типов.
Тип принимает кортеж и возвращает `true`, если любой из элементов кортежа `true`.
Если же кортеж пустой, то возвращаем `false`.
Например:

```typescript
type Sample1 = AnyOf<[1, "", false, [], {}]>; // expected to be true
type Sample2 = AnyOf<[0, "", false, [], {}]>; // expected to be false
```

## Решение

Моей первой идеей было использовать [дистрибутивные условные типы](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#distributive-conditional-types).

Мы можем использовать синтаксис `T[number]` для того, чтобы взять объединение всех элементов из кортежа.
Имея объединение элементов, переберём каждый из них и на каждой итерации будем возвращать `false` или `true` в зависимости от типа элемента.
В случае, если все итерации вернут `false`, мы получим тип `false`.
Но, если у нас будет хоть один `true`, то мы получим `boolean`.
Потому что `false | true = boolean`.
Проверяя что у нас получилось в результате, `false` или `boolean`, мы можем понять, есть ли `true` в объединении.

Но, как оказалось, реализация такого подхода выглядит не очень хорошо.
Оцените сами:

```typescript
type AnyOf<T extends readonly any[], I = T[number]> = (
  I extends any ? (I extends Falsy ? false : true) : never
) extends false
  ? false
  : true;
```

Поэтому я задумался, а можем ли мы решить это более простым способом?
Чтобы это хоть как-то можно было понять, что происходит, и не потеряться в будущем.
Оказывается, мы можем!

Давайте вспоминать о выведении типов в кортежах и о вариативных типах.
Помните, мы их использовали в решениях таких задач как [Last](./medium-last.md) или [Pop](./medium-pop.md) и им подобные.

Начнём с выведения одного элемента из кортежа и всего остального, что есть в хвосте:

```typescript
type AnyOf<T extends readonly any[]> = T extends [infer H, ...infer T]
  ? never
  : never;
```

Как мы можем проверить, что наш `H` это `false`?
Для начала, давайте создадим новый тип, в котором укажем какие элементы мы считаем за `false`:

```typescript
type Falsy = 0 | "" | false | [] | { [P in any]: never };
```

Имея такой тип, мы можем использовать условный тип для проверки, входит ли `H` в их число:

```typescript
type AnyOf<T extends readonly any[]> = T extends [infer H, ...infer T]
  ? H extends Falsy
    ? never
    : never
  : never;
```

Что нам делать, если тип оказался `false`?
Для нашей задачи это означает, что `true` ещё не найден и мы продолжим его искать.
Реализуем это через рекурсивный вызов типа с хвостом из кортежа в качестве аргумента.

```typescript
type AnyOf<T extends readonly any[]> = T extends [infer H, ...infer T]
  ? H extends Falsy
    ? AnyOf<T>
    : never
  : never;
```

Подходим всё ближе к решению проблемы.
Что если элемент `H` это не `false`?
Значит это `true`, мы нашли его!
Раз мы нашли `true` в кортеже, то продолжать нет смысла и мы просто возвращаем `true`.

```typescript
type AnyOf<T extends readonly any[]> = T extends [infer H, ...infer T]
  ? H extends Falsy
    ? AnyOf<T>
    : true
  : never;
```

Последнее состояние, которое у нас всё ещё не обработано - пустой кортеж.
В случае с пустым кортежем, наше выведение не сработает.
В таком случае, как и указано в условии задачи, мы возвращаем `false`.

```typescript
type AnyOf<T extends readonly any[]> = T extends [infer H, ...infer T]
  ? H extends Falsy
    ? AnyOf<T>
    : true
  : false;
```

Таким образом мы реализовали функцию `any` из Python на уровне системы типов у TypeScript.
Вот полное решение проблемы:

```typescript
type Falsy = 0 | "" | false | [] | { [P in any]: never };

type AnyOf<T extends readonly any[]> = T extends [infer H, ...infer T]
  ? H extends Falsy
    ? AnyOf<T>
    : true
  : false;
```

## Что почитать

- [Типы объединений](https://www.typescriptlang.org/docs/handbook/2/everyday-types.html#union-types)
- [Условные типы](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Выведение в условных типах](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Дженерики](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Вариативные типы](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
