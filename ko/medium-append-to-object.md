---
id: 527
title: Append to Object
lang: ko
level: medium
tags: object-keys
---

## 챌린지

인터페이스에 새로운 필드를 추가하는 타입을 구현해보세요.
타입은 세 개의 인자를 받습니다.
새로운 필드가 추가된 오브젝트를 반환해야 합니다.

예시:

```ts
type Test = { id: '1' }
type Result = AppendToObject<Test, 'value', 4> // expected to be { id: '1', value: 4 }
```

## 해답

타입스크립트에서 오브젝트\인터페이스를 변경할 때에 주로 교차타입을 이용할 수 있습니다.
이 챌린지도 같은 방식으로 하면 됩니다.
기존의 오브젝트 `T`와 새로운 프로퍼티로 만든 오브젝트를 더하는 타입을 작성해보겠습니다:

```typescript
type AppendToObject<T, U, V> = T & { [P in U]: V }
```

아쉽지만 이 풀이는 테스트를 통과하지 못합니다.
테스트는 교차타입이 아니라 평탄화 된 타입이 오는 것을 기대합니다.
따라서 기존의 프로퍼티들과 새 프로퍼티가 포함된 하나의 오브젝트를 반환하는 타입이 필요합니다.
우선 `T`의 프로퍼티들을 매핑하는 것부터 시작하겠습니다:

```typescript
type AppendToObject<T, U, V> = { [P in keyof T]: T[P] }
```

이제 `T`의 프로퍼티들에 새 프로퍼티인 `U`를 추가해야 합니다.
간단한 트릭을 통해 쉽게 해결할 수 있습니다.
`in` 연산자에 유니온을 전달하는 방법입니다:

```typescript
type AppendToObject<T, U, V> = { [P in keyof T | U]: T[P] }
```

이 방식으로 `T`의 모든 프로퍼티와 `U`의 프로퍼티를 얻을 수 있습니다.
`U`에 제약조건을 추가하여 사소한 에러를 해결해 줍시다:

```typescript
type AppendToObject<T, U extends string, V> = { [P in keyof T | U]: T[P] }
```

`P`는 `T`와 `U`의 유니온이기 때문에 타입스크립트가 `T`에 속하지 않는 `P`에 대해서도 다룰 수 있게 해주어야 합니다.
조건을 검사하여 `P`가 `T`에 속한다면 `T[P]`를 반환하고 그렇지 않다면 `V`를 반환할 수 있도록 설정합니다:

```typescript
type AppendToObject<T, U extends string, V> = { [P in keyof T | U]: P extends keyof T ? T[P] : V }
```

## 참고

- [Mapped Types](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Union Types](https://www.typescriptlang.org/docs/handbook/2/everyday-types.html#union-types)
