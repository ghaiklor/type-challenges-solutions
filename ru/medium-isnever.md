---
id: 1042
title: IsNever
lang: ru
level: medium
tags: union utils
---

## Проблема

Реализовать тип `IsNever<T>`, который принимает тип `T`.
Если тип `T` это `never`, вернуть `true`, иначе `false`.
Например:

```typescript
type A = IsNever<never> // expected to be true
type B = IsNever<undefined> // expected to be false
type C = IsNever<null> // expected to be false
type D = IsNever<[]> // expected to be false
type E = IsNever<number> // expected to be false
```

## Решение

Решение в лоб - проверить, можно ли присвоить тип `T` к `never` с помощью условных типов.
Если `T` присваиваемый к `never`, возвращаем `true`, иначе `false`.

```typescript
type IsNever<T> = T extends never ? true : false
```

К сожалению, не проходим тест с `never`.
Почему?

Тип `never` представляет из себя тип значений, которые никогда не должны случиться.
Тип `never` это подтип каждого типа в TypeScript, а значит, можно присвоить `never` к каждому типу.
Но, нету ни одного типа, который был бы подтипом `never`, а значит, ничего нельзя присвоить к `never` (кроме самого `never`).

Это приводит к другой проблеме.
Как можно проверить, что тип `T` присваиваемый к `never`, если мы не можем присваивать к `never`?

Давайте создадим новый тип с `never` внутри, почему нет?
Что если, мы будем проверять что тип `T` присваиваемый не к самому `never`, а к кортежу с `never` внутри?
В таком случае, формально, мы не будем пытаться присвоить каждый тип к `never`.

```typescript
type IsNever<T> = [T] extends [never] ? true : false
```

С таким костылем, хаком, креативным решением, называйте как хотите; мы реализовали тип, который может проверить, является ли `T` типом `never`.

## Что почитать

- [Тип never](https://www.typescriptlang.org/docs/handbook/basic-types.html#never)
- [Условные типы](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Дженерики](https://www.typescriptlang.org/docs/handbook/2/generics.html)
