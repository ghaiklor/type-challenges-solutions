---
id: 119
title: ReplaceAll
lang: ru
level: medium
tags: template-literal
---

## Проблема

Реализовать `ReplaceAll<S, From, To>` который заменяет все совпадения подстроки `From` на строку `To` в заданной строке `S`.
Например:

```typescript
type replaced = ReplaceAll<'t y p e s', ' ', ''> // expected to be 'types'
```

## Решение

Эта проблема имеет много общего с [`Replace`](./medium-replace.md).
Там мы заменяли совпадение только один раз, а здесь нужно заменить все совпадения.

Делим входную строку `S` на три части: подстрока до `From`, сам `From` и подстрока после `From`.
Используем строчные тип литералы и условные типы, чтобы вывести их.
Как только TypeScript выведет типы, он присвоит части к тип параметрам `L` и `R`.
На их основе, возвращаем новый строчный тип литерал, в котором заменен `From` на `To`.

```typescript
type ReplaceAll<
  S extends string,
  From extends string,
  To extends string
> = From extends '' ? S : S extends `${infer L}${From}${infer R}` ? `${L}${To}${R}` : S;
```

Это решение работает только с одним совпадением, как в [`Replace`](./medium-replace.md), но нам нужно заменить все.
Этого можно легко добиться, передавая наш новый тип литерал рекурсивно в `ReplaceAll`.

```typescript
type ReplaceAll<
  S extends string,
  From extends string,
  To extends string
> = From extends '' ? S : S extends `${infer L}${From}${infer R}` ? ReplaceAll<`${L}${To}${R}`, From, To> : S;
```

## Что почитать

- [Условные типы](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Выведение типов в условных типах](https://www.typescriptlang.org/docs/handbook/advanced-types.html#type-inference-in-conditional-types)
- [Рекурсивные условные типы](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
- [Строчные тип литералы](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types)
