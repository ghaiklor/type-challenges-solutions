---
id: 13
title: Hello, World
lang: ko
level: warm
tags: warm-up
---

## 챌린지

Type Challenges에서는 타입을 표명하기 위해 타입시스템을 사용합니다.

이번 챌린지는 주어지는 코드를 (타입체크에서 에러가 발생하지 않도록) 수정하여 테스트를 통과하게 만드는 것입니다.

```ts
// expected to be string
type HelloWorld = any
```

```ts
// you should make this work
type test = Expect<Equal<HelloWorld, string>>
```

## 해답

이번 챌린지는 Type challenges가 제공하는 플레이그라운드에서 어떻게 챌린지에 도전해볼 수 있는지 등에 익숙해지기 위한 몸풀기 챌린지입니다.
우리는 단순히 `any` 대신에 `string`으로 타입을 바꿔주기만 하면 됩니다.

```ts
type HelloWorld = string
```

## 참고

- [Typed JavaScript at Any Scale](https://www.typescriptlang.org)
- [The TypeScript Handbook](https://www.typescriptlang.org/docs/handbook/intro.html)
- [TypeScript for Java/C# Programmers](https://www.typescriptlang.org/docs/handbook/typescript-in-5-minutes-oop.html)
- [TypeScript for Functional Programmers](https://www.typescriptlang.org/docs/handbook/typescript-in-5-minutes-func.html)
