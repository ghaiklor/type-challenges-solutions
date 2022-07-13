---
id: 191
title: Append Argument
lang: uk
level: medium
tags: arguments
---

## Завдання

Для даної функції `Fn` та будь-якого типу `A` створіть тип, що прийме `Fn`
першим аргументом, `A` - другим, та поверне функцію типу `G`, котра буде того ж
типу, що і `Fn`, але з `A` доданим останнім аргументом.

Наприклад:

```ts
type Fn = (a: number, b: string) => number;

// expected be (a: number, b: string, x: boolean) => number
type Result = AppendArgument<Fn, boolean>;
```

## Розв'язок

Цікава задача! Тут нам знадобляться виведення типів, варіативні кортежі
(variadic tuple types), умовні типи - багато цікавих речей.

Почнемо з виведення аргументів функції та типу, що вона повертає. Умовні типи
допоможуть нам з цим. Коли типи виведені ми можемо повернути власну сигнатуру
функції, що копіює вхідну:

```ts
type AppendArgument<Fn, A> = Fn extends (args: infer P) => infer R
  ? (args: P) => R
  : never;
```

Очевидно, що це рішення ще не готове. Чому? Тому що ми перевіряємо чи `Fn` може
бути присвоєний до функції з одним параметром `args`. Це не так: ми можемо мати
більше одного чи жодного параметра.

Щоб це виправити використаємо оператор `...`:

```ts
type AppendArgument<Fn, A> = Fn extends (...args: infer P) => infer R
  ? (args: P) => R
  : never;
```

Тепер умова в умовному типі буде істинна, отже буде використана гілка “true” з
аргументами функції `P` та поверне тип `R`. Хоча все ще є проблема. `P` містить
кортеж з аргументами функції, але нам потрібно розкласти його на окремі
елементи.

Ми це можемо зробити застосувавши варіативні кортежі:

```ts
type AppendArgument<Fn, A> = Fn extends (...args: [...infer P]) => infer R
  ? (args: P) => R
  : never;
```

Параметр `P` містить те, що нам потрібно. Залишилось лише сконструювати нашу
нову функцію з виведених типів.

```ts
type AppendArgument<Fn, A> = Fn extends (...args: [...infer P]) => infer R
  ? (...args: [...P]) => R
  : never;
```

Маємо тип, що приймає функцію та повертає нову з виведеними типами. Додамо
аргумент `A` до списку параметрів:

```ts
type AppendArgument<Fn, A> = Fn extends (...args: [...infer P]) => infer R
  ? (...args: [...P, A]) => R
  : never;
```

## Посилання

- [Умовні типи](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Вивід типів в умовних типах](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Варіативні кортежі](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
- [Залишкові параметри в функціональних типах](https://www.typescriptlang.org/docs/handbook/2/functions.html#rest-parameters-and-arguments)
