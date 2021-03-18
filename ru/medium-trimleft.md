---
id: 106
title: Trim Left
lang: ru
level: medium
tags: template-literal
---

## Проблема

Реализовать `TrimLeft<T>` который принимает строчный тип литерал и возвращает новый, в котором убраны пробелы слева.
Например:

```typescript
type trimmed = TrimLeft<'  Hello World  '> // expected to be 'Hello World  '
```

## Решение

Когда нужно работать со строками в TypeScript, скорее всего пригодятся строчные тип литералы в системе типов TypeScript.
Они позволяют моделировать разные поведения связанные со строками.

В этой задаче два случая: строка с пробелом в начале и строка без.
В случае, если строка содержит пробел в начале, выведём остальную часть строки без этого пробела.
Продолжим этот процесс рекурсивно, пока пробел не исчезнет.
Как только это случилось, возвращаем входную строку без изменений.

Воспользуемся условными типами и выведём необходимые части строки, используя строчный тип литерал:

```typescript
type TrimLeft<S> = S extends `${infer T}` ? TrimLeft<T> : S;
```

Видим, что некоторые из тестов не проходят.
Это потому, что мы не обрабатываем ситуацию с переводами строк и табуляцией.

Починим это, заменив пробел на объединение символов "пробел", "перевод строки" и "табуляция":

```typescript
type TrimLeft<S> = S extends `${' ' | '\n' | '\t'}${infer T}` ? TrimLeft<T> : S;
```

## Что почитать

- [Условные типы](https://www.typescriptlang.org/docs/handbook/advanced-types.html#conditional-types)
- [Выведение типов в условных типах](https://www.typescriptlang.org/docs/handbook/advanced-types.html#type-inference-in-conditional-types)
- [Рекурсивные условные типы](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
- [Строчные тип литералы](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types)
