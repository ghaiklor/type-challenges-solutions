---
id: 298
title: Length of String
lang: uk
level: medium
tags: template-literal
---

## Завдання

Вирахуйте довжину рядкового літерала. Наприклад:

```typescript
type length = LengthOfString<"Hello, World">; // expected to be 12
```

## Розв'язок

Спочатку я спробував найпростіше рішення – звернутись до властивості `length`
через індексні типи. Сподівався, що TypeScript достатньо розумний, щоб повернути
значення:

```typescript
type LengthOfString<S extends string> = S["length"];
```

На жаль, ні. Таким чином ми отримаємо `number`, але не числовий літерал. Отже,
потрібно придумати інше рішення.

А що, якщо ми виведемо перший символ та решту символів рекурсивно, доти, доки не
залишиться символів в рядку? В такому випадку, ми отримаємо лічильник, який
працює на рекурсії. Почнемо з типу, який виводить перший символ та решту рядка
(хвіст):

```typescript
type LengthOfString<S extends string> = S extends `${infer C}${infer T}`
  ? never
  : never;
```

В тип-параметрі `C` отримуємо перший символ та у `T` отримуємо хвіст. Викликаючи
тип `LengthOfString` рекурсивно з рештою рядка, ми зупинимось у випадку, коли
символів більше не залишиться.

```typescript
type LengthOfString<S extends string> = S extends `${infer C}${infer T}`
  ? LengthOfString<T>
  : never;
```

Проблема в тому, що ми не знаємо, де зберігати наш лічильник. Очевидно, ми
можемо додати інший тип параметр до `LengthOfString`, який буде акумулювати
значення, але TypeScript не надає інструментів для керування числами в системі
типів.

Замість чисел створимо кортеж і будемо додавати по одному символу на кожній
ітерації.

```typescript
type LengthOfString<
  S extends string,
  A extends string[]
> = S extends `${infer C}${infer T}` ? LengthOfString<T, [C, ...A]> : never;
```

Перетворюємо рядковий літерал в кортеж символів цього рядкового літерала. Як
тільки в рядковому літералі не залишається символів – повертаємо довжину
кортежу.

```typescript
type LengthOfString<
  S extends string,
  A extends string[]
> = S extends `${infer C}${infer T}`
  ? LengthOfString<T, [C, ...A]>
  : A["length"];
```

Додавши новий тип параметр ми зламали тести. Тому, що ми передаємо два типи
параметри замість одного. Виправляємо це, додавши до другого параметру значення
за замовчуванням – порожній кортеж.

```typescript
type LengthOfString<
  S extends string,
  A extends string[] = []
> = S extends `${infer C}${infer T}`
  ? LengthOfString<T, [C, ...A]>
  : A["length"];
```

## Посилання

- [Умовні типи](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Виведення типів в умовних типах](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Рекурсивні умовні типи](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
- [Типи шаблонних літералів](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types)
- [Варіативні типи](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
- [Типи пошуку/індексні типи](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)
