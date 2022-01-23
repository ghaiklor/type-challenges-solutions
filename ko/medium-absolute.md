---
id: 529
title: Absolute
lang: ko
level: medium
tags: math template-literal
---

## 챌린지

`Absolute` 타입을 구현해보세요.
타입은 `string`, `number` 그리고 `bigint` 타입 중 하나입니다.
양수인 문자열을 반환해야 합니다.

예시:

```typescript
type Test = -100;
type Result = Absolute<Test>; // expected to be "100"
```

## 해답

수의 절댓값을 구하는 가장 쉬운 방법은 수를 문자열로 변환하고 "-" 부호를 제거해주는 것입니다.
농담같지만 그렇지 않습니다.
"-" 부호를 제거해봅시다.

우선 주어진 수를 template literal type으로 만든 형태에 "-" 부호가 포함되어 있는지 확인합니다. 포함된다면 "-" 부호가 제거된 부분을 타입 추론합니다. 포함되지 않는다면 타입을 그대로 반환합니다:

```typescript
type Absolute<T extends number | string | bigint> = T extends `-${infer N}`
  ? N
  : T;
```

예를 들어 `T = “-50”`인 타입이 있으면, `“-<N>”`인 타입과 일치할 것이고 여기서 `N`은 50이 됩니다.
이게 기본적인 동작입니다.

하지만 여전히 몇 개의 테스트들이 실패하는 것을 볼 수 있습니다.
반환되는 타입이 항상 문자열이 아니기 때문입니다.
양수가 주어졌을 때, 숫자형은 template literal type과 일치하지 않기 때문에 string type을 반환하지 않고 number type을 반환할 것입니다.

`T`를 template literal type으로 만들어주어 이 문제를 해결해 봅시다:

```typescript
type Absolute<T extends number | string | bigint> = T extends `-${infer N}`
  ? N
  : `${T}`;
```

여전히 실패하는 테스트들이 있습니다.
아직 `T`가 음수인 경우를 처리해주지 않았기 때문입니다.
숫자형은 template literal type을 검사하는 조건에 걸리지 못하기 때문에 음수가 문자열인 형태로 반환될 것입니다.
이를 해결하기 위해 숫자를 문자열로 변환할 필요가 있습니다:

```typescript
type Absolute<T extends number | string | bigint> = `${T}` extends `-${infer N}`
  ? N
  : `${T}`;
```

결과적으로 `number`, `string`, `bigint` 타입을 받아서 문자열로 변환해주는 타입을 만들었습니다. 그 이후에 "-" 부호가 있다면 수에서 부호가 제거된 형태를 추론하여 반환하거나 "-" 부호가 없다면 문자열을 그대로 반환해주면 됩니다.

## 참고

- [Template Literal Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Type inference in conditional types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
