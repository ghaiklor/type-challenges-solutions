---
id: 14
title: First of Array
lang: ko
level: easy
tags: array
---

## 챌린지

배열 `T`를 받아 배열의 첫번째 원소를 반환해 주는 제네릭 `First<T>`를 구현해보세
요.

예시:

```ts
type arr1 = ["a", "b", "c"];
type arr2 = [3, 2, 1];

type head1 = First<arr1>; // expected to be 'a'
type head2 = First<arr2>; // expected to be 3
```

## 해답

가장 먼저 떠오르는 것은 인덱스 접근 연산자를 사용해서 `T[0]`과 같이 작성하는 것
입니다:

```ts
type First<T extends any[]> = T[0];
```

여기서는 더 신경써서 다뤄야 할 케이스가 남아있습니다. 만약 빈 배열을 넣는다면 어
떠한 원소도 존재하지 않기 때문에 `T[0]`는 동작하지 않을 것입니다.

따라서 배열의 첫번째 원소에 접근하기 전에, 배열이 비어있는지 확인할 필요가 있습
니다. 그러기 위해서 Typescript의
[조건부 타입](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)을
활용할 수 있습니다.

조건부 타입의 동작은 어렵지 않습니다. 주어진 타입이 조건에 있는 타입에 할당될 수
있다면, 그 타입은 "true" 분기를 타고 갈 것이고, 그렇지 않다면 "false" 분기를 타
고 갈 것입니다.

이 문제의 경우 배열이 비어있는지 확인해서 비어있다면 아무것도 반환하지 않고 비어
있지 않다면 배열의 첫번째 원소를 반환해주면 됩니다:

```ts
type First<T extends any[]> = T extends [] ? never : T[0];
```

## 참고

- [Indexed Types](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
