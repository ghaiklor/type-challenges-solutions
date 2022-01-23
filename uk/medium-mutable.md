---
id: 2793
title: Mutable
lang: uk
level: medium
tags: readonly object-keys
---

## Завдання

Реалізувати загальний тип `Mutable<T>`, який зробить всі властивості об'єкта змінюваними.
Наприклад:

```typescript
interface Todo {
  readonly title: string;
  readonly description: string;
  readonly completed: boolean;
}

// { title: string; description: string; completed: boolean; }
type MutableTodo = Mutable<T>;
```

## Розв'язок

Й знову, завдання, яке складно назвати завдання з середнім рівнем складності.
Я її вирішив без довгих роздумів й з першого разу.
Але, як би там не було, ми все одно вирішуємо їх всі, тому навіщо думати про це.

Ми знаємо, що у нас на вході тип з властивостями, до якого застосовується модифікатор `readonly`.
Це ті ж самі модифікатори, які ми використовували для розв'язку інших задач, наприклад [Readonly](./easy-readonly.md).
Але, в цьому випадку, нас попросили прибрати цей модифікатор з вхідного типу.

Давайте почнемо з найпростішого.
Скопіюємо вхідний тип без яких-небудь змін:

```typescript
type Mutable<T> = { [P in keyof T]: T[P] };
```

Тепер у нас є копія `T` з модифікаторами `readonly`.
Як же нам від них позбутися?
Пам'ятаєте, що ми використовували ключове слово `readonly`, щоб додати їх до властивостей?

```typescript
type Mutable<T> = { readonly [P in keyof T]: T[P] };
```

Неявно, TypeScript додає до цих ключових слів `+`.
Тобто, застосовує модифікатор `readonly` на властивості.
Але, в нашому випадку, мы хочемо його відмінити, тому використовуємо `-`:

```typescript
type Mutable<T> = { -readonly [P in keyof T]: T[P] };
```

Таким чином, ми реалізували тип, який відміняє модифікатор `readonly` на вхідному типі.

## Посилання

- [Типи зіставлення](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
- [Модифікатори на типах зіставлення](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html#mapping-modifiers)
