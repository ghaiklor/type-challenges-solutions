---
id: 2070
title: Drop Char
lang: uk
level: medium
tags: template-literal infer
---

## Завдання

Видаліть вказаний символ з рядка. Наприклад:

```typescript
type Butterfly = DropChar<" b u t t e r f l y ! ", " ">; // 'butterfly!'
```

## Розв'язок

Щоб вирішити це завдання, потрібно знати про типи шаблонних літералів в
TypeScript. Більш детально
[можна почитати на сайті](https://www.typescriptlang.org/docs/handbook/2/template-literal-types.html).

Коли ми використовуємо типи шаблонних літералів, ми можемо виводити частини
рядків цього літералу. Скористаємося цим, щоб вивести ліву й праву частину
літералу. А розділювачем буде сам символ, який нам потрібно видалити.

```typescript
type DropChar<S, C> = S extends `${infer L}${C}${infer R}` ? never : never;
```

З таким записом, ми отримаємо помилку компіляції
`Type ‘C’ is not assignable to type ‘string | number | bigint | boolean | null | undefined’.`.
Додамо обмеження на дженериках, щоб запобігти цьому.

```typescript
type DropChar<S, C extends string> = S extends `${infer L}${C}${infer R}`
  ? never
  : never;
```

Тепер, ми бачимо, що у нас є дві частини літералу й окремо розділювач. Оскільки
нам потрібно видалити розділювач, то ми повертаємо тільки ліву й праву частини.

```typescript
type DropChar<S, C extends string> = S extends `${infer L}${C}${infer R}`
  ? `${L}${R}`
  : never;
```

Таким чином, ми видалили один символ з рядка. Щоб продовжити видаляти інші,
викличемо наш тип рекурсивно.

```typescript
type DropChar<S, C extends string> = S extends `${infer L}${C}${infer R}`
  ? DropChar<`${L}${R}`, C>
  : never;
```

Ми покрили всі випадки, крім випадків, коли співпадінь по шаблону немає. Якщо
сталася така ситуація, повернемо вхідний рядок без змін.

```typescript
type DropChar<S, C extends string> = S extends `${infer L}${C}${infer R}`
  ? DropChar<`${L}${R}`, C>
  : S;
```

## Посилання

- [Типи шаблонних літералів](https://www.typescriptlang.org/docs/handbook/2/template-literal-types.html)
- [Умовні типи](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Виведення типів в умовних типах](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
