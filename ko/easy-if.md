---
id: 268
title: If
lang: ko
level: easy
tags: utils
---

## 챌린지

조건 `C`를 받아서 참일 경우에는 `T`를 반환하고 거짓일 경우에는 `F`를 반환하는 유
틸리티 타입 `If`를 구현해보세요. `C`는 `true` 또는 `false`일 것이 기대되고,
`T`와 `F`는 어떤 타입이든 괜찮습니다.

예시:

```ts
type A = If<true, "a", "b">; // expected to be 'a'
type B = If<false, "a", "b">; // expected to be 'b'
```

## 해답

Typescript에서
[조건부 타입](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)을
써야하는 확실한 경우는 타입 내에서 "if"문을 사용할 때입니다. 이번 풀이에 사용할
방법이기도 합니다.

만약 주어진 조건이 `true`로 평가된다면 "true" 분기를 타야하고 그렇지 않을 경우에
는 "false" 분기를 타야합니다:

```ts
type If<C, T, F> = C extends true ? T : F;
```

여기까지만 진행했다면 컴파일 에러가 생길 것입니다. `C`의 타입에 대한 제약없이 불
린 타입에 할당하려고 했기 때문입니다. 타입인자 `C`에 `extends boolean`을 추가해
주어 이 문제를 해결할 수 있습니다:

```ts
type If<C extends boolean, T, F> = C extends true ? T : F;
```

## 참고

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
