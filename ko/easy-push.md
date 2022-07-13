---
id: 3057
title: Push
lang: ko
level: easy
tags: array
---

## 챌린지

`Array.push`를 타입 시스템 내에서 구현해보세요.

예시:

```typescript
type Result = Push<[1, 2], "3">; // [1, 2, '3']
```

## 해답

비교적 쉬운 문제입니다. 배열에 원소를 추가하는 타입을 구현하기 위해 두 가지가 필
요합니다. 우선 배열의 모든 원소를 얻어오고 그 후에 얻어온 원소들에 추가로 원소를
하나 더해주면 됩니다.

배열에 있는 모든 원소를 얻기 위해서, 우리는 가변 인자 튜플 타입(variadic tuple
type)을 활용할 수 있습니다. 입력 타입인 `T`에서 원소들을 얻어 `T`와 같은 배열을
반환하도록 만들어봅시다:

```typescript
type Push<T, U> = [...T];
```

“A rest element type must be an array type”라는 컴파일 에러를 얻습니다. 이는 배
열 혹은 유사배열이 아닌 타입에는 가변 인자 튜플 타입을 사용할 수 없기 때문입니다
. 제네릭 제약조건을 추가하여 배열에 대해서만 다룰 것임을 보여줍시다:

```typescript
type Push<T extends unknown[], U> = [...T];
```

배열로 주어지는 타입 매개변수 `T`의 복사본을 얻었습니다. 이제 `U`의 원소를 추가
해주면 됩니다:

```typescript
type Push<T extends unknown[], U> = [...T, U];
```

위의 과정을 통해 타입 시스템 내에서 `Array.push` 동작을 구현해보았습니다.

## 참고

- [Generics](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Variadic Tuple Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
