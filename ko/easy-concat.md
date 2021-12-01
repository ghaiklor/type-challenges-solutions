---
id: 533
title: Concat
lang: ko
level: easy
tags: array
---

## 챌린지

타입 시스템 내에서 자바스크립트의 `Array.cocat` 함수를 구현해보세요.
타입은 두개의 인자를 받습니다.
결과값은 입력값이 순서대로 포함된 새로운 배열이어야 합니다.

예시:

```ts
type Result = Concat<[1], [2]> // expected to be [1, 2]
```

## 해답

Typescript에서 배열을 다룰 때에, Variadic Tuple은 특정 상황들에서 요긴하게 사용될 수 있습니다.
Variadic Tuple은 제네릭이 전개문법을 사용할 수 있게 만들어줍니다.
지금부터 설명해보겠습니다.

먼저 자바스크립트에서 두 배열을 합칠 때에 어떻게 구현하는지부터 살펴보겠습니다:

```js
function concat(arr1, arr2) {
  return [...arr1, ...arr2];
}
```

스프레드 연산자를 사용하여 `arr1`에 있는 모든 원소들을 가져와 다른 배열에 전달할 수 있습니다.
`arr2`에도 마찬가지로 적용할 수 있습니다.
핵심 아이디어는 배열\튜플의 원소들을 순회하면서 가져오고 스프레드 연산자가 사용된 곳으로 전달해주는 것입니다.

Variadic Tuple 타입은 타입 시스템 내에서 위와 같은 동작이 가능하도록 지원해줍니다.
만약 두 제네릭 배열을 합치고 싶다면, 새로운 배열 안에서 두 제네릭 배열에 스프레드 연산자를 적용한 뒤 새로운 배열을 반환해주면 됩니다:

```ts
type Concat<T, U> = [...T, ...U]
```

이렇게만 사용할 경우 “A rest element type must be an array type.”라는 에러를 만나게 됩니다.
컴파일러에게 사용하는 제네릭들이 배열이라는 것을 알려주어 이 문제를 해결해보겠습니다:

```ts
type Concat<T extends unknown[], U extends unknown[]> = [...T, ...U]
```

## 참고

- [Variadic Tuple Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
