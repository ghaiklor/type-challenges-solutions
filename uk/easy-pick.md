---
id: 4
title: Pick
lang: uk
level: easy
tags: union built-in
---

## Завдання

Реалізуйте вбудований тип `Pick<T, K>` не використовуючи його.

Він має створювати тип в котрому перераховані лише ті властивості `T`, які вказані в `K`.

Наприклад:

```ts
interface Todo {
  title: string
  description: string
  completed: boolean
}

type TodoPreview = MyPick<Todo, 'title' | 'completed'>

const todo: TodoPreview = {
  title: 'Clean room',
  completed: false,
}
```

## Розв'язок

Для цієї задачі нам потрібні типи пошуку (Lookup Types) та порівняльні типи (Mapped Types).

Типи пошуку дозволяють нам отримати тип з іншого типу за іменем.
Схоже на отримання значення з об'єкта за ключем.

Порівняльні типи дозволяють перетворити властивості типу в новий тип.

Ви можете прочитати більше про них і зрозуміти як вони працюють на сайті TypeScript: [типи пошуку (lookup types)](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-1.html#keyof-and-lookup-types) і [порівняльні типи (mapped types)](https://www.typescriptlang.org/docs/handbook/advanced-types.html#mapped-types).

Тепер, знаючи про типи пошуку та порівняльні типи, як реалізувати необхідний тип?

Потрібно взяти всі елементи з об'єднання `K` та проітерувавши над `T` повернути новий тип який буде складатись лише з їх ключів, що вказані в `K`.

Типи значень цих ключів не зміняться.
Хоча, нам доведеться взяти їх з початкового `T` і для цього будуть корисні типи пошуку:

```ts
type MyPick<T, K extends keyof T> = { [P in K]: T[P] }
```

Ми кажемо: "Візьми всі елементи з `К`, назви `Р` і зроби це ключем в новому об'єкті зі значенням з початкового типу".
Це складно зрозуміти одразу, тому, якщо щось не зрозуміло, спробуйте перечитати ще раз і розібрати рішення крок за кроком.

## Посилання

- [Типи пошуку](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-1.html#keyof-and-lookup-types)
- [Порівняльні типи](https://www.typescriptlang.org/docs/handbook/advanced-types.html#mapped-types)
- [Індексні типи](https://www.typescriptlang.org/docs/handbook/advanced-types.html#index-types)
