---
id: 116
title: Replace
lang: uk
level: medium
tags: template-literal
---

## Завдання

Реалізувати тип `Replace<S, From, To>` який замінить рядок `From` рядком `To` у даному рядку `S`.

Приклад:

```ts
type replaced = Replace<"types are fun!", "fun", "awesome">; // expected to be 'types are awesome!'
```

## Розв'язок

На вході ми маємо рядок `S`, в якому ми маємо знайти збіг з `From` і замінити його на `To`.
Це означає, що нам потрібно розділити наш рядок на три частини та виокремити кожну з них.

З цього й розпочнемо.
Ми виділимо ліву частину рядка, поки не знайдено `From`, власне, `From` та третім шматком те, що буде справа від нього:

```ts
type Replace<
  S,
  From extends string,
  To
> = S extends `${infer L}${From}${infer R}` ? S : S;
```

Після цього, ми маємо виокремлений підрядок `From` та ті частини, що його оточують.
Тож, ми можемо повернути новий шаблонний літерал з'єднавши частини та замінивши збіг:

```ts
type Replace<
  S,
  From extends string,
  To extends string
> = S extends `${infer L}${From}${infer R}` ? `${L}${To}${R}` : S;
```

Рішення працює без проблем, окрім випадку, коли `From` – порожній рядок.
В такому разі TypeScript не виокремить частини.
Виправимо це, додавши обробку крайнього випадку з порожнім рядком:

```ts
type Replace<
  S extends string,
  From extends string,
  To extends string
> = From extends ""
  ? S
  : S extends `${infer L}${From}${infer R}`
  ? `${L}${To}${R}`
  : S;
```

## Посилання

- [Умовні типи](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Виведення типів ув умовних типах](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Типи шаблонних літералів](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types)
