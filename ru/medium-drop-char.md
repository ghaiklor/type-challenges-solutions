---
id: 2070
title: Drop Char
lang: ru
level: medium
tags: template-literal infer
---

## Проблема

Удалите указанный символ со строки.
Например:

```typescript
type Butterfly = DropChar<" b u t t e r f l y ! ", " ">; // 'butterfly!'
```

## Решение

Чтобы решить эту проблему, нужно знать, что такое шаблонные тип литералы в TypeScript.
Вы можете более подробно [о них почитать на их сайте](https://www.typescriptlang.org/docs/handbook/2/template-literal-types.html).

Когда мы используем шаблонные тип литералы, мы можем выводить части строк этого литерала.
Воспользуемся этим, чтобы вывести левую и правую части литерала.
А разделителем будет сам символ, который нам нужно удалить.

```typescript
type DropChar<S, C> = S extends `${infer L}${C}${infer R}` ? never : never;
```

С такой записью, мы получим ошибку компиляции `Type ‘C’ is not assignable to type ‘string | number | bigint | boolean | null | undefined’.`.
Добавим ограничение на дженериках, чтобы этого избежать.

```typescript
type DropChar<S, C extends string> = S extends `${infer L}${C}${infer R}`
  ? never
  : never;
```

Теперь, мы видим что у нас есть две части литерала и отдельно разделитель.
Так как нам нужно разделитель удалить, то мы возвращаем только левую и правую части.

```typescript
type DropChar<S, C extends string> = S extends `${infer L}${C}${infer R}`
  ? `${L}${R}`
  : never;
```

Таким образом, мы удалили один символ со строки.
Чтобы продолжить удалять остальные, вызовем наш тип рекурсивно.

```typescript
type DropChar<S, C extends string> = S extends `${infer L}${C}${infer R}`
  ? DropChar<`${L}${R}`, C>
  : never;
```

Мы покрыли все случаи, кроме случая, когда совпадений по шаблону нет.
Если такая ситуация приключилась, вернём входную строку без изменений.

```typescript
type DropChar<S, C extends string> = S extends `${infer L}${C}${infer R}`
  ? DropChar<`${L}${R}`, C>
  : S;
```

## Что почитать

- [Шаблонные тип литералы](https://www.typescriptlang.org/docs/handbook/2/template-literal-types.html)
- [Условные типы](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Выведение типов в условных типах](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
