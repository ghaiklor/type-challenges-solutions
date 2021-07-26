---
id: 612
title: KebabCase
lang: ru
level: medium
tags: template-literal
---

## Проблема

Привести строку к формату `kebab-case`.
Например:

```typescript
type kebabCase = KebabCase<'FooBarBaz'> // expected "foo-bar-baz"
```

## Решение

Эта проблема имеет много общего с проблемой [`CamelCase`](./medium-camelcase.md).
Начнём с вывода типов.
Узнаем первую букву строки и остальную часть (хвост).

```typescript
type KebabCase<S> = S extends `${infer C}${infer T}`
  ? never
  : never;
```

Когда попадаем в ситуацию, где нету шаблона для "первая буква и хвост", это значит что строка закончилась.
Поэтому, возвращаем входной параметр без изменений.

```typescript
type KebabCase<S> = S extends `${infer C}${infer T}`
  ? never
  : S;
```

Но, если шаблон сработал, то здесь два случая.
Первый случай, когда наш хвост не имеет заглавную букву, а второй - когда имеет.
Чтобы это проверить, используем встроенный тип `Uncapitalize`.

```typescript
type KebabCase<S> = S extends `${infer C}${infer T}`
  ? T extends Uncapitalize<T> ? never : never
  : S;
```

Что нужно сделать, если хвост не имеет заглавной буквы?
Это значит, что у нас может быть `Foo` или `foo`.
А значит, делаем первую букву не заглавной, а остальное без изменений.
И не забываем, что применяем этот тип рекурсивно, так как обрабатываем следующие части строки.

```typescript
type KebabCase<S> = S extends `${infer C}${infer T}`
  ? T extends Uncapitalize<T> ? `${Uncapitalize<C>}${KebabCase<T>}` : never
  : S;
```

Второй случай, когда хвост содержит заглавную букву.
Например, `fooBar`.
Всё ещё делаем первую букву не заглавной, но теперь, ещё и добавляем дефис и продолжаем рекурсивно обрабатывать строку.
Нам не нужно применять `Uncapitalize` к хвосту, так как он будет применён на следующих итерациях, когда он станет первой буквой подстроки.

```typescript
type KebabCase<S> = S extends `${infer C}${infer T}`
  ? T extends Uncapitalize<T> ? `${Uncapitalize<C>}${KebabCase<T>}` : `${Uncapitalize<C>}-${KebabCase<T>}`
  : S;
```

## Что почитать

- [Условные типы](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Выведение типов в условных типах](https://www.typescriptlang.org/docs/handbook/advanced-types.html#type-inference-in-conditional-types)
- [Рекурсивные условные типы](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
- [Строчные тип литералы](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types)
