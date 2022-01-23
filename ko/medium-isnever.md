---
id: 1042
title: IsNever
lang: ko
level: medium
tags: union utils
---

## 챌린지

입력 타입으로 `T`를 받는 타입 `IsNever<T>`를 구현해보세요.
`T`의 타입이 `never`로 결정된다면 `true`를 반환하고 반대의 경우 `false`를 반환합니다.

예시:

```typescript
type A = IsNever<never>; // expected to be true
type B = IsNever<undefined>; // expected to be false
type C = IsNever<null>; // expected to be false
type D = IsNever<[]>; // expected to be false
type E = IsNever<number>; // expected to be false
```

## 해답

타입이 `never`에 할당 가능한지 확인하는 가장 확실한 방법은 조건부 타입을 사용하는 것입니다.
타입 `T`를 `never`에 할당할 수 있다면 `true`를 반환하고 반대의 경우 `false`를 반환합니다.

```typescript
type IsNever<T> = T extends never ? true : false;
```

아쉽지만 `never`의 경우 테스트 케이스를 통과할 수 없습니다.
이유가 무엇일까요?

`never` 타입은 발생 불가능한 타입에 대한 표현입니다.
`never` 타입은 타입스크립트에서 모든 다른 타입의 서브타입이고 따라서 어떤 타입에도 `never`를 할당할 수 없습니다.
`never`의 서브타입은 존재하지 않기 때문에 `never`는 스스로인 `never`를 제외하고는 어떤 타입도 할당될 수 없습니다.

이는 또다른 문제로 이어집니다.
`never`에 아무 타입도 할당할 수 없다면 어떤 타입이 `never`에 할당 가능한지 어떻게 확인할 수 있을까요?

`never`를 활용한 타입을 만들어 보는 것은 어떨까요?
타입 `T`가 `never`에 할당 가능한지 확인하지 않고 `never`를 포함한 튜플에 대해 확인 해보겠습니다.
이 경우엔 형식상 `never`에 어떤 타입을 할당하려는 것이 아닙니다.

```typescript
type IsNever<T> = [T] extends [never] ? true : false;
```

위와 같은 참신한 방법을 통해 주어진 타입이 `never` 타입인지 확인하는 제네릭 타입을 구현하여 테스트를 통과할 수 있습니다.

## 참고

- [never type](https://www.typescriptlang.org/docs/handbook/2/narrowing.html#the-never-type)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Generics](https://www.typescriptlang.org/docs/handbook/2/generics.html)
