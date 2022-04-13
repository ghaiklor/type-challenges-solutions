---
id: 2
title: Get Return Type
lang: ko
level: medium
tags: infer built-in
---

## 챌린지

`ReturnType<T>` 유틸리티 타입을 사용하지 않고 직접 구현해보세요.

예시:

```ts
const fn = (v: boolean) => {
  if (v) return 1;
  else return 2;
};

type a = MyReturnType<typeof fn>; // should be "1 | 2"
```

## 해답

[조건부 타입에서 타입 추론](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)을 사용하는 대부분의 경우는 사용될 타입이 무엇인지 확실하지 않을 때입니다.
이번 챌린지가 그 경우입니다.
함수의 반환 타입이 무엇인지 모르지만 그것을 알아내야 합니다.

`() => void`와 같은 타입을 갖는 함수를 예로 들겠습니다.
`void` 자리에 무엇이 들어갈지 정확히 알지 못합니다.
이 경우 그 자리를 `infer R`로 대체해주겠습니다. 이것이 풀이의 첫 단계입니다:

```ts
type MyReturnType<T> = T extends () => infer R ? R : T;
```

주어지는 타입 `T`가 함수라면 반환 타입을 추론하고 아닌 경우 `T`를 그대로 반환합니다. 어렵지 않습니다.

함수에 매개변수가 함께 전달될 경우엔 풀이가 제대로 동작하지 않습니다.
`() => infer R` 타입에 할당할 수 없기 때문입니다.

어떤 매개변수도 받을 수 있고 그것에 상관하지 않을 것임을 보여주기 위해 타입의 인자에 `...args: any[]`를 추가합니다:

```ts
type MyReturnType<T> = T extends (...args: any[]) => infer R ? R : T;
```

## 참고

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Type inference in conditional types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
