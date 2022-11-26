---
id: 4179
title: Flip
lang: uk
level: medium
tags: object-keys
---

## Завдання

Реалізуйте тип `just-flip-object`. Приклади:

```ts
Flip<{ a: "x"; b: "y"; c: "z" }>; // {x: 'a', y: 'b', z: 'c'}
Flip<{ a: 1; b: 2; c: 3 }>; // {1: 'a', 2: 'b', 3: 'c'}
Flip<{ a: false; b: true }>; // {false: 'a', true: 'b'}
```

Не потрібно підтримувати вкладені об'єкти та значення, які не можуть бути
ключами об'єкту, наприклад масиви.

## Розв'язок

Давайте почнемо з базового блоку та побудуємо той самий об'єкт, але замість
значення ми повернемо сам ключ.

```ts
type Flip<T> = { [P in keyof T]: P };
// {key: key, ...}
```

Тепер давайте замінимо ключі згенерованого типу на їхні значення за допомогою
[синтаксису “as”](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#key-remapping-in-mapped-types):

```ts
type Flip<T> = {
  [P in keyof T as T[P] extends AllowedTypes ? T[P] : never]: P;
};
// {value: key, ...}
```

Наш допоміжний тип `AllowedTypes` має містити всі типи, які можна
використовувати як ключ в об'єкті. Дивлячись на тестові випадки, ми бачимо, що
рядок, число та логічні значення можна використовувати як ключі.

```ts
type AllowedTypes = string | number | boolean;
```

Зауважте, що це ще не проходить усі тести. Причина в тому, що ключі об'єкта
можуть бути лише типу `string`. Тому нам потрібно перетворити наші ключі в
рядки.

```ts
type Flip<T> = {
  [P in keyof T as T[P] extends AllowedTypes ? `${T[P]}` : never]: P;
};
```

## Посилання

- [Умовні типи](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Перепризначення ключів в типах зіставлення](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#key-remapping-in-mapped-types)
- [Типи зіставлення](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
