---
id: 108
title: Trim
lang: ru
level: medium
tags: template-literal
---

## Проблема

Реализовать `Trim<T>` который принимает строчный тип литерал и возвращает новый, в котором удалены пробелы с обеих сторон.
Например:

```typescript
type trimmed = Trim<"  Hello World  ">; // expected to be 'Hello World'
```

## Решение

Такая же задача как и в [`TrimLeft<T>`](./medium-trimleft.md).
Отличие только в том, что здесь нужно удалить пробелы с двух сторон, а не с одной.
Воспользуемся теми же строчными тип литералами, чтобы смоделировать нужное поведение.

В отличии от [`TrimLeft<T>`](./medium-trimleft.md), здесь три случая: пробелы с левой стороны, пробелы с правой стороны и строка без пробелов.

Начнём с моделирования ситуации, когда пробелы слева.
Объединяя строчные тип литералы с условными типами, выводим пробел и остальную часть строки.
Продолжая выводить рекурсивно, избавляемся от пробелов слева.

```typescript
type Trim<S> = S extends ` ${infer R}` ? Trim<R> : S;
```

Когда пробелы слева убраны, проверим, есть ли пробелы по правую сторону строки и сделаем то же.

```typescript
type Trim<S> = S extends ` ${infer R}`
  ? Trim<R>
  : S extends `${infer L} `
  ? Trim<L>
  : S;
```

Таким образом, убираем пробелы с левой стороны, после, убираем с правой стороны.
Этот процесс продолжается до тех пор, пока пробелов не останется и мы вернём входную строку без изменений.

Но, получаем ошибку в тестах.
Это из-за того, что мы не обрабатываем случай с переводом строк и табуляцией.

Решим это добавлением их символов в объединение.
Чтобы избежать дублирования, вынесём это в отдельный тип:

```typescript
type Whitespace = " " | "\n" | "\t";
type Trim<S> = S extends `${Whitespace}${infer R}`
  ? Trim<R>
  : S extends `${infer L}${Whitespace}`
  ? Trim<L>
  : S;
```

## Что почитать

- [Типы объединений](https://www.typescriptlang.org/docs/handbook/2/everyday-types.html#union-types)
- [Условные типы](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Выведение типов в условных типах](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Рекурсивные условные типы](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
- [Строчные тип литералы](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types)
