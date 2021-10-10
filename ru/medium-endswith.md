---
id: 2693
title: EndsWith
lang: ru
level: medium
tags: template-literal
---

## Проблема

Реализовать тип `EndsWith<T, U>`, который проверяет, заканчивается ли строка `T` на строку `U`.
Например:

```typescript
type R0 = EndsWith<'abc', 'bc'> // true
type R1 = EndsWith<'abc', 'abc'> // true
type R2 = EndsWith<'abc', 'd'> // false
```

## Решение

Не уверен, что эта проблема должна находится в категории среднего уровня сложности.
Это больше похоже на легкий уровень сложности, чем средний.
Но да ладно, кто я такой, чтобы судить.

Нам нужно проверить, что строка заканчивается на указанную подстроку.
Раз в деле замешаны строки, значит нам точно будут полезны строчные тип литералы.

Давайте начнем с простейшего строчного тип литерала, который отображает все возможные строки.
Так как нам содержимое, пока что, не интересно, используем тип `any`:

```typescript
type EndsWith<
  T extends string,
  U extends string
> = T extends `${any}` ? never : never
```

С помощью этого выражения мы говорим компилятору проверить, присваиваемый ли тип `T` к `any`.
Что, конечно же, так.

Теперь, давайте добавим нашу подстроку в решение.
Нам нужно проверить что подстрока `U` находится в конце строки `T`.
Давайте так и сделаем:

```typescript
type EndsWith<
  T extends string,
  U extends string
> = T extends `${any}${U}` ? never : never
```

Используя такую конструкцию, мы проверяем, что строка присваиваемая ко всему, но что должно заканчиваться на `U` - просто.
Всё что остается это вернуть `true` или `false` литералы в зависимости от результата:

```typescript
type EndsWith<
  T extends string,
  U extends string
> = T extends `${any}${U}` ? true : false
```

## Что почитать

- [Условные типы](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Строчные тип литералы](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types)
