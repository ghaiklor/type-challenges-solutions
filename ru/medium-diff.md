---
id: 645
title: Diff
lang: ru
level: medium
tags: object
---

## Проблема

Вычислите разницу между объектами `O` & `O1`.
Например:

```typescript
type Foo = {
  name: string
  age: string
}

type Bar = {
  name: string
  age: string
  gender: number
}

type test0 = Diff<Foo, Bar> // expected { gender: number }
```

## Решение

Очевидно, что в этой проблеме нужно манипулировать объектами.
Поэтому, вероятно, что сопоставляющие типы здесь сыграют свою роль.

Начнём с сопоставляющего типа, в котором перебираем объединение свойств двух объектов.
Прежде чем искать разницу двух объектов, нужно же собрать все их свойства в один.

```typescript
type Diff<O, O1> = { [P in keyof O | keyof O1]: never }
```

Когда мы перебираем ключи первого или второго объекта, проверяем, а существует ли свойство на том или ином объекте.
Добавим условный тип, в котором проверим наличие свойств в объектах:

```typescript
type Diff<O, O1> = { [P in keyof O | keyof O1]: P extends keyof O ? O[P] : P extends keyof O1 ? O1[P] : never }
```

Отлично!
У нас есть объект, который содержит в себе объединение двух объектов.
Последнее что нужно сделать - отфильтровать те свойства, которые существуют в двух объектах одновременно.

Но как мы можем узнать какие свойства существуют в двух объектах?
Типы пересечений!
Возьмем пересечение свойств двух объектов и исключим типы в пересечении из нашего сопоставляющего типа `P`:

```typescript
type Diff<O, O1> = { [P in keyof O | keyof O1 as Exclude<P, keyof O & keyof O1>]: P extends keyof O ? O[P] : P extends keyof O1 ? O1[P] : never }
```

## Что почитать

- [Сопоставляющие типы](https://www.typescriptlang.org/docs/handbook/advanced-types.html#mapped-types)
- [Переназначение в сопоставляющих типах](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#key-remapping-in-mapped-types)
- [Типы объединений](https://www.typescriptlang.org/docs/handbook/unions-and-intersections.html#union-types)
- [Типы пересечений](https://www.typescriptlang.org/docs/handbook/unions-and-intersections.html#intersection-types)
- [Индексные типы](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)
- [Условные типы](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [keyof и типы поиска](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-1.html#keyof-and-lookup-types)
