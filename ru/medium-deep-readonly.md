---
id: 9
title: Deep Readonly
lang: ru
level: medium
tags: readonly object-keys deep
---

## Проблема

Реализовать тип `DeepReadonly<T>` который делает свойства объекта неизменяемыми (рекурсивно!).
Например:

```typescript
type X = {
  x: {
    a: 1;
    b: "hi";
  };
  y: "hey";
};

type Expected = {
  readonly x: {
    readonly a: 1;
    readonly b: "hi";
  };
  readonly y: "hey";
};

const todo: DeepReadonly<X>; // should be same as `Expected`
```

## Решение

Эта проблема схожая с тем, что мы делали в [`Readonly<T>`](./easy-readonly.md).
Разница в том, что здесь нужно делать это рекурсивно.

Начнём с классической реализации и сделаем [`Readonly<T>`](./easy-readonly.md):

```typescript
type DeepReadonly<T> = { readonly [P in keyof T]: T[P] };
```

Но, как вы уже догадались, этот тип не сделает все свойства неизменяемыми, а только те, что находятся на первом уровне вложенности.
Причина заключается в том, что если `T[P]` это не примитив, а объект, то его свойства останутся нетронутыми, а значит не будут неизменяемыми.

Поэтому, заменим `T[P]` на рекурсивный вызов `DeepReadonly<T>`.
И раз мы уже начали использовать рекурсивный вызов, не забываем о базовом случае.
Алгоритм простой.
В случае, если `T[P]` это объект, идём вглубь и вызываем `DeepReadonly`, иначе - возвращаем `T[P]` без изменений.

```typescript
type DeepReadonly<T> = {
  readonly [P in keyof T]: T[P] extends Record<string, unknown>
    ? DeepReadonly<T[P]>
    : T[P];
};
```

## Что почитать

- [Индексные типы](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)
- [Сопоставляющие типы](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
- [Условные типы](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Рекурсивные условные типы](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
