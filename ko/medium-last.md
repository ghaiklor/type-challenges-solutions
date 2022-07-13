---
id: 15
title: Last of Array
lang: ko
level: medium
tags: array
---

## 챌린지

배열 `T`를 받아 배열의 마지막 원소를 반환하는 제네릭 `Last<T>`를 구현해보세요.

예시:

```ts
type arr1 = ["a", "b", "c"];
type arr2 = [3, 2, 1];

type tail1 = Last<arr1>; // expected to be 'c'
type tail2 = Last<arr2>; // expected to be 1
```

## 해답

배열의 마지막 원소를 얻으려면 배열의 첫 원소부터 시작해서 마지막 원소를 찾을 때
까지 모든 원소를 얻어와야 합니다. 위와 같은 생각이
[가변 인자 튜플 타입](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)을
사용해야 한다는 힌트가 됩니다. 배열과 그 원소들을 다룰 것이기 때문입니다.

가변 인자 튜플 타입까지 생각하고 나면 풀이는 꽤 쉽습니다. 배열의 마지막 원소와그
나머지를 얻어오면 됩니다.
[조건부 타입에서의 타입 추론](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)과
함께 사용하면 쉽게 마지막 원소를 추론할 수 있습니다:

```ts
type Last<T extends any[]> = T extends [...infer X, infer L] ? L : never;
```

## 참고

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Type inference in conditional types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Variadic Tuple Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
