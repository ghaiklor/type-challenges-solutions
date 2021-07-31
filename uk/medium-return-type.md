---
id: 2
title: Get Return Type
lang: uk
level: medium
tags: infer built-in
---

## Завдання

Реалізувати вбудований `ReturnType<T>`.
Приклад використання:

```typescript
const fn = (v: boolean) => {
  if (v)
    return 1
  else
    return 2
}

type a = MyReturnType<typeof fn> // should be "1 | 2"
```

## Розв'язок

Як правило, виведення типів в умовних типах використовується в тих місцях, де ми не впевнені, що очікуємо.
Як в цьому випадку.
Ми знаємо, що `T` це функція, але ми не знаємо, який тип повернення очікувати.

Тому, використаємо умовні типи й вкажемо функцію з `infer R`.
Це й буде перша ітерація розв'язку.

```typescript
type MyReturnType<T> = T extends () => infer R ? R : T;
```

У випадку, якщо `T` присвоюється до функції, виводимо тип повернення й повертаємо його.
Інакше, повертаємо `T` без змін.
Проблема такого рішення в тому, що якщо передати функцію з параметрами, вона не буде присвоюватися до `() => infer R`.
Відповідно, умовний тип не спрацює.

Виразимо в типах, що функція приймає, що завгодно як параметри.
Нам неважлива їхня доля, тому ніяких додаткових операцій з ними не робимо.

```typescript
type MyReturnType<T> = T extends (...args: any[]) => infer R ? R : T;
```

## Посилання

- [Умовні типи](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Виведення типів в умовних типах](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
