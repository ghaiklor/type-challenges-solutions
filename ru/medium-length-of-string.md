---
id: 298
title: Length of String
lang: ru
level: medium
tags: template-literal
---

## Проблема

Вычислить длину строчного тип литерала.
Например:

```typescript
type length = LengthOfString<"Hello, World"> // expected to be 12
```

## Решение

Сначала я попробовал решение в лоб - обратиться к свойству `length` через индексные типы.
Возможно, TypeScript достаточно умный, чтобы получить оттуда значение.

```typescript
type LengthOfString<S extends string> = S['length']
```

Но, к сожалению, нет.
Результирующий тип получается `number`, но не числовой тип литерал.
Поэтому, придумаем решение креативнее.

Что если, мы выведем первую букву из строчного тип литерала и остальную часть строки рекурсивно?
Продолжаем это до тех пор, пока не останется символов в строке.
Таким образом, мы получим счетчик, который работает на рекурсии.

Начнём с типа, который выводит первую букву и остальную часть:

```typescript
type LengthOfString<S extends string> = S extends `${infer C}${infer T}` ? never : never;
```

В тип параметре `C` получаем первую букву, а в тип параметре `T` остальную часть строки.
Продолжая вызывать `LengthOfString`, указывая хвост, рано или поздно мы остановимся на случае, когда символов больше не осталось.

```typescript
type LengthOfString<S extends string> = S extends `${infer C}${infer T}` ? LengthOfString<T> : never;
```

У нас есть счётчик, но проблема теперь в том, что мы не знаем где его хранить.
Очевидно, можно добавить другой тип параметр к `LengthOfString`, который будет аккумулировать значение, но TypeScript не предоставляет возможностей управлять числами в системе типов.

Вместо этого, сделаем тип параметр с кортежом, в который будем добавлять по одной букве на каждой итерации.

```typescript
type LengthOfString<S extends string, A extends string[]> = S extends `${infer C}${infer T}` ? LengthOfString<T, [C, ...A]> : never;
```

На данном этапе, входной строчный тип литерал преобразовывается в кортеж, в котором хранятся буквы.
Как только достигаем случая, где букв больше не осталось, возвращаем длину этого кортежа.

```typescript
type LengthOfString<S extends string, A extends string[]> = S extends `${infer C}${infer T}` ? LengthOfString<T, [C, ...A]> : A['length'];
```

Добавив новый тип параметр, мы сломали тесты.
Причина этому заключается в том, что наш тип принимает два тип параметра, вместо одного.
Починим это, сделав второй тип параметр с типом по умолчанию - пустой кортеж.

```typescript
type LengthOfString<S extends string, A extends string[] = []> = S extends `${infer C}${infer T}` ? LengthOfString<T, [C, ...A]> : A['length'];
```

## Что почитать

- [Условные типы](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Выведение типов в условных типах](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Рекурсивные условные типы](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
- [Строчные тип литералы](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types)
- [Вариативные типы](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
- [Индексные типы](https://www.typescriptlang.org/docs/handbook/advanced-types.html#index-types)
