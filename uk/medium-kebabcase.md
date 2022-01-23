---
id: 612
title: KebabCase
lang: uk
level: medium
tags: template-literal
---

## Завдання

Привести рядок до формату `kebab-case`.
Наприклад:

```typescript
type kebabCase = KebabCase<"FooBarBaz">; // expected "foo-bar-baz"
```

## Розв'язок

Це завдання дуже схоже з завданням ["CamelCase"](./medium-camelcase.md).
Почнемо з виводу типів.
Нам потрібно дізнатись перший символ рядка та решту (хвіст).

```typescript
type KebabCase<S> = S extends `${infer C}${infer T}` ? never : never;
```

Коли тип не відповідає шаблону "перший символ та решта (хвіст)", це означає кінець рядка.
Тому повертаємо вхідний параметр без змін.

```typescript
type KebabCase<S> = S extends `${infer C}${infer T}` ? never : S;
```

Але, коли наш шаблон спрацював, ми повинні обробити два випадки.
Коли решта рядка не має заголовного символу та навпаки, коли має.
Для перевірки використовуємо вбудований тип `Uncapitalize`.

```typescript
type KebabCase<S> = S extends `${infer C}${infer T}`
  ? T extends Uncapitalize<T>
    ? never
    : never
  : S;
```

Якщо решта рядка не має заголовного символу?
Це означає, що в нас може бути `Foo` або `foo`.
Тож, ми перетворюємо перший символ в нижній регістр, а решту рядка залишаємо без змін.
Не забуваємо застосовувати цей тип рекурсивно, для обробки наступних частин рядка.

```typescript
type KebabCase<S> = S extends `${infer C}${infer T}`
  ? T extends Uncapitalize<T>
    ? `${Uncapitalize<C>}${KebabCase<T>}`
    : never
  : S;
```

Другий випадок, коли решта рядка містить заголовний символ(наприклад, `fooBar`).
Перетворюємо перший символ в нижній регістр, додавши дефіс, та продовжуємо рекурсивно обробляти рядок.
Нам не потрібно застосовувати `Uncapitalize` для решти рядка, бо він буде застосований в `Uncapitalize<C>`.

```typescript
type KebabCase<S> = S extends `${infer C}${infer T}`
  ? T extends Uncapitalize<T>
    ? `${Uncapitalize<C>}${KebabCase<T>}`
    : `${Uncapitalize<C>}-${KebabCase<T>}`
  : S;
```

## Посилання

- [Умовні типи](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Виведення типів в умовних типах](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Рекурсивні умовні типи](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
- [Рядкові тип літерали](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types)
