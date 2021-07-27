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

## Решение

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

## Что почитать

- [Условные типы](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Выведение типов в условных типах](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Рекурсивные условные типы](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
- [Строчные тип литералы](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types)
- [Типы объединений](https://www.typescriptlang.org/docs/handbook/2/everyday-types.html#union-types)
