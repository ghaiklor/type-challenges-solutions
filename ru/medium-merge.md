---
id: 599
title: Merge
lang: ru
level: medium
tags: object
---

## Проблема

Слить два типа в один.
Ключи второго типа переопределяют ключи из первого.
Например:

```typescript
type Foo = {
  a: number;
  b: string;
};

type Bar = {
  b: number;
};

type merged = Merge<Foo, Bar>; // expected { a: number; b: number }
```

## Решение

Эта проблема напомнила мне ["Append to Object"](./medium-append-to-object.md).
Мы использовали объединения типов, чтобы собрать все свойства объекта и строку в один тип.

Такой же трюк проделаем и здесь.
Возьмем ключи первого и второго типов и после объединим их.
В результате, получим объект, в котором ключи из первого и второго типов.

```typescript
type Merge<F, S> = { [P in keyof F | keyof S]: never };
```

Имея ключи двух объектов, начнём проставлять типы их значений.
Начинаем с типа `S`, потому что у него выше приоритет, он переопределяет свойство из типа `F`.
Для этого, проверяем, а есть ли свойство на типе `S`.
Если да, через индексы поиска получаем тип его значения.

```typescript
type Merge<F, S> = { [P in keyof F | keyof S]: P extends keyof S ? S[P] : never };
```

В случае, свойства нету, проверяем есть ли такое же свойство на типе `F`.
И если да, берём тип значения оттуда.

```typescript
type Merge<F, S> = { [P in keyof F | keyof S]: P extends keyof S ? S[P] : P extends keyof F ? F[P] : never };
```

## Что почитать

- [Объединения типов](https://www.typescriptlang.org/docs/handbook/2/everyday-types.html#union-types)
- [keyof и типы поиска](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-1.html#keyof-and-lookup-types)
- [Сопоставляющие типы](https://www.typescriptlang.org/docs/handbook/advanced-types.html#mapped-types)
- [Условные типы](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
