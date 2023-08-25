---
id: 116
title: Replace
lang: ru
level: medium
tags: template-literal
---

## Проблема

Реализовать `Replace<S, From, To>` который заменяет искомую строку `From` в `S`
на строку `To`. Например:

```typescript
type replaced = Replace<"types are fun!", "fun", "awesome">; // expected to be 'types are awesome!'
```

## Решение

Начнем с того, что разобъем строку на три части: подстрока до `From`, сама
подстрока `From` и подстрока после `From`. Используя условные типы этого легко
добиться:

```typescript
type Replace<
  S,
  From extends string,
  To,
> = S extends `${infer L}${From}${infer R}` ? S : S;
```

Как только TypeScript вывел типы, это означает что `From` найден и окружающие
его части попадают в тип параметры `L` и `R`. Вернём новый строчный тип литерал,
который создаем из этих выведенных кусков и строки `To`.

```typescript
type Replace<
  S,
  From extends string,
  To extends string,
> = S extends `${infer L}${From}${infer R}` ? `${L}${To}${R}` : S;
```

Решение работает без проблем, кроме случая, когда `From` это пустая строка. В
таком случае, TypeScript не сможет вывести типы. Починим это, как отдельный
случай для пустой строки:

```typescript
type Replace<
  S extends string,
  From extends string,
  To extends string,
> = From extends ""
  ? S
  : S extends `${infer L}${From}${infer R}`
  ? `${L}${To}${R}`
  : S;
```

## Что почитать

- [Условные типы](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Выведение типов в условных типах](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Строчные тип литералы](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types)
