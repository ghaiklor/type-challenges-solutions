---
id: 2595
title: PickByType
lang: ko
level: medium
tags: object
---

## 챌린지

`T`에서 `U`에 할당 가능한 타입인 프로퍼티들을 골라내야 합니다.

예시:

```typescript
type OnlyBoolean = PickByType<
  {
    name: string;
    count: number;
    isReadonly: boolean;
    isEnable: boolean;
  },
  boolean
>; // { isReadonly: boolean; isEnable: boolean; }
```

## 해답

이번 챌린지에서는 객체를 순회하며 `U`에 할당 가능한 타입을 가진 필드들을 골라야 합니다.
이 경우 맵드 타입을 사용해야 하는 것이 확실합니다.

따라서 `T`의 모든 키들을 복사해서 새로 객체를 만드는 것부터 시작합니다:

```typescript
type PickByType<T, U> = { [P in keyof T]: T[P] };
```

먼저 `T`의 모든 키에 대해 순회할 것입니다.
각 순회에서 타입스크립트는 타입 `P`에 키를 할당합니다.
키를 가지고 룩업 타입인 `T[P]`를 사용하여 값의 타입을 얻을 수 있습니다.

이제 순회에 필터를 적용하면 `U`에 할당 가능한 키들만을 찾는 것이 가능합니다.
여기서 사용하는 "필터"는 키 리매핑을 사용하는 것입니다.
키 리매핑을 사용하여 키가 원하는 조건을 충족하는지 확인할 수 있습니다:

```typescript
type PickByType<T, U> = {
  [P in keyof T as T[P] extends U ? never : never]: T[P];
};
```

`as` 키워드는 키 리매핑을 시작할 것임을 보여줍니다.
키워드 이후에 조건부 타입을 통해 값의 타입을 검사할 수 있습니다.
값의 타입이 타입 `U`에 할당 가능할 경우에는 아무 변화 없이 키를 반환합니다.
`U`에 할당 가능하지 않다면 `never`를 반환합니다:

```typescript
type PickByType<T, U> = { [P in keyof T as T[P] extends U ? P : never]: T[P] };
```

위의 방법으로 값의 타입을 가지고 키를 필터링하는 타입을 만들었습니다.

## 참고

- [Mapped Types](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
- [Key remapping via as](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html#key-remapping-via-as)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [keyof and Lookup Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-1.html#keyof-and-lookup-types)
