---
id: 43
title: Exclude
lang: ru
level: easy
tags: built-in
---

## Проблема

Реализовать встроенный тип `Exclude<T, U>`.
Пример использования:

```typescript
type T0 = Exclude<"a" | "b" | "c", "a">; // expected "b" | "c"
type T1 = Exclude<"a" | "b" | "c", "a" | "b">; // expected "c"
```

## Решение

Для решения этой проблемы нужно знать, что условные типы в TypeScript дистрибутивные.
То есть, когда вы пишите `T extends U`, где `T` это объединение элементов, TypeScript будет перебирать каждый элемент из `T` и применять условие к каждому из них.

Основываясь на этой возможности системы типов, наше решение будет выглядеть просто.
Проверяем, что `T` можно присвоить к типу `U` и, если это так, пропускаем `T`, возвращая `never`.
Иначе, это значит что текущий элемент из `T` не находится в `U`, а значит можем его вернуть в результате.

```typescript
type MyExclude<T, U> = T extends U ? never : T;
```

## Что почитать

- [Дистрибутивные условные типы](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#distributive-conditional-types)
