---
id: 4
title: Pick
lang: ko
level: easy
tags: union built-in
---

## 챌린지

내장 유틸리티 타입인 `Pick<T, K>`를 직접 구현해보세요.

`T`에 있는 프로퍼티 중 `K`에 속하는 프로퍼티를 선택하는 타입을 만들어야 합니다.

예시:

```ts
interface Todo {
  title: string
  description: string
  completed: boolean
}

type TodoPreview = MyPick<Todo, 'title' | 'completed'>

const todo: TodoPreview = {
  title: 'Clean room',
  completed: false,
}
```

## 해답

이 문제를 풀기 위해, Lookup Type과 Mapped Type을 활용할 수 있습니다.

Lookup Type은 타입의 이름을 통해 어떤 타입의 프로퍼티에 접근할 수 있게 해줍니다.
이 동작은 객체에서 키를 이용하여 값을 얻어오는 과정과 비슷합니다.

Mapped Type은 타입의 각 프로퍼티들을 새로운 타입으로 변환해 줄 수 있습니다.

두 타입의 동작에 대해 이해하고 더 알아보고 싶다면 Typescript 웹사이트를 참고하시면 됩니다: [lookup types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-1.html#keyof-and-lookup-types) 과 [mapped types](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html).

Typescript에 lookup type과 mapped type이 있다는 것을 이해했습니다.
이 타입들을 통해 어떻게 주어진 챌린지를 해결할 수 있을까요?

유니온 `K`를 받아와 `K`의 각 원소를 순회하며 `K`로만 구성된 키를 가지도록 하는 새로운 타입을 만들어 반환해주어야 합니다.
Mapped type이 해줄 수 있는 동작입니다.

값의 타입 자체는 변하지 않습니다.
다만 값의 타입을 가져와서 사용할 것이고 이 부분은 lookup type을 유용하게 사용할 수 있습니다.

```ts
type MyPick<T, K extends keyof T> = { [P in K]: T[P] }
```

위의 과정은 `K`에 속한 모든 타입들을 `P`로 명명하고 새로운 객체의 키로 만듭니다. 이 객체의 값이 되는 타입은 주어지는 타입(이 경우 `T`)로부터 받아올 수 있습니다.
처음엔 이해하기 어려울 수 있습니다. 잘 와닿지 않는다면 참고자료를 읽어보고 단계별로 다시 진행해보세요.

## 참고

- [Lookup Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-1.html#keyof-and-lookup-types)
- [Mapped Types](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
- [Indexed Types](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)
