---
id: 16
title: Pop
lang: ko
level: medium
tags: array
---

## 챌린지

배열 `T`를 받아서 배열의 마지막 원소를 제외한 배열을 반환해주는 제네릭 `Pop<T>`를 구현해보세요.

예시:

```ts
type arr1 = ["a", "b", "c", "d"];
type arr2 = [3, 2, 1];

type re1 = Pop<arr1>; // expected to be ['a', 'b', 'c']
type re2 = Pop<arr2>; // expected to be [3, 2]
```

## 해답

배열을 두 부분으로 나누고자 합니다: 첫 원소부터 마지막 원소 전까지와 마지막 원소로요.
이후에 마지막 원소를 제거하고 남은 부분만 반환할 수 있습니다.

이를 위해 [가변 인자 튜플 타입](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)을 사용할 수 있습니다.
이를 [조건부 타입 내에서의 타입 추론](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)과 함께 사용하면 원하는 부분을 추론할 수 있습니다:

```ts
type Pop<T extends any[]> = T extends [...infer H, infer T] ? H : never;
```

`T`가 두 부분으로 나뉠 수 있는 배열이라면 마지막 원소를 제외하고 반환하고 그렇지 않다면 `never` 타입을 반환합니다.

## 참고

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Type inference in conditional types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Variadic Tuple Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
