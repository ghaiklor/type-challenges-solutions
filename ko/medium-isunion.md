---
id: 1097
title: IsUnion
lang: ko
level: medium
tags: union
---

## 챌린지

입력 타입 `T`를 받아서 `T`가 유니온 타입인지를 반환하는 제네릭 타입 `IsUnion`을
구현해보세요.

예시:

```typescript
type case1 = IsUnion<string>; // false
type case2 = IsUnion<string | number>; // true
type case3 = IsUnion<[string | number]>; // false
```

## 해답

이런 종류의 챌린지를 만날 때면 쉽게 해답을 떠올리기 어렵습니다. 해당 타입을 구현
할 때 사용할 수 있는 일반적인 풀이가 없기 때문입니다. 사용할 수 있는 내장 타입이
나 빌트인 타입도 존재하지 않습니다.

따라서 주어진 것을 활용할 수 있도록 창의적으로 접근해야 합니다. 유니온과 유니온
이 무엇을 표현하는지 생각해보는 것부터 시작하겠습니다.

`string`과 같은 기본 타입은 `string` 외의 다른 타입이 될 수 없습니다.
`string | number`와 같은 유니온 타입을 사용하면 `string` 또는 `number` 중 하나의
값을 얻는 걸 기대할 수 있습니다.

일반 타입은 가능한 값들의 집합을 표현할 수 없지만 유니온은 할 수 있습니다. 일반
타입이 분산된 형태는 가능하지 않지만 유니온에서는 가능합니다.

위의 중요한 차이점을 통해 주어진 타입이 유니온인지 확인할 수 있습니다. 유니온이
아닌 경우에 타입 `T`가 분산될 때에는 아무 변화도 일어나지 않습니다. 유니온의 경
우엔 많은 것이 변할 수 있습니다.

타입스크립트에는 분산 조건부 타입이라는 멋진 타입이 있습니다. `T`가 유니온인 경
우에 `T extends string ? true : false`와 같은 구조를 사용하면 조건이 분산되어 적
용됩니다. 이는 유니온의 각 원소에 조건부 타입이 적용되는 것처럼 볼 수 있습니다.

```typescript
type IsString<T> = T extends string ? true : false;

// For example, we provide type T = string | number
// It is the same as this
type IsStringDistributive = string extends string
  ? true
  : false | number extends string
  ? true
  : false;
```

이제 풀이가 어떤 방향으로 나아가고 있는지 보이시나요? 타입 `T`가 유니온일 경우,
분산 조건부 타입을 사용하여 유니온을 쪼갠 뒤 원래의 입력 타입 `T`와 비교할 수 있
습니다. 이 경우, 비교 결과가 같다면 유니온이 아닌 것입니다. 유니온일 경우 그 결
과는 같지 않을 것입니다. `string | number`은 `string`에 할당할 수 없고
`number`에도 할당할 수 없습니다.

이제 구체적인 구현을 해보겠습니다! 먼저 입력 타입 `T`의 복사본을 만들어 타입
`T`가 수정되지 않은 형태를 보존해둡니다. 이 타입을 나중에 비교하는 데에 사용할것
입니다.

```typescript
type IsUnion<T, C = T> = never;
```

조건부 타입을 적용하여 분산을 표현할 수 있습니다. 조건부 타입의 "true" 분기 내에
서 유니온의 각 원소를 얻을 수 있습니다.

```typescript
type IsUnion<T, C = T> = T extends C ? never : never;
```

이제 가장 중요한 부분입니다. 각 원소를 원래 입력 타입인 `T`와 비교합니다. 이 경
우 두 타입이 동일하다면 분산이 이루어지지 않은 것이므로 유니온이 아닙니다.
`false`를 반환해줍니다. 반대의 경우 분산이 적용된 것이고 유니온의 각 원소는 유니
온과 비교됩니다. 그 경우 유니온인 것이므로 `true`를 반환합니다.

```typescript
type IsUnion<T, C = T> = T extends C ? ([C] extends [T] ? false : true) : never;
```

끝입니다! 명확히 하기 위해 조건부 분산 타입의 "true" 분기에서 `[C]`와 `[T]`가 어
떻게 동작하는지 예시를 남기겠습니다.

`string`과 같은 유니온이 아닌 타입에서 두 타입은 같습니다. 그 결과로 `false`를반
환합니다.

```typescript
[T] = [string][C] = [string];
```

`string | number`와 같은 유니온을 전달할 경우 두 타입은 달라집니다. 복사본인
`C`는 튜플 내부에 유니온을 가지고 있고 `T`는 튜플 내부에 일반 타입을 가지고 있습
니다. 따라서 유니온임을 알 수 있습니다.

```typescript
[T] = [string] | [number]
[C] = [string | number]
```

## 참고

- [Union Types](https://www.typescriptlang.org/docs/handbook/2/everyday-types.html#union-types)
- [Generics](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Distributive Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#distributive-conditional-types)
- [Tuple Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-1-3.html#tuple-types)
