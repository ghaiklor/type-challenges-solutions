---
id: 3060
title: Unshift
lang: ko
level: easy
tags: array
---

## 챌린지

`Array.unshift()`를 타입 형태로 구현해보세요.

예시:

```typescript
type Result = Unshift<[1, 2], 0> // [0, 1, 2]
```

## 해답

이 챌린지는 [Push challenge](./easy-push.md)와 매우 유사합니다.
그 챌린지에서 배열 내의 모든 원소들을 가져오기 위해 variadic tuple type을 사용했습니다.

이번에도 비슷하지만 순서만 바꿔보겠습니다.
먼저 입력으로 주어지는 배열의 모든 원소들을 가져옵니다:

```typescript
type Unshift<T, U> = [...T]
```

여기까지만 작성한 경우, “A rest element type must be an array type”이라는 컴파일 에러를 얻습니다.
타입 매개변수에 제약을 주어 에러를 해결합니다:

```typescript
type Unshift<T extends unknown[], U> = [...T]
```

이제 입력으로 주어진 것과 같은 배열을 가지게 되었습니다.
남은 일은 튜플의 맨 앞에 원소를 넣어주는 것입니다.
다음과 같이 해봅시다:

```typescript
type Unshift<T extends unknown[], U> = [U, ...T]
```

위와 같은 방식으로 타입 시스템 내에서 "unshift" 함수를 만들었습니다!

## 참고

- [Generics](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Generic Constraints](https://www.typescriptlang.org/docs/handbook/2/generics.html#generic-constraints)
- [Variadic Tuple Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
