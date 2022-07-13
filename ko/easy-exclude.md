---
id: 43
title: Exclude
lang: ko
level: easy
tags: built-in
---

## 챌린지

내장타입인 `Exclude<T, U>`를 구현해보세요. `T`에 있는 타입 중 `U`에 할당 가능한
타입들을 제거해야 합니다.

예시:

```ts
type T0 = Exclude<"a" | "b" | "c", "a">; // expected "b" | "c"
type T1 = Exclude<"a" | "b" | "c", "a" | "b">; // expected "c"
```

## 해답

이 문제의 핵심은 Typescript에서
[조건부 타입이 분산됨](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#distributive-conditional-types)을
아는 것입니다.

`T`가 유니온일 때 `T extends U`와 같은 구조를 사용하면, Typescript는 유니온
`T`를 순회하면서 각 원소들을 주어진 조건에 적용합니다.

따라서 이번 해답은 매우 간단합니다. `T`가 `U`에 할당될 수 있는지 검사하고 할당가
능하다면 그 원소를 생략합니다.

```ts
type MyExclude<T, U> = T extends U ? never : T;
```

## 참고

- [Distributive Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#distributive-conditional-types)
