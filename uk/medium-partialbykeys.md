---
id: 2757
title: PartialByKeys
lang: uk
level: medium
tags: object-keys union
---

## Завдання

Реалізуйте загальний `PartialByKeys<T, K>`, який приймає два аргументи типу `T` і
`K`.

`K` визначає набір властивостей `T`, які мають бути необов'язковими. Коли
`K` не надається, він має робити всі властивості необов'язковими, як звичайний
`Partial<T>`.

## Розв'язок

Гаразд, давайте розіб'ємо це завдання на три частини.

- Вибрати усі властивості `T`, які присутні в `K`, і зробити їх необов'язковими.
- Вибрати усі властивості `T`, яких немає в `K`, і зберегти їх як є.
- Об'єднати обидва згадані вище типи, щоб отримати рішення.

Тож, як нам створити новий тип, вибравши всі властивості з `T`, крім `K`?

Вірно. Ми можемо використати допоміжний тип `Omit`, наданий TypeScript, або створити власний.

```typescript
type MyOmit<F, S> = { [P in keyof F as P extends S ? never : P]: F[P] };
type EverythingFromTExceptK<T, K> = MyOmit<T, K>;
```

Тепер давайте виберемо всі властивості з `K`, присутні в `T`, і позначимо їх як необов'язкові.
Ми можемо зробити це за допомогою [типів зіставлення](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html).

```typescript
type OptionalProperties<T, K> = {
  [P in keyof T as P extends K ? P : never]?: T[P];
};
```

Дивовижно, правда? Тепер, коли у нас є обидві частини нашого рішення, давайте об'єднаємо їх.

```typescript
type PartialByKeys<T, K = keyof T> = OptionalProperties<T, K> &
  EverythingFromTExceptK<T, K>;
```

Зверніть увагу, що це все ще не вирішує нашу проблему. Придивившись ближче до згенерованого типу,
ми побачимо, що `PartialByKeys` повертає `{...properties} & {...some other properties}`.
Отже, щоб отримати остаточну відповідь, нам потрібно об'єднати ці два типи в один.

```typescript
type MyMerge<T> = { [P in keyof T]: T[P] };
type PartialByKeys<T, K = keyof T> = MyMerge<
  OptionalProperties<T, K> & EverythingFromTExceptK<T, K>
>;
```

## Посилання

- [Типи зіставлення](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
- [Умовні типи](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
