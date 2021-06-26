---
id: 110
title: Capitalize
lang: uk
level: medium
tags: template-literal
---

## Завдання

Реалізувати `Capitalize<T>`, який робить першу літеру рядкового літерала великою.
Наприклад:

```typescript
type capitalized = Capitalize<'hello world'> // expected to be 'Hello world'
```

## Розв'язок

Спочатку, я не зрозумів завдання.
Ми не можемо реалізувати загальний розв'язок для того, щоб зробити літеру великою.
Тому, TypeScript компілятор надає вбудований тип `Capitalize` (вбудований), за допомогою якого ця проблема вирішується досить легко:

```typescript
type MyCapitalize<S extends string> = Capitalize<S>
```

Але я сумніваюся, що намір автора був саме в цьому.
Якщо ми не можемо використовувати вбудований тип `Capitalize`, то ми не можемо реалізувати загалний розв'язок.
А якщо загальний розв'язок реалізувати не виходить, то як ми можемо зробити літери великими?
Звичайно ж, за допомогою словників!

Щоб розв'язок був компактним, зробимо словник тільки для тих літер, які потрібні для того, щоб пройти тести.

```typescript
interface CapitalizedChars { 'f': 'F' };
```

Є словник з великими літерами.
Давайте тепер виведемо першу літеру із рядкового літерала.
Для цього, скористаємося класичною інструкцією з умовним типом.

```typescript
type Capitalize<S> = S extends `${infer C}${infer T}` ? C : S;
```

В тип параметрі `C` отримуємо першу літеру, а в `T` - решту рядка.
Перевіримо чи існує перша літера в нашому словнику.
Якщо так, то повертаємо велику літеру зі словника, в іншому випадку — першу літеру без змін.

```typescript
interface CapitalizedChars { 'f': 'F' };
type Capitalize<S> = S extends `${infer C}${infer T}` ? `${C extends keyof CapitalizedChars ? CapitalizedChars[C] : C}${T}` : S;
```

## Посилання

- [Умовні типи](https://www.typescriptlang.org/docs/handbook/advanced-types.html#conditional-types)
- [Виведення типів в умовних типах](https://www.typescriptlang.org/docs/handbook/advanced-types.html#type-inference-in-conditional-types)
- [Рядкові тип-літерали](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types)
- [keyof й типи пошуку](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-1.html#keyof-and-lookup-types)
