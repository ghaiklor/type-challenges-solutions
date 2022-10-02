---
id: 11
title: Tuple to Object
lang: ko
level: easy
tags: tuple
---

## 챌린지

배열이 주어질 때, 배열에 있는 원소들을 키/값으로 가지는 객체로 변환해보세요.

예시:

```ts
const tuple = ["tesla", "model 3", "model X", "model Y"] as const;

// expected { tesla: 'tesla', 'model 3': 'model 3', 'model X': 'model X', 'model Y': 'model Y'}
const result: TupleToObject<typeof tuple>;
```

## 해답

배열에 있는 모든 값들을 얻어 새 객체의 키와 값으로 만들어야합니다.

이 경우 인덱스 타입을 이용하면 쉽습니다. 배열에 있는 값들은 `T[number]`로 얻을수
있습니다. mapped type을 사용하면, `T[number]`로 얻은 값들을 순회하며 기존의원소
를 키와 값으로 하는 새로운 타입을 만들 수 있습니다:

```ts
type TupleToObject<T extends readonly (PropertyKey)[]> = { [K in T[number]]: K };
```

## 참고

- [Mapped Types](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
- [Indexed Types](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)
