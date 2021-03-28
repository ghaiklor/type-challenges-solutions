---
id: 529
title: Absolute
lang: uk
level: medium
tags: math template-literal
---

## Завдання

Реалізувати тип `Absolute`. Тип приймає рядок, число чи bigint. Повертає рядок з додатнім числом.

Наприклад:

```typescript
type Test = -100;
type Result = Absolute<Test>; // expected to be "100"
```

## Розв'язок

Найлегший спосіб отримати абсолютне значення - привести число до рядка та видалити знак "-".
Я не жартую, забери знак "-".

Ми можемо почати з перевірки чи тип має знак "-" в своєму типі шаблонного літералу, якщо так - виводимо (infer) частину без мінуса, в іншому випадку - повертаємо сам тип:

```typescript
type Absolute<T extends number | string | bigint> = T extends `-${infer N}` ? N : T;
```

Отже, якщо ми візьмемо тип `T = “-50”` він співпаде з `“-<N>”`, де `N` стане просто "50".
Ось так це працює.

Тепер ми бачимо, що деякі тести все ще падають. Це відбувається тому що ми не завжди повертаємо рядки.
У випадку з додатнім чистлом - воно не співпаде з типом шаблонного літералу та дженерик поверне число, хоча нам потрібен рядок.

Давайте виправимо це обгорнувши наш `T` в тип шаблонного літералу:

```typescript
type Absolute<T extends number | string | bigint> = T extends `-${infer N}` ? N : `${T}`;
```

Деякі тести все ще не проходять.
Ми не обробляємо випадок, коли `T` - від'ємне число.
Число не задовільнить умову для типу шаблонного літералу, тому повернеться від'ємне число як рядок.
Щоб обійти це, ми перетворимо число в рядок:

```typescript
type Absolute<T extends number | string | bigint> = `${T}` extends `-${infer N}` ? N : `${T}`;
```

В результаті ми маємо тип, що приймає будь-які `number`, `string`, `bigint` та перетворює їх в рядок.
Потім, вивродить число без знаку мінус "-" та повертає його або просто повертає рядок без змін.

## Посилання

- [Типи шаблонних літералів](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types)
- [Умовні типи](https://www.typescriptlang.org/docs/handbook/advanced-types.html#conditional-types)
- [Виведення в умовних типах](https://www.typescriptlang.org/docs/handbook/advanced-types.html#type-inference-in-conditional-types)
