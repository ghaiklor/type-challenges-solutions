---
id: 3
title: Omit
lang: uk
level: medium
tags: union built-in
---

## Завдання

Реалізуйте вбудований тип `Omit<T, K>`, який прийматиме об'єкт `T` та видалить з нього список ключів `K`.
Наприклад:

```typescript
interface Todo {
  title: string
  description: string
  completed: boolean
}

type TodoPreview = MyOmit<Todo, 'description' | 'title'>

const todo: TodoPreview = {
  completed: false,
}
```

## Розв'язок

`Omit<T, K>` приймає об'єкт `T` і список ключів в `K`, які треба виключити з об'єкта.
Очевидно, що для вирішення цього завдання ми використаємо [типи співставлення (mapped types)](https://www.typescriptlang.org/docs/handbook/advanced-types.html#mapped-types).

```typescript
type MyOmit<T, K> = { [P in keyof T]: T[P] }
```

Залишається відфільтрувати властивості, які необхідно залишити в об'єкті.
Для цього використаємо [перепризначення ключів в типах співставлення (mapped types)](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#key-remapping-in-mapped-types):

```typescript
type MyOmit<T, K> = { [P in keyof T as P extends K ? never : P]: T[P] }
```

В результаті ми отримаємо тип, який перебирає властивості з `T` та перевизначає ті, що не входять в `K`, на `never`.
Таким чином, відфільтрувавши властивості вхідного об'єкта, ми отримаємо необхідний нам тип.

## Посилання

- [Типи співставлення (mapped types)](https://www.typescriptlang.org/docs/handbook/advanced-types.html#mapped-types)
- [Типи пошуку/індексні типи](https://www.typescriptlang.org/docs/handbook/advanced-types.html#index-types)
- [Умовні типи](https://www.typescriptlang.org/docs/handbook/advanced-types.html#conditional-types)
- [Перепризначення ключів в типах співставлення (mapped types)](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#key-remapping-in-mapped-types)
