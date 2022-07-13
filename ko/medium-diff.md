---
id: 645
title: Diff
lang: ko
level: medium
tags: object
---

## 챌린지

`O`와 `O1`이 공통으로 갖지 않는 프로퍼티로 `Object`를 만들어보세요.

예시:

```typescript
type Foo = {
  name: string;
  age: string;
};

type Bar = {
  name: string;
  age: string;
  gender: number;
};

type test0 = Diff<Foo, Bar>; // expected { gender: number }
```

## 해결

이 챌린지는 오브젝트를 조작하는 것을 필요로 합니다. 이런 경우에는 대부분 맵드 타
입을 통해 해결할 수 있습니다.

두 오브젝트의 프로퍼티가 유니온 된 타입을 순회하는 맵드 타입을 만들겠습니다. 공
통이 아닌 프로퍼티를 찾기 전에 두 오브젝트의 모든 프로퍼티를 모을 필요가 있습니
다.

```typescript
type Diff<O, O1> = { [P in keyof O | keyof O1]: never };
```

프로퍼티를 순회하면서 해당 프로퍼티가 `O`과 `O1` 중 어디에 속하는지 확인해야 합
니다. 조건부 타입을 사용하여 프로퍼티의 타입을 어떤 오브젝트에서 찾으면 될지 확
인합니다.

```typescript
type Diff<O, O1> = {
  [P in keyof O | keyof O1]: P extends keyof O
    ? O[P]
    : P extends keyof O1
    ? O1[P]
    : never;
};
```

거의 다 왔습니다! 두 오브젝트의 모든 프로퍼티를 가지는 오브젝트를 만들었습니다.
마지막으로 두 오브젝트에 공통으로 속한 프로퍼티를 제거하면 됩니다.

두 오브젝트에 공통으로 속한 프로퍼티를 어떻게 찾을 수 있을까요? 교차 타입을 사용
하면 됩니다! 교차 타입을 구하고 기존의 맵드 타입 `P`에서 해당 타입을 제외해주면
됩니다.

```typescript
type Diff<O, O1> = {
  [P in keyof O | keyof O1 as Exclude<P, keyof O & keyof O1>]: P extends keyof O
    ? O[P]
    : P extends keyof O1
    ? O1[P]
    : never;
};
```

## 참고

- [Mapped Types](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
- [Key remapping in Mapped Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#key-remapping-in-mapped-types)
- [Union Types](https://www.typescriptlang.org/docs/handbook/2/everyday-types.html#union-types)
- [Intersection Types](https://www.typescriptlang.org/docs/handbook/2/objects.html#intersection-types)
- [Index Types](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [keyof and Lookup Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-1.html#keyof-and-lookup-types)
