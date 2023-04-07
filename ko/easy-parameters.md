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

이 문제를 해결하기 위해서는 `infer` 라는 키워드에 대해서 알아야 합니다.
조건부 타입에서 `infer` 키워드는 "참"값 분기에서 비교하는 타입을 추론할 수 있습니다.

만약 `T`에 할당되는 매개변수가 `[number,string]` 일 경우, 타입스크립트 컴파일러는 함수의 매개변수 목록을 추론해서 `U`에 `[number,string]` 을 할당해줍니다.

```ts
type MyParameters<T extends (...args: any[]) => any> = T extends (...args : infer U) => any ? U : never;
```


## 참고
- [Generics](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Inferring within Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
