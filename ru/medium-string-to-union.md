---
id: 531
title: String to Union
lang: ru
level: medium
tags: union string
---

## Проблема

Реализовать `StringToUnion<T>`, который принимает строчный тип литерал и возвращает объединение из его символов.
Например:

```typescript
type Test = '123';
type Result = StringToUnion<Test>; // expected to be "1" | "2" | "3"
```

## Решение #1

В этой проблеме нужно перебрать все символы из строчного тип литерала и добавить их в объединение.
Начнём с первого - перебора.
Воспользуемся условными типами со строчными тип литералами и выведём первую букву и остальную часть.

```typescript
type StringToUnion<T extends string> = T extends `${infer C}${infer T}` ? never : never
```

В тип параметрах `C` и `T` получаем первую букву строки и её хвост.
Чтобы продолжить перебор, вызовем `StringToUnion` снова с параметром `T`.
Таким образом, будет происходить рекурсивный перебор.

```typescript
type StringToUnion<T extends string> = T extends `${infer C}${infer T}` ? StringToUnion<T> : never
```

Единственное что осталось - объединение.
На каждой итерации перебора, добавим тип параметр `C` к результату от `StringToUnion<T>`.
Так как базовый случай `StringToUnion<T>` это `never`, получим `C1 | C2 | CN | never`.

```typescript
type StringToUnion<T extends string> = T extends `${infer C}${infer T}` ? C | StringToUnion<T> : never
```

## Решение #2

Попробуем решить задачу, воспользовавшись наработками из задачи [`Length of String`](./medium-length-of-string.md) - используем аккумулятор.
Разделим строку на первый и остальные символы, на каждом шаге сохраняя первый символ в аккумуляторе.
При этом строка с одним символом будет разделена на сам символ и пустую строку. Вызов типа с пустой строкой запустит второе выражение тернарного оператора.
Всё, что остаётся нам сделать - это создать объединение из всех элементов аккумулятора:

```typescript
type StringToUnion<T extends string, A extends string[] = []> = T extends `${infer H}${infer T}` ? StringToUnion<T, [...A, H]> : A[number]

```

## Что почитать

- [Условные типы](https://www.typescriptlang.org/docs/handbook/advanced-types.html#conditional-types)
- [Выведение типов в условных типах](https://www.typescriptlang.org/docs/handbook/advanced-types.html#type-inference-in-conditional-types)
- [Рекурсивные условные типы](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
- [Строчные тип литералы](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types)
- [Типы объединений](https://www.typescriptlang.org/docs/handbook/unions-and-intersections.html#union-types)
