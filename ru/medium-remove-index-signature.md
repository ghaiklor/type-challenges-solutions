---
id: 1367
title: Remove Index Signature
lang: ru
level: medium
tags: object-keys
---

## Проблема

Реализовать `RemoveIndexSignature<T>`, который исключает индексную сигнатуру с объектов.
Например:

```typescript
type Foo = {
  [key: string]: any;
  foo(): void;
}

type A = RemoveIndexSignature<Foo> // expected { foo(): void }
```

## Решение

Мы имеем дело с объектами в этом случае.
Уверен, нам понадобятся сопоставляющие типы.
Но, пока что, давайте разберемся в проблеме и что нам нужно сделать.

Нас попросили исключить индексные сигнатуры из объектных типов.
Как эти сигнатуры выглядят?
Используя оператор `keyof`, посмотрим, как TypeScript видит такие сигнатуры с точки зрения ключей объекта.

Например, имея тип "Bar", на котором вызовем `keyof`, мы увидим следующую картину:

```typescript
type Bar = { [key: number]: any; bar(): void; } // number | “bar”
```

Получается, что каждый ключ на объекте представлен как строковый тип литерал.
В то же время, индексные сигнатуры представляются как общие типы, например `number`.

Это наводит меня на мысль, что мы можем отфильтровать и оставить только тип литералы.
Но, как мы сравним или узнаем, является ли тип литералом или нет?

Воспользуемся тем, как ведут себя множества.
Например, строчный литерал "foo" входит в множество строк, но строки не входят в множество "foo".
Потому что "foo" это множество из одного элемента и никак не покроет все строки.

```typescript
"foo" extends string // true
string extends "foo" // false
```

Давайте это же свойство и применим в нашей проверке на литералы.
Для начала, проверим случай со строками:

```typescript
type TypeLiteralOnly<T> = string extends T ? never : never;
```

В случае, если `T` это `string`, условие выполнится с результатом `true` и мы вернём `never`.
Почему?
Потому что нам не нужны общие типы, нам нужны только литералы.
Следовательно, мы пропускаем `string`.
Такая же логика применима и к другому типу - `number`.

```typescript
type TypeLiteralOnly<T> = string extends T ? never : number extends T ? never : never;
```

Что если `T` и не `string` и не `number`?
Это значит что у нас сейчас тип литерал, который мы можем вернуть обратно как результат.

```typescript
type TypeLiteralOnly<T> = string extends T ? never : number extends T ? never : T;
```

У нас на руках есть обёртка, которая возвращает нам только тип литерал и пропускает общий тип.
Давайте применим это к каждому ключу объекта, используя сопоставляющие типы.
Сделаем копию объекта, с которой будем работать:

```typescript
type RemoveIndexSignature<T> = { [P in keyof T]: T[P] }
```

Во время итерации на ключах, мы можем поменять его тип, используя оператор `as`.
Воспользуемся этим и добавим нашу обёртку:

```typescript
type RemoveIndexSignature<T> = { [P in keyof T as TypeLiteralOnly<P>]: T[P] }
```

Таким образом, на каждой итерации, мы вызываем вспомогательный тип `TypeLiteralOnly`.
Который, в свою очередь, возвращает переданный тип, если это литерал, и `never`, если индексная сигнатура.

```typescript
type TypeLiteralOnly<T> = string extends T ? never : number extends T ? never : T;
type RemoveIndexSignature<T> = { [P in keyof T as TypeLiteralOnly<P>]: T[P] }
```

## Что почитать

- [Условные типы](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Сопоставляющие типы](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
- [Подмена типа в сопоставляющих типах](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html#key-remapping-via-as)
