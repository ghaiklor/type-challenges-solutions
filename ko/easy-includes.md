---
id: 898
title: Includes
lang: ko
level: easy
tags: array
---

## 챌린지

Javascript의 `Array.includes` 함수를 타입 시스템 내에서 구현해보세요.
타입은 두개의 인자를 받습니다.
반환되는 값은 `true` 또는 `false`이어야 합니다.

예시:

```typescript
// expected to be `false`
type isPillarMen = Includes<["Kars", "Esidisi", "Wamuu", "Santana"], "Dio">;
```

## 해답

타입에 튜플 `T`와 확인하고자 하는 `U`를 인자로 넣습니다.

```typescript
type Includes<T, U> = never;
```

실제로 튜플에서 어떤 것을 찾기 전에, 튜플을 유니온으로 "변환"해주는 것이 더 쉬울 수 있습니다.
그러기 위해 인덱스 타입을 사용할 수 있습니다.
`T[number]`와 같이 접근할 경우, Typescript는 `T`에 있는 모든 원소들의 유니온을 반환해줍니다.
예시로 `T = [1, 2, 3]`이 있을 경우, `T[number]`로 접근하면 `1 | 2 | 3`이 반환됩니다.

```typescript
type Includes<T, U> = T[number];
```

이렇게만 쓸 경우 “Type ‘number’ cannot be used to index type ‘T’”와 같은 에러를 만나게 됩니다.
`T`에 어떠한 제약도 걸려있지 않기 때문입니다.
`T`가 배열이라는 것을 Typescript에게 알려주어야 합니다.

```typescript
type Includes<T extends unknown[], U> = T[number];
```

이제 원소들의 유니온을 갖게 되었습니다.
찾고자 하는 원소가 유니온에 존재하는지 어떻게 확인할 수 있을까요?
분산 조건부 타입을 이용할 수 있습니다!
유니온에 조건부 타입을 사용하면 Typescript는 알아서 유니온의 각 원소에 조건을 적용해 줄 것입니다.

예시로 `2 extends 1 | 2`처럼 작성하면, 사실 Typescript는 `2 extends 1`과 `2 extends 2`와 같이 두개의 조건으로 대체합니다.

위와 같은 방법으로 `T[number]` 안에 `U`가 있는지 검사하고 존재한다면 참을 반환하도록 만들 수 있습니다.

```typescript
type Includes<T extends unknown[], U> = U extends T[number] ? true : false;
```

## 참고

- [Generics](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Generic Constraints](https://www.typescriptlang.org/docs/handbook/2/generics.html#generic-constraints)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Distributive Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#distributive-conditional-types)
- [Index Types](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)
