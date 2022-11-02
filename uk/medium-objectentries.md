---
id: 2946
title: ObjectEntries
lang: uk
level: medium
tags: object-keys
---

## Завдання

Реалізуйте типізовану версію `Object.entries`. Наприклад:

```ts
interface Model {
  name: string;
  age: number;
  locations: string[] | null;
}

type modelEntries = ObjectEntries<Model>;
// ['name', string] | ['age', number] | ['locations', string[] | null];
```

## Розв'язок

Дивлячись на проблему, ідея полягає в тому, щоб використати
[Типи зіставлення](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
аби перебрати кожен ключ в об'єкті та згенерувати для них `[key, typeof key]`.

```ts
type ObjectEntries<T> = { [P in keyof T]: [P, T[P]] };
// { key: [key, typeof key], ... }
```

А щоб перетворити згенерований тип в об'єднання, ми просто додамо `keyof T` у кінці.

```ts
type ObjectEntries<T> = { [P in keyof T]: [P, T[P]] }[keyof T];
// [key, typeof key] | ...
```

Отже, як додавання `keyof T` генерує об'єднання? Ну, скажімо, у вас є об'єкт:

```ts
const obj = {
  foo: "bar",
};
```

Щоб отримати доступ до властивості `foo`, ми можемо використовувати оператор `.` (`obj.foo`)
або квадратні дужки (`obj["foo"]`).

У нашому рішенні вище ми використовуємо той самий трюк. Оскільки `keyof T` може бути
будь-яким із ключів, присутніх у `T`, TypeScript генерує всі можливі результати
та перетворює їх на об'єднання.

Повертаючись до нашої проблеми, зауважте, як пройшли деякі тести.
Уважніше розглянувши тести, які не прийшли, ми зрозуміємо, що:

- Усі необов'язкові ключі потрібно перетворити на обов'язкові. Ми можемо зробити це
  за допомогою модифікатора.
- Оскільки тип `Partial` додає undefined до типу, ми повинні опрацювати це.

```ts
type HandleUndefined<F, S extends keyof F> = F[S] extends infer R | undefined
  ? R
  : F[S];
type ObjectEntries<T> = {
  [P in keyof T]-?: [P, HandleUndefined<T, P>];
}[keyof T];
```

## Посилання

- [Умовні типи](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Типи зіставлення](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
- [Модифікатори на типах зіставлення](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html#mapping-modifiers)
