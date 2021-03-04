---
id: 610
title: CamelCase
lang: ru
level: medium
tags: template-literal
---

## Проблема

Конвертировать строчный тип литерал в CamelCase.
Например:

```typescript
type camelCased = CamelCase<'foo-bar-baz'> // expected "fooBarBaz"
```

## Решение

В этой проблеме есть закономерность, которую можно использовать для выведения типов - дефис.
Одна часть строки это то что перед дефисом, а вторая - после него.
Давайте выведем эти части.

```typescript
type CamelCase<S> = S extends `${infer H}-${infer T}`
  ? never
  : never;
```

Что если нету такого шаблона "голова-дефис-хвост"?
Возвращаем исходную строку без изменений.
Дефисов нету, а значит и строку к CamelCase формату приводить не нужно.

```typescript
type CamelCase<S> = S extends `${infer H}-${infer T}`
  ? never
  : S;
```

Но, если такой шаблон в строке присутствует, то выведение сработает и мы получим две части строки без дефиса.
Остается только сделать вторую часть заглавной.
Также, нужно делать это рекурсивно, по той причине, что могут быть ещё другие дефисы.

```typescript
type CamelCase<S> = S extends `${infer H}-${infer T}`
  ? `${H}${CamelCase<Capitalize<T>>}`
  : S;
```

На этом этапе, у нас неполное решение, в котором мы не покрываем некоторых случаев.
Например, случай, когда вторая часть строки (та, что после дефиса) уже заглавная.
Мы можем починить это, проверяя, а заглавная ли у нас вторая часть?

```typescript
type CamelCase<S> = S extends `${infer H}-${infer T}`
  ? T extends Capitalize<T> ? never : `${H}${CamelCase<Capitalize<T>>}`
  : S;
```

И, если, вторая часть нашей строки заглавная, то нужно сохранить дефис и пропустить эту итерацию.
И, да, это тоже делаем рекурсивно, чтобы обрабатывались остальные случаи.

```typescript
type CamelCase<S> = S extends `${infer H}-${infer T}`
  ? T extends Capitalize<T> ? `${H}-${CamelCase<T>}` : `${H}${CamelCase<Capitalize<T>>}`
  : S;
```

В результате, получаем тип, который приводит строчные тип литералы к CamelCase формату!

## Что почитать

- [Условные типы](https://www.typescriptlang.org/docs/handbook/advanced-types.html#conditional-types)
- [Выведение типов в условных типах](https://www.typescriptlang.org/docs/handbook/advanced-types.html#type-inference-in-conditional-types)
- [Рекурсивные условные типы](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
- [Строчные тип литералы](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types)
