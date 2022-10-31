---
id: 5310
title: Join
lang: uk
level: medium
tags: array
---

## Завдання

Реалізуйте типізовану версію `Array.join`. `Join<T, U>` приймає масив `T`, роздільник
`U` і повертає масив `T` об'єднаний через `U`.

```typescript
type Res = Join<["a", "p", "p", "l", "e"], "-">; // expected to be 'a-p-p-l-e'
type Res1 = Join<["Hello", "World"], " ">; // expected to be 'Hello World'
type Res2 = Join<["2", "2", "2"], 1>; // expected to be '21212'
type Res3 = Join<["o"], "u">; // expected to be 'o'
```

## Розв'язок

На перший погляд, найпростіше рішення - перерахувати елементи у кортежі та повернути
рядковий тип-літерал з його вмістом і роздільником.

Почнемо з порожнього типу, який нам потрібно реалізувати:

```typescript
type Join<T, U> = any;
```

Класичний трюк для перерахування кортежу полягає в тому, щоб вивести його перший
елемент і залишок, й потім застосувати рекурсію. Спершу додамо виведення:

```typescript
type Join<T, U> = T extends [infer S, ...infer R] ? never : never;
```

Тут ми виводимо рядок (`S`) і залишок (`R`) кортежу. Що нам робити з виведеним рядком?
Нам потрібно додати після нього роздільник з тип-параметра `U`:

```typescript
type Join<T, U> = T extends [infer S, ...infer R] ? `${S}${U}` : never;
```

Маючи цей тип, ми можемо додати роздільник до першого елемента кортежу.
Але нам потрібно зробити це для решти кортежу, тож ми продовжуємо об'єднувати залишок:

```typescript
type Join<T, U> = T extends [infer S, ...infer R]
  ? `${S}${U}${Join<R, U>}`
  : never;
```

Однак є відсутній випадок, коли елементів більше немає. У такому випадку ми
повертаємо порожній рядок, щоб він не переплутав щось у результаті:

```typescript
type Join<T, U> = T extends [infer S, ...infer R]
  ? `${S}${U}${Join<R, U>}`
  : "";
```

Здається, це робоче рішення, але ми отримали деякі помилки компілятора.
Тож давайте виправимо їх насамперед. Перша помилка компілятора: “Type 'S' is not assignable to type
'string | number | bigint | boolean | null | undefined'”. Така ж помилка стосується параметра типу `U`.
Ми можемо це виправити, ввівши обмеження над дженериками:

```typescript
type Join<T extends string[], U extends string | number> = T extends [
  infer S,
  ...infer R
]
  ? `${S}${U}${Join<R, U>}`
  : "";
```

Ці обмеження перевіряють, чи параметри вхідного типу відповідають нашим очікуванням.
Тепер нам потрібно повідомити компілятору, що ці типи, які ми виводимо, також є рядками.
Таким чином, ми додаємо ту саму конструкцію в блок з виведенням:

```typescript
type Join<T extends string[], U extends string | number> = T extends [
  infer S extends string,
  ...infer R extends string[]
]
  ? `${S}${U}${Join<R, U>}`
  : "";
```

Досить близько, але все одно ні... Ми отримали рішення, яке додає тире в кінці,
яке нам тут не потрібно. Наприклад, передавши `apple` ми отримаємо:

```typescript
type R0 = Join<["a", "p", "p", "l", "e"], "-">;
// type R0 = "a-p-p-l-e-"
```

Як його звідти прибрати? Давайте спробуємо перевірити, чи залишилися рядки чи ні, замість того щоб
просто додавати роздільник:

```typescript
type Join<T extends string[], U extends string | number> = T extends [
  infer S extends string,
  ...infer R extends string[]
]
  ? `${S}${R["length"] extends 0 ? never : never}${Join<R, U>}`
  : "";
```

Ми робимо це, дивлячись на `length` кортежу `R`, того самого кортежу, де зберігається залишок.
Якщо залишок порожній, це означає, що нічого не залишилося для обробки, тому тут нам роздільник не потрібен:

```typescript
type Join<T extends string[], U extends string | number> = T extends [
  infer S extends string,
  ...infer R extends string[]
]
  ? `${S}${R["length"] extends 0 ? "" : never}${Join<R, U>}`
  : "";
```

У всіх інших випадках ставимо роздільник:

```typescript
type Join<T extends string[], U extends string | number> = T extends [
  infer S extends string,
  ...infer R extends string[]
]
  ? `${S}${R["length"] extends 0 ? "" : U}${Join<R, U>}`
  : "";
```

## Посилання

- [Дженерики](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Обмеження дженериків](https://www.typescriptlang.org/docs/handbook/2/generics.html#generic-constraints)
- [Умовні типи](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Виведення типів в умовних типах](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Варіативні типи](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
- [Рядкові тип-літерали](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types)
- [Індексні типи](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)
- [Рекурсивні умовні типи](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
