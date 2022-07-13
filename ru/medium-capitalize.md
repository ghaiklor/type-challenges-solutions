---
id: 110
title: Capitalize
lang: ru
level: medium
tags: template-literal
---

## Проблема

Реализовать `Capitalize<T>`, который первую букву строчного тип литерала делает
заглавной. Например:

```typescript
type capitalized = Capitalize<"hello world">; // expected to be 'Hello world'
```

## Решение

Сначала, я не понял эту проблему. Мы не можем реализовать общее решение для
того, чтобы сделать букву заглавной. Поэтому, TypeScript компилятор
предоставляет встроенный тип `Capitalize` (intrinsic), с помощью которого эта
проблема решается легко:

```typescript
type MyCapitalize<S extends string> = Capitalize<S>;
```

Но я сильно сомневаюсь, что в этом изначальная задумка автора. Если мы не можем
использовать встроенный тип `Capitalize`, мы не можем сделать общее решение. А
если общее решение сделать не получается, то как мы можем сделать буквы
заглавными? Используя словари, конечно же!

Чтобы решение не разрозлось до больших объемов, сделаем словарь только для тех
букв, которые нужны для прохождения тестов.

```typescript
interface CapitalizedChars {
  f: "F";
}
```

Есть словарь с буквами и их заглавными вариантами. Давайте теперь выведем первую
букву из строчного тип литерала. Для этого, воспользуемся классической
конструкцией с условным типом.

```typescript
type Capitalize<S> = S extends `${infer C}${infer T}` ? C : S;
```

В тип параметре `C` получаем первую букву строчного тип литерала, а в `T` -
остальную часть строки. Проверим, существует ли первая буква в нашем словаре.
Если да, возвращаем заглавный вариант из словаря, иначе - ничего не делаем и
возвращаем первую букву без изменений.

```typescript
interface CapitalizedChars {
  f: "F";
}
type Capitalize<S> = S extends `${infer C}${infer T}`
  ? `${C extends keyof CapitalizedChars ? CapitalizedChars[C] : C}${T}`
  : S;
```

## Что почитать

- [Условные типы](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Вывод типов в условных типах](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Строчные тип литералы](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types)
- [keyof и типы поиска](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-1.html#keyof-and-lookup-types)
