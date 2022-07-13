---
id: 9
title: Deep Readonly
lang: ko
level: medium
tags: readonly object-keys deep
---

## 챌린지

`DeepReadonly<T>` 제네릭을 구현 해보세요. 오브젝트의 모든 속성과 하위의 오브젝트
들은 재귀적인 방식을 통해 `readonly`로 설정됩니다.

이 챌린지에서는 오브젝트만을 다루는 것으로 가정합니다. 배열이나 함수, 클래스 등
은 고려하지 않아도 됩니다. 물론 다른 경우들까지 고려한 해답에 도전해 보는 것도좋
습니다.

예시:

```ts
type X = {
  x: {
    a: 1;
    b: "hi";
  };
  y: "hey";
};

type Expected = {
  readonly x: {
    readonly a: 1;
    readonly b: "hi";
  };
  readonly y: "hey";
};

const todo: DeepReadonly<X>; // should be same as `Expected`
```

## 해답

이 챌린지에서 [`Readonly<T>`](./easy-readonly.md) 타입과 동일한 타입을 만들어야
합니다. 유일한 차이점은 동작이 재귀적이어야 한다는 것입니다.

기초부터 시작하기 위해 일반적인 [`Readonly<T>`](./easy-readonly.md) 타입을 먼저
구현합니다:

```ts
type DeepReadonly<T> = { readonly [P in keyof T]: T[P] };
```

이미 생각한 바와 같이 이 타입은 모든 것을 read-only로 만들어주지 않습니다. 깊이
가 1인 속성들에 한해서만 적용됩니다. 그 이유는 `T[P]`가 기본 타입이 아닌 오브젝
트일 경우 오브젝트의 속성들을 read-only로 만들지 않기 때문입니다.

따라서 `T[P]`에 `DeepReadonly<T>`의 재귀적인 방법을 적용해야 합니다. 재귀를 사용
하는 경우의 종료 조건도 잊지 말고 추가해 주세요.

알고리즘은 간단합니다. `T[P]`가 오브젝트일 경우 `DeepReadonly`를 통해 한 단계 더
깊게 이동합니다. 그렇지 않을 경우 `T[P]`를 반환하면 됩니다:

```ts
type DeepReadonly<T> = {
  readonly [P in keyof T]: T[P] extends Record<string, unknown>
    ? DeepReadonly<T[P]>
    : T[P];
};
```

## 참고

- [Index Types](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)
- [Mapped Types](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Recursive Conditional Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
