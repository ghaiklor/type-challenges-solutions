---
id: 7
title: Readonly
lang: ko
level: easy
tags: built-in readonly object-keys
---

## 챌린지

내장 타입인 `Readonly<T>` 제네릭을 직접 구현해보세요.

`T`의 모든 프로퍼티가 `readonly`로 설정된 타입을 만들어야 합니다.
이는 생성된 타입의 프로퍼티들이 재할당 될 수 없음을 의미합니다.

예시:

```ts
interface Todo {
  title: string;
  description: string;
}

const todo: MyReadonly<Todo> = {
  title: "Hey",
  description: "foobar",
};

todo.title = "Hello"; // Error: cannot reassign a readonly property
todo.description = "barFoo"; // Error: cannot reassign a readonly property
```

## 해답

객체의 모든 프로퍼티를 읽기 전용으로 만들어야 합니다.
따라서 모든 프로퍼티들을 순회하면서 각 프로퍼티에 접근 제어자를 추가해주어야 합니다.

흔히 사용되는 [Mapped Type](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)을 쓸 것입니다.
타입의 각 프로퍼티에서 키를 받아와 `readonly` 접근 제어자를 붙여줍니다:

```ts
type MyReadonly<T> = { readonly [K in keyof T]: T[K] };
```

## 참고

- [Mapped Types](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
