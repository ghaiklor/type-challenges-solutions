---
id: 3312
title: Parameters
lang: ko
level: easy
tags: infer
---

## 챌린지

`MyParameters<T>`를 빌트인 제네릭 `Parameters<T>`를 사용하지 않고 구현해보세요.

## 해답

이 문제를 해결하려면 함수로부터 정보의 일부를 가져올 수 있어야 합니다. 조금 더 자세히 말하자면 함수의 매개변수들을 가져와야 합니다.

"아직 모르는 타입을 알아내는" 적절한 방법은 무엇일까요? 바로 `infer` 키워드 입니다.
바로 `infer`을 사용하기 전에 먼저 함수와 일치하는 간단한 조건부 타입에 대해서 보겠습니다.

```ts
type MyParameters<T> = T extends (...args: any[]) => any ? never : never;
```

type `T`가 매개변수와 리턴타입이 있는 함수와 일치하는지 확인합니다. 여기서 `any[]`를 infer로 대체할 수 있습니다.

```ts
type MyParameters<T extends (...args: any[]) => any> = T extends (...args : infer U) => any ? U : never;
```

조건부 타입에서 `infer` 키워드는 분기의 "참"값에서 비교하는 타입을 추론할 수 있습니다.

만약 `T`에 할당되는 매개변수가 `[number,string]` 일 경우, 타입스크립트 컴파일러는 함수의 매개변수 목록을 추론해서 `U`에 `[number,string]` 을 할당해줍니다.

## 참고

- [Generics](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Inferring within Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
