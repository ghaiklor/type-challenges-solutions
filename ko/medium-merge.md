---
id: 599
title: Merge
lang: ko
level: medium
tags: object
---

## 챌린지

두 타입을 하나의 새로운 타입으로 병합해보세요.
두번째 타입의 키는 첫번째 타입의 키를 덮어 씌웁니다.

예시:

```typescript
type Foo = {
  a: number;
  b: string;
};

type Bar = {
  b: number;
};

type merged = Merge<Foo, Bar>; // expected { a: number; b: number }
```

## 해답

이번 챌린지는 [“append to object”](./medium-append-to-object.md)와 유사합니다.
그 챌린지에서 객체와 문자열의 모든 프로퍼티를 가져오기 위해 유니온 연산자를 사용했습니다.

두 객체의 모든 프로퍼티들을 가져오기 위해 여기서도 같은 방법을 사용하겠습니다.
다음의 매핑 타입은 두 객체의 모든 프로퍼티를 가질 것입니다:

```typescript
type Merge<F, S> = { [P in keyof F | keyof S]: never };
```

두 객체의 프로퍼티들을 가짐으로써, 값도 얻을 수 있습니다.
더 높은 우선순위를 가지는 `S`부터 시작하여 `F`와 중복될 경우 덮어 씌우도록 합니다.
해당 프로퍼티가 `S`에 존재하는지도 확인해야 합니다:

```typescript
type Merge<F, S> = {
  [P in keyof F | keyof S]: P extends keyof S ? S[P] : never;
};
```

프로퍼티가 `S`에 속하지 않을 경우 `F`에 속하는 프로퍼티인지 확인한 후에 값을 반환합니다:

```typescript
type Merge<F, S> = {
  [P in keyof F | keyof S]: P extends keyof S
    ? S[P]
    : P extends keyof F
    ? F[P]
    : never;
};
```

위의 방식으로 `S`가 더 높은 우선순위를 가지면서 두 객체를 병합했습니다.

## 참고

- [Union Types](https://www.typescriptlang.org/docs/handbook/2/everyday-types.html#union-types)
- [keyof and Lookup Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-1.html#keyof-and-lookup-types)
- [Mapped Types](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
