---
id: 2
title: Get Return Type
lang: ru
level: medium
tags: infer built-in
---

## Проблема

Реализовать встроенный `ReturnType<T>`.
Пример использования:

```typescript
const fn = (v: boolean) => {
  if (v)
    return 1
  else
    return 2
}

type a = MyReturnType<typeof fn> // should be "1 | 2"
```

## Решение

Как правило, выведение типов в условных типах используется в тех местах, где мы не уверены, что ожидаем.
Как в этом случае.
Мы знаем что `T` это функция, но мы не знаем какой тип возврата ожидать.

Поэтому, воспользуемся условными типами и укажем функцию с `infer R`.
Это и будет первая итерация решения.

```typescript
type MyReturnType<T> = T extends () => infer R ? R : T;
```

В случае, если `T` присваиваемый к функции, выводим тип возврата и возвращаем.
Иначе, возвращаем `T` без изменений.
Проблема такого решения в том, что если передать функцию с параметрами, она перестанет быть присваиваемой к `() => infer R`.
Следовательно, условный тип не сработает.

Выразим в типах, что функция принимает что угодно в качестве параметров.
Нам безразлична их судьба, поэтому никаких дополнительных операций с ними не делаем.

```typescript
type MyReturnType<T> = T extends (...args: any[]) => infer R ? R : T;
```

## Что почитать

- [Условные типы](https://www.typescriptlang.org/docs/handbook/advanced-types.html#conditional-types)
- [Выведение типов в условных типах](https://www.typescriptlang.org/docs/handbook/advanced-types.html#type-inference-in-conditional-types)
