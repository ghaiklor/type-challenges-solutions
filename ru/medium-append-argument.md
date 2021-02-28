---
id: 191
title: Append Argument
lang: ru
level: medium
tags: arguments
---

## Проблема

Для заданной функции `Fn` и типа `A`, реализуйте тип, который принимает `Fn` первым параметром, `A` вторым параметром и создает новый тип `G`, который вернёт функцию `Fn`, но с добавлением нового параметра типа `A` в конец параметров.
Например:

```typescript
type Fn = (a: number, b: string) => number

// expected be (a: number, b: string, x: boolean) => number
type Result = AppendArgument<Fn, boolean>
```

## Решение

Интересная проблема, для решения которой нужно проявить немного креатива.

Мы начнём с выведения типов параметров входной функции и типа возврата.
Условные типы помогут в этом.
Как только мы выведем типы, вернём новую сигнатуру функции, которая копирует входную, но с использованием наших выведенных типов.

```typescript
type AppendArgument<Fn, A> = Fn extends (args: infer P) => infer R ? (args: P) => R : never;
```

Очевидно, это решение ещё не готовое.
Почему?
Потому что, мы проверяем что тип `Fn` присваиваемый к типу функции с единственным параметром `args`.
Это неправда, у нас может быть больше одного параметра или не быть вовсе.

Чтобы починить эту проблему, воспользуемся `...` оператором:

```typescript
type AppendArgument<Fn, A> = Fn extends (...args: infer P) => infer R ? (args: P) => R : never;
```

Теперь, наше условие в условном типе срабатывает и мы попадаем в ветку, где у нас есть `P` (типы параметров функции) и `R` (тип возврата функции).

Но, у нас всё ещё проблема.
Тип параметр `P` это кортеж с параметрами внутри.
Нам же нужно интерпретировать этот кортеж как отдельные параметры, а не как один.

Применяя вариативные типы к этому кортежу, мы можем разложить его на отдельные параметры:

```typescript
type AppendArgument<Fn, A> = Fn extends (...args: [...infer P]) => infer R ? (args: P) => R : never;
```

Имея нужные нам данные, давайте доработаем новую сигнатуру функции, которую мы возвращаем.
Используем те же вариативные типы и `...` оператор.

```typescript
type AppendArgument<Fn, A> = Fn extends (...args: [...infer P]) => infer R ? (...args: [...P]) => R : never;
```

На этом этапе, тип принимает входную функцию и возвращает такую же функцию, используя выведенные типы.
Всё, что нам остается сделать, это добавить к кортежу с параметрами новый параметр `A`.

```typescript
type AppendArgument<Fn, A> = Fn extends (...args: [...infer P]) => infer R ? (...args: [...P, A]) => R : never;
```

## Что почитать

- [Условные типы](https://www.typescriptlang.org/docs/handbook/advanced-types.html#conditional-types)
- [Выведение типов в условных типах](https://www.typescriptlang.org/docs/handbook/advanced-types.html#type-inference-in-conditional-types)
- [Вариативные типы](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
- [Разложение параметров в функциях](https://www.typescriptlang.org/docs/handbook/functions.html#rest-parameters)
