---
id: 1130
title: ReplaceKeys
lang: ko
level: medium
tags: object-keys
---

## Challenge

유니온 타입으로 주어지는 키를 교체하는 타입 `ReplaceKeys`를 구현해보세요.
타입에 주어진 키가 없다면 교체하지 않아도 됩니다.
타입은 세 개의 인자를 받습니다.

예시:

```typescript
type NodeA = {
  type: "A";
  name: string;
  flag: number;
};

type NodeB = {
  type: "B";
  id: number;
  flag: number;
};

type NodeC = {
  type: "C";
  name: string;
  flag: number;
};

type Nodes = NodeA | NodeB | NodeC;

// would replace name from string to number, replace flag from number to string
type ReplacedNodes = ReplaceKeys<
  Nodes,
  "name" | "flag",
  { name: number; flag: string }
>;

// would replace name to never
type ReplacedNotExistKeys = ReplaceKeys<Nodes, "name", { aa: number }>;
```

## 해답

인터페이스의 유니온이 주어지고 그것들을 순회하면서 키를 교체해야 합니다.
매핑 타입이나 타입의 분배가 이번 풀이에 도움이 될 것입니다.

타입스크립트의 매핑 타입 또한 분배적이라는 것부터 시작하겠습니다.
매핑타입을 통해 인터페이스의 키들을 순회할 수 있는 동시에 이것을 각 유니온에 적용하는 것이 가능합니다.
서두르지 않고 하나씩 설명해보겠습니다.

이미 유니온에 조건부 타입을 적용하면 유니온의 각 원소에 조건이 적용되는 것을 알고 있을 것입니다.
이런 동작은 이전 챌린지들을 해결할 때에도 큰 도움이 됐습니다.
`U extends any ? U[] : never`와 같이 쓸 때마다, 실제로 `U`는 각 원소를 순회하며 참으로 분기되는 유니온 `U`의 한 원소가 될 것입니다.

매핑 타입도 같게 적용됩니다.
타입 매개변수의 키들을 순회하는 매핑타입을 만들면 실제로 유니온의 각 원소를 순회할 수 있게 됩니다.

가장 간단한 형태부터 만들겠습니다.
(분배적인 특징을 이용하여) 유니온 `U`의 모든 원소를 가져와서 각 원소의 키들을 순회하며 복사본을 만듭니다.

```typescript
type ReplaceKeys<U, T, Y> = { [P in keyof U]: U[P] };
```

위 방식으로 타입 매개변수 `U`의 복사본을 얻을 수 있습니다.
이제 `T`나 `Y`에 속하는 키들을 골라내야 합니다.

먼저 프로퍼티가 업데이트 되어야 할 키들의 목록에 있는지 (타입 매개변수 `T`에 속하는지) 검사합니다.

```typescript
type ReplaceKeys<U, T, Y> = {
  [P in keyof U]: P extends T ? never : never;
};
```

속한다면 저희는 해당 키를 업데이트하여 새로운 타입으로 교체해야 합니다.
다만 교체할 새로운 키가 실존하는지 확신할 수 없습니다.
따라서 동일한 프로퍼티가 `Y`의 키에 존재하는지 검사해야 합니다.

```typescript
type ReplaceKeys<U, T, Y> = {
  [P in keyof U]: P extends T ? (P extends keyof Y ? never : never) : never;
};
```

모든 조건이 참이라면 교체할 키와 타입을 알게 된 것입니다.
따라서 `Y`에 명시된 타입을 반환하면 됩니다.

```typescript
type ReplaceKeys<U, T, Y> = {
  [P in keyof U]: P extends T ? (P extends keyof Y ? Y[P] : never) : never;
};
```

교체하려는 키가 타입 매개변수 `T`에는 있지만 타입 매개변수 `Y`에는 없다면 챌린지에 명시된 조건에 따라 `never`를 반환해야 합니다.
`T`와 `Y`에 모두 속하지 않는 키가 있을 수 있습니다.
그 경우에는 타입을 교체하지 않고 기존의 인터페이스에 있는 타입을 따릅니다.

```typescript
type ReplaceKeys<U, T, Y> = {
  [P in keyof U]: P extends T ? (P extends keyof Y ? Y[P] : never) : U[P];
};
```

매핑 타입을 적용하는 것으로 더 읽기 좋은 풀이를 만들 수 있었습니다.
매핑 타입이 없었다면 `U`를 순회하며 이어지는 분기 처리 내에서 조건부 타입을 다시 적용해야 했을 것입니다.

## 참고

- [Mapped Types](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Indexed Access Types](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)
