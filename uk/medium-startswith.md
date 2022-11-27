---
id: 2688
title: StartsWith
lang: uk
level: medium
tags: template-literal
---

## Завдання

Реалізуйте `StartsWith<T, U>`, який приймає два рядкові типи і повертає - чи
починається `T` з `U`. Наприклад:

```typescript
type a = StartsWith<"abc", "ac">; // expected to be false
type b = StartsWith<"abc", "ab">; // expected to be true
type c = StartsWith<"abc", "abcd">; // expected to be false
```

## Розв'язок

Знаючи про рядкові тип-літерали у TypeScript, рішення стає досить очевидним.
Почнемо з порожнього типу:

```typescript
type StartsWith<T, U> = any;
```

Нам потрібно перевірити, чи вхідний тип-параметр `T` починається з рядкового
літералу `U`. Я зроблю простіше і просто перевірю, чи `T` є `U`, використовуючи
умовні типи:

```typescript
type StartsWith<T, U> = T extends `${U}` ? never : never;
```

Якщо вхідний тип-параметр `T` такий самий, як тип-параметр `U`, ми потрапимо до
правдивої гілки умовного типу. Але нам не потрібно, щоб вони були рівними. Нам
потрібно перевірити, чи він починається з `U`. Іншими словами; нам байдуже, чи
буде щось після `U`. Тому використовуємо там тип `any`:

```typescript
type StartsWith<T, U> = T extends `${U}${any}` ? never : never;
```

Якщо тип `T` відповідає шаблону, який починається з `U`, ми повертаємо тип
`true`. В іншому випадку - `false`:

```typescript
type StartsWith<T, U> = T extends `${U}${any}` ? true : false;
```

Ми пройшли всі тести, але отримали помилку компіляції: “Type ‘U’ is not
assignable to type ‘string | number | bigint | boolean | null | undefined’.“. Це
тому, що ми не додали обмеження над тип-параметром, яке вказує, що `U` - рядок.
Давайте додамо:

```typescript
type StartsWith<T, U extends string> = T extends `${U}${any}` ? true : false;
```

## Посилання

- [Дженерики](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Обмеження дженериків](https://www.typescriptlang.org/docs/handbook/2/generics.html#generic-constraints)
- [Умовні типи](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Рядковий тип-літерал](https://www.typescriptlang.org/docs/handbook/2/template-literal-types.html)
