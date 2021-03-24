---
id: 189
title: Awaited
lang: uk
level: easy
tags: promise
---

## Завдання

В TypeScript є типи, які обгортають інший, наприклад `Promise`.
Як ми можемо дістати внутрішній тип з такої обгортки?
Наприклад, як, маючи `Promise<ExampleType>`, отримати `ExampleType`?

> Це питання взято з [допису на dev.to](https://dev.to/macsikora/advanced-typescript-exercises-question-1-45k4) від [@maciejsikora](https://github.com/maciejsikora)

## Розв'язок

Досить цікаве завдання, що вимагає від нас знання однієї з недооцінених можливостей TypeScript, як на мене.

Але, перед тим, як пояснити, що я маю на увазі, проаналізуймо завдання.
Автор просить нас розгорнути тип.
Що означає "розгорнути тип"?
Розгортання, це добування внутрішнього типу з іншого, що його огортає.

Розгляньмо на прикладі.
Якщо ми маємо тип `Promise<string>`, то розгортання такого типу `Promise` дасть нам тип `string`, що знаходиться всередині `Promise`.
Ми отримуємо внутрішній тип з зовнішнього.

Тож, до завдання.
Розпочнімо з найпростішого прикладу.
Якщо наш тип `Awaited` отримує `Promise<string>`, пом потрібно повернути `string`, інакше ми повернемо сам `T`, бо він не є `Promise`, а отже повертаємо без змін. Тут в пригоді стануть умовні типи:
If our `Awaited` type gets `Promise<string>`, we need to return the `string`, otherwise we return the `T` itself, because it is not a Promise:

```ts
type Awaited<T> = T extends Promise<string> ? string : T;
```

В цьому рішенні є проблема.
За цією логікою, ми можемо видобути тільки рядки в `Promise`, коли нам необхідно мати підтримку будь-якого типу.
Тож, як цього досягти?
Як видобути тип з `Promise`, якщо ми не знаємо, що в ньому за тип?

Для таких потреб, в TypeScript є виведення типів в умовних типах!
Ми можемо сказати компілятору: “коли знатимеш, що це за тип, присвой його, будь ласка, моєму параметрові”.
Ви можете прочитати більше про [виведення типів в умовних типах тут](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-8.html#type-inference-in-conditional-types).

Знаючи про виведення, ми можемо покращити наше рішення.
Замість перевірки на `Promise<string>` у нашому умовному типі, ми замінимо `string` на `infer R`, бо ми не знаємо, що там має бути.
Єдине, що ми знаємо, це те, що це `Promise<T>` з якимось типом всередині.

Як тільки TypeScript зрозуміє, який тип знаходиться всередині `Promise`, він присвоїть його нашому параметрові `R` і стане доступним у гілці "true", звідки ми його і повернемо.
Виглядатиме це все наступним чином:

```ts
type Awaited<T> = T extends Promise<infer R> ? R : T;
```

## Посилання

- [Умовні типи](https://www.typescriptlang.org/docs/handbook/advanced-types.html#conditional-types)
- [Виведення типів в умовних типах](https://www.typescriptlang.org/docs/handbook/advanced-types.html#type-inference-in-conditional-types)
