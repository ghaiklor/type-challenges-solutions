---
id: 3312
title: Parameters
lang: ru
level: easy
tags: infer tuple built-in
---

## Проблема

Реализовать встроенный `Parameters<T>` не используя его. Этот тип принимает функцию и возвращает тип параметров, переданных в неё.

## Решение

Объявим тип, принимающий дженерик `T`:

```typescript
type MyParameters<T> = any;
```

С помощью условных типов проверим, что получаем функцию:

```typescript
type MyParameters<T> = T extends (...args: any[]) => any ? never : never;
```

Здесь мы проверяем, что `T` соответствует функции принимающей не известное количество аргументов и возвращающей не известное значение. Дальше распакуем параметры, переданные в функцию, заменив `any[]` на `infer P`:

```typescript
type MyParameters<T> = T extends (...args: infer P) => any ? never : never;
```

Как только TypeScript выяснит, что за типы находятся внутри `args`, он
присвоит их параметру `P`. Таким образом нам осталось только вернуть `P` в нашей правдивой
ветке условного типа:

```typescript
type MyParameters<T> = T extends (...args: infer P) => any ? P : never;
```

## Что почитать

- [Дженерики](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Условные типы](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Выведение типов в условных типах](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
