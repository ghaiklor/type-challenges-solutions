---
id: 106
title: Trim Left
lang: uk
level: medium
tags: template-literal
---

## Завдання

Реалізувати `TrimLeft<T>`, який приймає рядковий тип-літерал й повертає новий —
без пробілів з лівого боку. Наприклад:

```typescript
type trimmed = TrimLeft<"  Hello World  ">; // expected to be 'Hello World  '
```

## Розв'язок

Коли потрібно працювати з рядками в TypeScript, швидше за все знадобляться
рядкові тип-літерали в системі типів TypeScript. Вони дозволяють моделювати
різну поведінку пов'язану з рядками.

В цьому завданні два випадки: рядок з пробілом на початку й рядок без пробілу. У
випадку, якщо рядок містить пробіл на початку, виведемо решту рядка без цього
пробілу. Продовжимо цей процес рекурсивно, поки пробіл не зникне. Як тільки це
сталося, повертаємо вхідний рядок без змін.

Використаємо умовні типи й виведемо необхідні частини рядка, використовуючи
рядковий тип-літерал:

```typescript
type TrimLeft<S> = S extends ` ${infer T}` ? TrimLeft<T> : S;
```

Бачимо, що деякі з тестів не проходять. Це тому, що ми не опрацьовуємо ситуацію
з перенесенням рядків й табуляцією.

Виправимо це, замінивши пробіл на об'єднання символів "пробіл", "перенесення
рядка", "табуляція":

```typescript
type TrimLeft<S> = S extends `${" " | "\n" | "\t"}${infer T}` ? TrimLeft<T> : S;
```

## Посилання

- [Умовні типи](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Виведення типів в умовних типах](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Рекурсивні умовні типи](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
- [Рядкові тип-літерали](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types)
