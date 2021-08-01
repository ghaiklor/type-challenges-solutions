---
id: 62
title: Type Lookup
lang: uk
level: medium
tags: union map
---

## Завдання

Бувають ситуації, коли потрібно знайти тип в об'єднанні типів за його атрибутами.
В цьому завданні, реалізуйте тип `LookUp<U, T>`, який шукає в `U` тип, поле `type` якого є `T`.
Наприклад:

```typescript
interface Cat {
  type: 'cat'
  breeds: 'Abyssinian' | 'Shorthair' | 'Curl' | 'Bengal'
}

interface Dog {
  type: 'dog'
  breeds: 'Hound' | 'Brittany' | 'Bulldog' | 'Boxer'
  color: 'brown' | 'white' | 'black'
}

type MyDogType = LookUp<Cat | Dog, 'dog'> // expected to be `Dog`
```

## Розв'язок

Перевіримо, що тип привласнюється іншому типові з атрибутами `{ type: T }` за допомогою умовних типів.
А оскільки умовні типи — дистрибутивні на об'єднаннях, то ця перевірка буде виконуватися для кожного елементу з об'єднання.
Отже, ми переберемо всі елементи, поки не знайдемо потрібний.

```typescript
type LookUp<U, T> = U extends { type: T } ? U : never;
```

## Посилання

- [Умовні типи](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Дистрибутивні умовні типи](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#distributive-conditional-types)
