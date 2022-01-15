---
id: 459
title: Flatten
lang: ko
level: medium
tags: array
---

## 챌린지

이번 챌린지는 배열을 받아서 평탄화 한 뒤 반환해주는 타입을 작성하는 것입니다.

예시:

```ts
type flatten = Flatten<[1, 2, [3, 4], [[[5]]]> // [1, 2, 3, 4, 5]
```

## 해답

이번 타입을 작성할 때의 종료 조건은 타입이 빈 배열인 경우입니다.
빈 배열을 받을 경우에는 그대로 빈 배열을 반환해줍니다. 이미 평탄화 된 형태이기 때문입니다.
그렇지 않을 경우에는 `T` 자신을 반환해줍니다:

```typescript
type Flatten<T> = T extends [] ? [] : T
```

만약 `T`가 빈 배열이 아닐 경우에 `T`는 원소를 가진 배열이거나 원소일 수 있습니다.
원소를 가진 배열일 경우에는 어떻게 해야 할까요?
맨 앞 원소와 그 뒷부분으로 나누어 타입을 추론합니다.
지금은 추론한 타입을 그대로 반환하는 것으로 작성합니다:

```typescript
type Flatten<T> = T extends [] ? [] : T extends [infer H, ...infer T] ? [H, T] : [T]
```

배열이 아닐 경우도 생각해야 합니다.
그 경우엔 배열이 아닌 원소로 간주하고 원소를 튜플 형태로 감싸 반환합니다.

배열의 앞부분과 뒷부분으로 나누었으므로 추론된 각 타입을 이용해 `Flatten` 타입을 재귀적으로 호출합니다.
위 방식으로 타입이 평탄화 될 때까지 수행한 뒤 원소 형태의 최종 타입이 `[T]`를 반환하도록 합니다:

```typescript
type Flatten<T> = T extends [] ? [] : T extends [infer H, ...infer T] ? [...Flatten<H>, ...Flatten<T>] : [T]
```

## 참고

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Type inference in conditional types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Recursive Conditional Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
- [Variadic Tuple Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
