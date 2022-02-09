---
id: 2257
title: MinusOne
lang: ko
level: medium
tags: math
---

## 챌린지

타입으로 (항상 양수인) 숫자를 받습니다.
구현할 타입은 그 수에서 하나 감소된 수를 반환해야 합니다.

예시:

```typescript
type Zero = MinusOne<1>; // 0
type FiftyFour = MinusOne<55>; // 54
```

## 해답

이번 챌린지는 꽤 어렵습니다.
타입스크립트는 숫자 리터럴 타입과 관련하여 어떠한 기능도 제공하지 않습니다.

따라서 이를 우회하여 해결할 수 있는 방법을 찾아야 하고 해결책이 깔끔하지는 않을 것입니다.
이번 풀이는 조잡해보일 수 있다는 점을 이해해주세요.
(이 풀이를 쓰는 시점에) 더 좋은 풀이가 떠오르지 않았습니다.

먼저 스스로에게 질문을 던져보아야 합니다.
'숫자 리터럴 타입을 사용하지 않고 어떻게 수를 다룰 수 있을까?'
유일하게 생각할 수 있는 방법은 튜플이었습니다.

튜플의 인덱스 타입을 사용해 튜플의 크기를 얻는 챌린지가 있었습니다.
그때 사용했던 문법이 기억 나시나요?
간단합니다. 튜플의 `length` 프로퍼티에 접근하여 얻을 수 있습니다.

필요한 크기(주어지는 수와 같은 크기)의 튜플을 만들고 마지막 원소를 제외한 튜플을 추론합니다.
그 후 추론된 튜플의 길이를 구하면 그 튜플은 이전보다 크기가 하나 감소했을 것입니다.

먼저 필요한 크기의 튜플을 만들 수 있는 헬퍼 타입을 만들겠습니다.
이름은 `Tuple`로 짓겠습니다:

```typescript
type Tuple<L extends number, T extends unknown[] = []> = never;
```

튜플의 길이와 튜플을 담을 수 있는 임시 배열을 받습니다.
이제 임시 배열이 필요한 크기인지 확인해야 합니다.
그러기 위해서 `length` 프로퍼티에 접근하여 필요한 크기와 비교합니다:

```typescript
type Tuple<L extends number, T extends unknown[] = []> = T["length"] extends L
  ? never
  : never;
```

필요한 크기의 배열이라면 튜플을 반환합니다:

```typescript
type Tuple<L extends number, T extends unknown[] = []> = T["length"] extends L
  ? T
  : never;
```

필요한 크기를 만족하지 않는다면 다른 방법을 써야합니다.
재귀적인 타입을 사용하여 임시 배열에 원소를 하나씩 추가합니다.
임시 배열이 필요한 수의 원소를 갖지 못한 경우 이 작업을 반복합니다:

```typescript
type Tuple<L extends number, T extends unknown[] = []> = T["length"] extends L
  ? T
  : Tuple<L, [...T, unknown]>;
```

이제, 예를 들어 `5`를 매개변수로 넣었을 경우에 5개의 `unknown` 원소로 이루어진 튜플을 얻을 수 있습니다.
튜플의 `length` 프로퍼티에 접근하면 숫자 리터럴 타입 `5`를 반환할 것입니다.
정확히 원하던 것입니다.

이 튜플에서 숫자 리터럴 타입 `4`는 어떻게 얻을 수 있을까요?
튜플에서 마지막 원소를 제외한 부분을 추론하면 됩니다!

```typescript
type MinusOne<T extends number> = Tuple<T> extends [...infer L, unknown]
  ? never
  : never;
```

위와 같은 구조를 사용하여 타입 매개변수 `L`에 마지막 원소인 `unknown`이 제외된 튜플을 얻을 수 있습니다.
따라서 이 튜플은 이전보다 원소가 하나 적습니다.

남은 것은 프로퍼티 `length`에 접근한 값을 반환하는 것입니다:

```typescript
type MinusOne<T extends number> = Tuple<T> extends [...infer L, unknown]
  ? L["length"]
  : never;
```

이 방식으로 타입 시스템에서 간단한 빼기를 구현했습니다.
예시로 `MinusOne<5>`를 호출한다면 결과로 숫자 리터럴 `4`를 얻을 수 있습니다.

```typescript
type Tuple<L extends number, T extends unknown[] = []> = T["length"] extends L
  ? T
  : Tuple<L, [...T, unknown]>;
type MinusOne<T extends number> = Tuple<T> extends [...infer L, unknown]
  ? L["length"]
  : never;
```

최근 타입스크립트 버전에서는 재귀적 호출에 대한 제약이 추가 됐다는 점을 감안해 주세요.
따라서 50 이상의 수를 넣을 경우 테스트를 통과할 수 없습니다.
이것이 정확한 풀이라고 자신하지 못한 이유입니다.

만약 더 나은 아이디어가 있다면 설명과 함께 댓글로 남겨주세요.
감사합니다!

## 참고

- [Generics](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Indexed Access Types](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Inferring within Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Recursive Conditional Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
- [Variadic Tuple Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
