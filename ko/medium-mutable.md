---
id: 2793
title: Mutable
lang: ko
level: medium
tags: readonly object-keys
---

## 챌린지

`T`에 속한 모든 프로퍼티가 변경 가능한 상태로 만드는 제네릭 `Mutable<T>`를 구현해보세요.

예시:

```typescript
interface Todo {
  readonly title: string;
  readonly description: string;
  readonly completed: boolean;
}

// { title: string; description: string; completed: boolean; }
type MutableTodo = Mutable<T>;
```

## 해답

(제 의견으로는) 보통 난이도에 있으면 안될 것 같은 챌린지입니다.
큰 고민없이 문제를 풀 수 있습니다.
다만 모든 문제를 푸는 것이 목표이기 때문에 난이도의 적절함에 대한 고민은 더 하지 않겠습니다.

오브젝트의 프로퍼티에 읽기전용 제어자를 붙일 수 있다는 것은 이미 알고 있습니다.
[Readonly challenge](./easy-readonly.md)를 해결하기 위해 제어자를 사용한 적 있었습니다.
이번 경우에는 타입에서 제어자를 제거하는 것을 요구하고 있습니다.

가장 단순한 것부터 시작하겠습니다. 매핑 타입을 사용해 주어지는 타입을 복사합니다:

```typescript
type Mutable<T> = { [P in keyof T]: T[P] };
```

이제 읽기전용 제어자가 붙은 `T`의 복사본이 있습니다.
제어자를 어떻게 제거할 수 있을까요?
지난 챌린지에서 매핑 타입에 `readonly` 키워드를 추가했던 것을 떠올려 봅시다:

```typescript
type Mutable<T> = { readonly [P in keyof T]: T[P] };
```

암시적으로 타입스크립트는 `readonly` 키워드에 `+`를 더해주고 이것은 프로퍼티에 제어자를 더해주고 싶다는 의미입니다.
이번 경우에는 제어자를 제거하고 싶기 때문에 `-`를 대신 사용할 수 있습니다:

```typescript
type Mutable<T> = { -readonly [P in keyof T]: T[P] };
```

이 방식으로 읽기전용 제어자를 프로퍼티에서 제거하는 타입을 구현할 수 있습니다.

## 참고

- [Mapped Types](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
- [Mapping Modifiers](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html#mapping-modifiers)
