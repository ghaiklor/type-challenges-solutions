---
id: 1367
title: Remove Index Signature
lang: ko
level: medium
tags: object-keys
---

## 챌린지

오브젝트에서 인덱스 시그니처를 제거하는 `RemoveIndexSignature<T>`를 구현해보세요.
예시:

```typescript
type Foo = {
  [key: string]: any;
  foo(): void;
};

type A = RemoveIndexSignature<Foo>; // expected { foo(): void }
```

## 해답

이 챌린지에서는 오브젝트를 다루어야 합니다.
마지막에는 매핑 타입을 사용할 것을 예상할 수 있습니다.
하지만 그전에, 문제를 분석하고 요구사항을 정의해 보겠습니다.

오브젝트에서 인덱스 시그니처를 제거하는 것이 필요합니다.
인덱스 시그니처는 어떻게 표현될까요?
`keyof` 연산자를 사용하여 알 수 있습니다.

예시로 타입 "Bar"에 `keyof` 연산자를 적용한 결과입니다:

```typescript
type Bar = { [key: number]: any; bar(): void }; // number | “bar”
```

오브젝트의 키는 문자열 리터럴 타입으로 표현되는 것을 알 수 있습니다.
반면에 인덱스 시그니처는 단지 `number` 또는 `string` 타입을 갖습니다.

이 사실을 통해 타입 리터럴이 아닌 키들을 필터링해주는 아이디어를 생각했습니다.
타입이 타입 리터럴인지 어떻게 검사해 줄 수 있을까요?
집합의 특성을 이용하여 포함관계를 검사할 수 있습니다.
예시로 타입 리터럴 "foo"는 문자열에 포함됩니다. 반대로 문자열은 "foo"에 포함될 수 없습니다.

```typescript
"foo" extends string // true
string extends "foo" // false
```

타입 리터럴만 남을 수 있도록 strings와 numbers를 필터링하는 타입을 만듭니다.
먼저 타입이 `string`인지 검사합니다:

```typescript
type TypeLiteralOnly<T> = string extends T ? never : never;
```

`T`가 `string`인 경우, 조건은 `true`로 평가됩니다.
`string`인 경우에는 어떻게 처리할까요?
`never` 타입을 반환하여 생략할 수 있습니다.
반대의 경우 `number` 타입에 대해 같은 검사를 합니다:

```typescript
type TypeLiteralOnly<T> = string extends T
  ? never
  : number extends T
  ? never
  : never;
```

`T`가 `string`과 `number` 모두 아닐 경우는요?
타입 리터럴인 경우를 의미하기 때문에 호출자에게 타입을 반환합니다:

```typescript
type TypeLiteralOnly<T> = string extends T
  ? never
  : number extends T
  ? never
  : T;
```

인덱스 시그니처를 필터링하고 타입 리터럴만 반환하는 래핑 타입을 만들었습니다.
각 키에 어떻게 적용해야 할까요?
매핑 타입을 이용할 수 있습니다!

먼저 타입의 복사본을 만듭니다.

```typescript
type RemoveIndexSignature<T> = { [P in keyof T]: T[P] };
```

키를 순회하면서 래핑 타입을 이용하여 리매핑을 할 수 있습니다.
각 키에 `TypeLiteralOnly`를 호출합니다:

```typescript
type RemoveIndexSignature<T> = { [P in keyof T as TypeLiteralOnly<P>]: T[P] };
```

이 방식으로 키를 순회하며 인덱스 시그니처를 필터링하고 타입 리터럴만 남길 수 있습니다.

```typescript
type TypeLiteralOnly<T> = string extends T
  ? never
  : number extends T
  ? never
  : T;
type RemoveIndexSignature<T> = { [P in keyof T as TypeLiteralOnly<P>]: T[P] };
```

## 참고

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Mapped Types](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
- [Key remapping via as](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html#key-remapping-via-as)
