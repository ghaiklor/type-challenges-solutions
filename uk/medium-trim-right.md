---
id: 4803
title: Trim Right
lang: uk
level: medium
tags: template-literal
---

## Завдання

Реалізуйте `TrimRight<T>`, який приймає рядок та повертає новий рядок із видаленими
пробілами в кінці. Наприклад:

```typescript
type Trimmed = TrimRight<"   Hello World    ">; // expected to be '   Hello World'
```

## Розв'язок

Це завдання насправді таке саме, як [Trim](./medium-trim.md) та [Trim Left](./medium-trimleft.md).
Але цього разу нам потрібно видалити пробіли праворуч.

Ми починаємо, як зазвичай, з порожнього типу, який нам потрібно реалізувати:

```typescript
type TrimRight<S extends string> = any;
```

Тепер, як перевірити, чи закінчується рядок пробілом? Для цього ми можемо використати
умовний тип, додавши пробіл до вхідного рядка:

```typescript
type TrimRight<S extends string> = S extends `${infer T} ` ? never : never;
```

Зверніть увагу на частину `infer T`. Якщо рядок справді закінчується пробілом,
нам потрібно взяти його частину без пробілу. Отже, ми виводимо частину рядка
без нього в параметр типу `T`.

Маючи частину рядка без пробілів праворуч, ми можемо повернути її:

```typescript
type TrimRight<S extends string> = S extends `${infer T} ` ? T : never;
```

Однак у такому випадку це вирішить проблему лише для одного пробілу. А як щодо
випадків, коли їх більше? Щоб покрити це, нам потрібно продовжувати їх позбуватися,
доки їх не залишиться. Це легко зробити через рекурсивний виклик того самого типу:

```typescript
type TrimRight<S extends string> = S extends `${infer T} `
  ? TrimRight<T>
  : never;
```

Тепер наш тип буде рекурсивно видаляти пробіли один за одним, поки їх не залишиться.
У такому випадку наш умовний тип перейде до помилкової гілки. Оскільки на цьому кроці
ми не маємо пробілу, ми можемо повернути вхідний рядок без будь-яких змін:

```typescript
type TrimRight<S extends string> = S extends `${infer T} ` ? TrimRight<T> : S;
```

Я думав, що це все. Але ми бачимо в тестових випадках, що є деякі помилки. Причина
в тому, що ми не обробляємо символи табуляції та нового рядка. Отже, давайте перемістимо
їх в окремий тип під назвою `Whitespace`, де ми створимо список символів:

```typescript
type Whitespace = " " | "\n" | "\t";
```

А тепер просто замінимо наш символ на тип:

```typescript
type TrimRight<S extends string> = S extends `${infer T}${Whitespace}`
  ? TrimRight<T>
  : S;
```

Повне рішення з обома типами:

```typescript
type Whitespace = " " | "\n" | "\t";
type TrimRight<S extends string> = S extends `${infer T}${Whitespace}`
  ? TrimRight<T>
  : S;
```

## Посилання

- [Об'єднання типів](https://www.typescriptlang.org/docs/handbook/2/everyday-types.html#union-types)
- [Умовні типи](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Виведення типів в умовних типах](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Рекурсивні умовні типи](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
- [Рядкові тип-літерали](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types)
