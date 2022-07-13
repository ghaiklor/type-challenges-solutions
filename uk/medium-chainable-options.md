---
id: 12
title: Chainable Options
lang: uk
level: medium
tags: application
---

## Завдання

У світі JavaScript, часто використовується шаблон послідовного виклику функцій.
Але коли мова заходить про TypeScript, чи можемо ми реалізувати тип для цього?

Реалізуйте тип для об'єкта чи класу, неважливо. Цей тип надає два методи
`option(key, value)` і `get()`. Викликаючи метод `option(key, value)` ми
розширяємо поточний тип конфігурації, який отримуємо через виклик метода
`get()`. Наприклад:

```typescript
declare const config: Chainable;

const result = config
  .option("foo", 123)
  .option("name", "type-challenges")
  .option("bar", { value: "Hello World" })
  .get();

// expect the type of result to be:
interface Result {
  foo: number;
  name: string;
  bar: {
    value: string;
  };
}
```

Для розв'язання цієї задачі не потрібно писати ніякої реалізації на JavaScript
чи TypeScript. Рішення повинно бути тільки на рівні типів.

## Розв'язок

Що автор цього завдання просить нас зробити? Реалізувати два методи
`option(key, value)` і `get()`. Кожен наступний виклик `option(key, value)`
акумулює інформацію про типи `key` і `value`. Акумулювання продовжується поки не
буде викликано метод `get()`, який поверне зібрану про типи інформацію як
об'єкт.

Почнемо з інтерфейсу, який нам надає автор завдання:

```typescript
type Chainable = {
  option(key: string, value: any): any;
  get(): any;
};
```

Перш ніж почнемо акумулювати інформацію про типи, було б не погано якось її
отримувати. Тому замінимо `string` в `key` і `any` в `value` на тип-параметри.
Таким чином, TypeScript зможе автоматично вивести типи й присвоїти їх нашим
тип-параметрам:

```typescript
type Chainable = {
  option<K, V>(key: K, value: V): any;
  get(): any;
};
```

У нас є інформація про типи `key` і `value`. TypeScript виведе `key` як рядковий
тип-літерал, а `value` як загальний тип. Наприклад, викликаючи
`option('foo', 123)`, TypeScript присвоїть нашим тип-параметрам `K = 'foo'` і
`V = number`.

Інформація є, але де її зберігати? Повинне бути місце, де ми зберігатимемо стан
між викликами методів. І єдине місце, де можна це зробити — на самому типі
`Chainable`!

Додамо новий тип-параметр `O` до типу `Chainable` і не забудемо, що, за
замовчуванням, цей тип-параметр — порожній об'єкт.

```typescript
type Chainable<O = {}> = {
  option<K, V>(key: K, value: V): any;
  get(): any;
};
```

Потрібно, щоб `option(key, value)` повертав сам тип `Chainable` (ми ж хочемо
мати можливість викликати методи один за одним), але з інформацією про типи
попередніх викликів разом з поточним. Щоб додавати нові типи в акумулятор `O`,
скористаємося типами перетинів.

```typescript
type Chainable<O = {}> = {
  option<K, V>(key: K, value: V): Chainable<O & { [P in K]: V }>;
  get(): any;
};
```

Залишилися дрібниці! Отримуємо помилку компіляції “Type ‘K’ is not assignable to
type ‘string | number | symbol’.“. Це через те, що у нас немає обмеження на
тип-параметр `K`, які б вказували на приналежність до рядка:

```typescript
type Chainable<O = {}> = {
  option<K extends string, V>(key: K, value: V): Chainable<O & { [P in K]: V }>;
  get(): any;
};
```

Все готово до фінального акорду! Коли розробник буде викликати метод `get()`, то
він [метод] повинен повертати `O` з `Chainable`. Той самий `O`, в якому ми
накопичуємо інформацію про типи, при викликах `option(key, value)`,
використовуючи типи перетинів.

```typescript
type Chainable<O = {}> = {
  option<K extends string, V>(key: K, value: V): Chainable<O & { [P in K]: V }>;
  get(): O;
};
```

## Посилання

- [Типи перетинів](https://www.typescriptlang.org/docs/handbook/2/objects.html#intersection-types)
- [Типи зіставлення](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
- [Дженерики](https://www.typescriptlang.org/docs/handbook/2/generics.html)
