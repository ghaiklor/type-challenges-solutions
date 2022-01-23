---
id: 3
title: Omit
lang: ru
level: medium
tags: union built-in
---

## Проблема

Реализовать встроенный `Omit<T, K>`.

```typescript
interface Todo {
  title: string;
  description: string;
  completed: boolean;
}

type TodoPreview = MyOmit<Todo, "description" | "title">;

const todo: TodoPreview = {
  completed: false,
};
```

## Решение

`Omit<T, K>` принимает объект `T` и список ключей в `K`, которые нужно исключить из результирующего объекта.
Так как мы работаем с объектами, вероятнее всего пригодятся сопоставляющие типы.

Начнём с того, что с помощью сопоставляющих типов вернём такой же объект как и входной.
Переберём его свойства и вернём новый с такими же свойствами.

```typescript
type MyOmit<T, K> = { [P in keyof T]: T[P] };
```

Остается отфильтровать те свойства, которые необходимо оставить при переборе.
Для этого воспользуемся переназначением в сопоставляющих типах.
В результате, получим тип, который перебирает свойства из `T` и переназначает те, что находятся в `K` на `never`.

```typescript
type MyOmit<T, K> = { [P in keyof T as P extends K ? never : P]: T[P] };
```

## Что почитать

- [Сопоставляющие типы](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
- [Индексные типы](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)
- [Условные типы](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Переназначение в сопоставляющих типах](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#key-remapping-in-mapped-types)
