---
id: 3
title: Omit
lang: ko
level: medium
tags: union built-in
---

## 챌린지

내장 타입인 `Omit<T, K>` 제네릭을 직접 구현해보세요. `T`에 속한 모든 프로퍼티 중
에서 `K`에 해당하는 프로퍼티를 지우는 타입을 만들어야 합니다.

예시:

```ts
interface Todo {
  title: string;
  description: string;
  completed: boolean;
}

type TodoPreview = MyOmit<Todo, "description" | "title">;

const todo: TodoPreview = {
  completed: false,
};
```

## 해답

특정 키를 제외한 새 오브젝트 타입을 만들어 반환해야 합니다. 이는
[매핑 타입](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)을
사용해야 하는 힌트입니다. 오브젝트의 각 프로퍼티를 순회하면서 새로운 타입을 만들
어야 합니다.

가장 기본적인 방식으로 주어진 것과 같은 오브젝트를 만드는 것부터 시작합니다:

```ts
type MyOmit<T, K> = { [P in keyof T]: T[P] };
```

`T`의 모든 키를 순회하며 새 오브젝트 타입의 키인 `P`로 만들고 값이 되는 타입은
`T[P]`가 됩니다.

모든 키를 순회하는 과정에서 필요하지 않은 키에 대해서는 필터링을 하고 싶습니다.
이를 위해
["as" 문법을 사용한 키 리매핑](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#key-remapping-in-mapped-types)을
할 수 있습니다:

```ts
type MyOmit<T, K> = { [P in keyof T as P extends K ? never : P]: T[P] };
```

`T`의 모든 프로퍼티를 매핑하면서 프로퍼티가 `K` 유니온에 속할 경우 키의 타입이
`never`를 반환하게 했습니다. 위 방식으로 특정 프로퍼티를 필터링하고 필요한 오브
젝트 타입을 얻을 수 있습니다.

## 참고

- [Mapped Types](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
- [Index Types](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Key remapping in mapped types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#key-remapping-in-mapped-types)
