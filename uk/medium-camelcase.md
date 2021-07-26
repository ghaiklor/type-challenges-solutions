---
id: 610
title: CamelCase
lang: uk
level: medium
tags: template-literal
---

## Завдання

Перевести рядок до CamelCase.
Наприклад:

```typescript
type camelCased = CamelCase<'foo-bar-baz'> // expected "fooBarBaz"
```

## Розв'язок

Спільною частиною, яку ми можемо використати для виведення рядка є дефіс.
Давайте виведемо частини до та після дефісу.

```typescript
type CamelCase<S> = S extends `${infer H}-${infer T}`
  ? never
  : never;
```

Якщо такого шаблону немає - повертаємо рядок без змін.

```typescript
type CamelCase<S> = S extends `${infer H}-${infer T}`
  ? never
  : S;
```

Але коли такий шаблон знайдений нам потрібно видалити дефіс та зробити першу букву великою.
Крім цього не забуваємо, що можуть бути інші під-рядки, які також потрібно обробити.
Зробимо це рекурсивно.

```typescript
type CamelCase<S> = S extends `${infer H}-${infer T}`
  ? `${H}${CamelCase<Capitalize<T>>}`
  : S;
```

Тепер проблема в тому, що ми не враховуємо випадок, коли друга частина рядка уже починається з великої літери.
Виправимо це перевіркою чи можемо ми присвоїти цю частину до неї ж, але капіталізованої.

```typescript
type CamelCase<S> = S extends `${infer H}-${infer T}`
  ? T extends Capitalize<T> ? never : `${H}${CamelCase<Capitalize<T>>}`
  : S;
```

Що робити, якщо друга частина рядка уже починається з великої літери?
Збережемо дефіс та пропустимо цю частину.
Звісно, також рекурсивно.

```typescript
type CamelCase<S> = S extends `${infer H}-${infer T}`
  ? T extends Capitalize<T> ? `${H}-${CamelCase<T>}` : `${H}${CamelCase<Capitalize<T>>}`
  : S;
```

Чудово, ми отримали тип, що приводить шаблонні літерали до "camelCase"!

## Посилання

- [Умовні типи](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Виведення типів в умовних типах](https://www.typescriptlang.org/docs/handbook/advanced-types.html#type-inference-in-conditional-types)
- [Рекурсивні умовні типи](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
- [Типи шаблонних літералів](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types)
