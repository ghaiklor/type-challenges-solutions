---
id: 531
title: String to Union
lang: uk
level: medium
tags: union string
---

## Завдання

Реалізувати `StringToUnion<T>`, який приймає рядковий тип-літерал й повертає об'єднання з його символів.
Наприклад:

```typescript
type Test = '123';
type Result = StringToUnion<Test>; // expected to be "1" | "2" | "3"
```

## Розв'язок

В цьому завданні потрібно перебрати всі символи із рядкового тип-літералу й додати їх в об'єднання.
Почнемо з першого — перебору.
Використаємо умовні типи з рядковими тип-літералами й виведемо першу літеру й решту.

```typescript
type StringToUnion<T extends string> = T extends `${infer C}${infer T}` ? never : never
```

В тип-параметрах `C` и `T` отримуємо першу літеру рядка і її хвіст.
Щоб продовжити перебір, викличемо `StringToUnion` ще раз з параметром `T`.
У такий спосіб буде відбуватися рекурсивний перебір.

```typescript
type StringToUnion<T extends string> = T extends `${infer C}${infer T}` ? StringToUnion<T> : never
```

Єдине, що залишилося — об'єднання.
На кожній ітерації перебору, додамо тип-параметр `C` до результату від `StringToUnion<T>`.
Оскільки базовий випадок `StringToUnion<T>` - `never`, отримаємо `C1 | C2 | CN | never`.

```typescript
type StringToUnion<T extends string> = T extends `${infer C}${infer T}` ? C | StringToUnion<T> : never
```

## Посилання

- [Умовні типи](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Виведення типів в умовних типах](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Рекурсивні умовні типи](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
- [Рядкові тип-літерали](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types)
- [Об'єднання типів](https://www.typescriptlang.org/docs/handbook/2/everyday-types.html#union-types)
