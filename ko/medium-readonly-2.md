---
id: 8
title: Readonly 2
lang: ko
level: medium
tags: readonly object-keys
---

## 챌린지

두 인자 `T`와 `K`를 받는 제네릭 `MyReadonly2<T, K>`를 구현해보세요.

`K`는 `T`의 프로퍼티들 중 `readonly`로 변경되어야 하는 목록을 나타냅니다. `K`가
주어지지 않았다면, 기존의 `Readonly<T>` 제네릭처럼 모든 프로퍼티들을
`readonly`로 만들어야 합니다.

예시:

```ts
interface Todo {
  title: string;
  description: string;
  completed: boolean;
}

const todo: MyReadonly2<Todo, "title" | "description"> = {
  title: "Hey",
  description: "foobar",
  completed: false,
};

todo.title = "Hello"; // Error: cannot reassign a readonly property
todo.description = "barFoo"; // Error: cannot reassign a readonly property
todo.completed = true; // OK
```

## 해답

이 챌린지는 이전의 [`Readonly<T>`](./easy-readonly.md) 챌린지와 이어집니다. 이전
과 거의 유사하지만 새 타입 파라미터인 `K`가 추가되어 read-only로 변경할 프로퍼티
들을 지정한다는 점에서 차이가 있습니다.

`K`가 주어지지 않아 read-only로 변경할 것이 없는 경우부터 만들어보겠습니다.
`T`를 반환합니다:

```ts
type MyReadonly2<T, K> = T;
```

이제 `K`를 통해 프로퍼티가 주어지는 경우를 처리합니다. `&` 연산자를 사용하여
[교차 타입](https://www.typescriptlang.org/docs/handbook/2/objects.html#intersection-types)을
만듭니다: 첫번째는 기존의 `T`이고 두번째는 read-only가 적용된 프로퍼티 타입입니
다.

```ts
type MyReadonly2<T, K> = T & { readonly [P in K]: T[P] };
```

풀이가 끝난 것처럼 보이지만, “Type ‘P’ cannot be used to index type ‘T’”라는 컴
파일 에러를 얻습니다. `K`에 제약을 걸어주지 않았기 때문입니다. `T`의 키가 되어야
합니다:

```ts
type MyReadonly2<T, K extends keyof T> = T & { readonly [P in K]: T[P] };
```

이제 동작하나요? 아직 아닙니다! `K`가 주어지지 않은 경우를 처리해주지 않았습니다
. 이 경우에 기존의 `Readonly<T>` 타입처럼 동작해야 합니다. `K`의 기본 타입 매개
변수를 T의 모든 키로 설정해주어 해결할 수 있습니다:

```ts
type MyReadonly2<T, K extends keyof T = keyof T> = T & {
  readonly [P in K]: T[P];
};
```

## 참고

- [Intersection types](https://www.typescriptlang.org/docs/handbook/2/objects.html#intersection-types)
- [Mapped Types](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
- [Index Types](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)
- [Using type parameters in generic constraints](https://www.typescriptlang.org/docs/handbook/2/generics.html#using-type-parameters-in-generic-constraints)
