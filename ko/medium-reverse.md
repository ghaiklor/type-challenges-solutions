---
id: 3192
title: Reverse
lang: ko
level: medium
tags: tuple
---

## 챌린지

`Array.reverse()`를 타입 시스템 내에서 구현해보세요.
예시:

```typescript
type a = Reverse<['a', 'b']> // ['b', 'a']
type b = Reverse<['a', 'b', 'c']> // ['c', 'b', 'a']
```

## 해답

튜플을 뒤집는 것은 생각보다 어렵지 않습니다.
튜플의 마지막 원소를 가져와 다른 튜플의 첫번째 자리에 넣어주면 됩니다.
이 실행을 재귀적으로 반복하면 뒤집어진 튜플을 얻을 수 있습니다.

먼저 형태를 잡고 구현을 시작하겠습니다:

```typescript
type Reverse<T> = any
```

위에서 언급했던 것처럼 튜플의 마지막 원소와 그 나머지를 구분해서 얻어야 합니다.
그러기 위해서 조건부 타입의 타입 추론을 적용하겠습니다:

```typescript
type Reverse<T> = T extends [...infer H, infer T]
  ? never
  : never
```

튜플의 첫 부분에 스프레드 연산자를 사용한 것을 주목해주세요.
위의 형태는 타입스크립트에게 마지막 원소를 제외한 튜플 전체인 타입 매개변수 `H`와 마지막 원소가 할당된 타입 매개변수 `T`를 반환해 줄 것을 요청하는 것과 같습니다.
튜플의 마지막 원소를 얻었다면 새로운 튜플을 만들어 `T`를 넣습니다:

```typescript
type Reverse<T> = T extends [...infer H, infer T]
  ? [T]
  : never
```

이 과정을 통해 마지막 원소를 첫번째 자리에 넣었습니다.
튜플의 나머지 원소에 같은 과정을 반복하여 적용해야 합니다.
`Reverse` 타입을 재귀적으로 호출하여 이 작업을 쉽게 처리할 수 있습니다:

```typescript
type Reverse<T> = T extends [...infer H, infer T]
  ? [T, Reverse<H>]
  : never
```

단 `Reverse` 타입을 호출하는 것은 튜플 내부에 튜플을 반환하므로 호출할 때마다 튜플이 더 깊어질 것입니다.
이것은 원하는 동작이 아닙니다.
`Reverse` 타입의 결과에 스프레드 연산자를 적용하여 평탄화할 수 있습니다:

```typescript
type Reverse<T> = T extends [...infer H, infer T]
  ? [T, ...Reverse<H>]
  : never
```

주어지는 타입 매개변수 `T`가 조건에 맞지 않는다면 어떻게 해야할까요?
이 경우 빈 배열을 반환하여 스프레드 연산자가 올바르게 작동할 수 있도록 합니다:

```typescript
type Reverse<T> = T extends [...infer H, infer T]
  ? [T, ...Reverse<H>]
  : []
```

## 참고

- [Generics](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Inferring within Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Recursive Conditional Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
- [Variadic Tuple Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
