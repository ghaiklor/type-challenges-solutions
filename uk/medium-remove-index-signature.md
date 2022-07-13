---
id: 1367
title: Remove Index Signature
lang: uk
level: medium
tags: object-keys
---

## Завдання

Реалізувати `RemoveIndexSignature<T>`, який виключає індексну сигнатуру з
об'єктів. Наприклад:

```typescript
type Foo = {
  [key: string]: any;
  foo(): void;
};

type A = RemoveIndexSignature<Foo>; // expected { foo(): void }
```

## Розв'язок

Ми маємо справу з об'єктами в такому випадку. Впевнений, нам знадобляться типи
зіставлення. Але, поки що, давайте зрозуміємо завдання й що нам потрібно
зробити.

Нас попросили виключити індексні сигнатури із об'єктних типів. Як ці сигнатури
виглядають? Використовуючи оператор `keyof`, подивимося, як TypeScript бачить
такі сигнатури з точки зору ключів об'єкта.

Наприклад, маючи тип "Bar", на якому викличемо `keyof`, ми побачимо наступну
картину:

```typescript
type Bar = { [key: number]: any; bar(): void }; // number | “bar”
```

Виходить, що кожен ключ на об'єкті представлений як рядковий тип літерал. В той
же час, індексні сигнатури представлені як загальні типи, наприклад `number`.

Це наводить мене на думку, що ми можемо відфільтрувати й залишити тільки тип
літерали. Але, як ми дізнаємося, чи є тип літералом?

Скористаємося тим, як ведуть себе множини. Наприклад, рядковий літерал "foo"
входить в множину рядків, але рядки не входять в множину "foo". Тому що "foo" це
множина із одного елементу й ніяк не покриє всі рядки.

```typescript
"foo" extends string // true
string extends "foo" // false
```

Давайте застосуємо цю властивість в нашій перевірці на літерали. Для початку,
перевіримо випадок з рядками:

```typescript
type TypeLiteralOnly<T> = string extends T ? never : never;
```

У випадку, якщо `T` це `string`, умова виконається з результатом `true` й ми
повернемо `never`. Чому? Тому що нам не потрібні загальні типи, нам потрібні
тільки літерали. Відповідно, ми відфільтровуємо `string`. Застосуємо цю ж логіку
й до другого типу - `number`.

```typescript
type TypeLiteralOnly<T> = string extends T
  ? never
  : number extends T
  ? never
  : never;
```

Що якщо `T` не `string` і не `number`? Це означає що у нас зараз тип літерал,
який ми можемо повернути як результат.

```typescript
type TypeLiteralOnly<T> = string extends T
  ? never
  : number extends T
  ? never
  : T;
```

В нас на руках є обгортка, як повертає нам тільки тип літерал й пропускає
загальний тип. Давайте застосуємо це до кожного ключа об'єкта, використовуючи
типи зіставлення. Зробимо копію об'єкта, з якою будемо працювати:

```typescript
type RemoveIndexSignature<T> = { [P in keyof T]: T[P] };
```

Під час ітерації по ключах, ми можемо змінити його тип, використовуючи оператор
`as`. Скористаємося цим й додамо нашу обгортку:

```typescript
type RemoveIndexSignature<T> = { [P in keyof T as TypeLiteralOnly<P>]: T[P] };
```

Таким чином, на кожній ітерації, ми викликаємо допоміжний тип `TypeLiteralOnly`.
Який, в свою чергу, повертає переданий тип, якщо це літерал, і `never`, якщо це
індексна сигнатура.

```typescript
type TypeLiteralOnly<T> = string extends T
  ? never
  : number extends T
  ? never
  : T;
type RemoveIndexSignature<T> = { [P in keyof T as TypeLiteralOnly<P>]: T[P] };
```

## Посилання

- [Умовні типи](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Типи зіставлення](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
- [Підміна типу в типах зіставлення](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html#key-remapping-via-as)
