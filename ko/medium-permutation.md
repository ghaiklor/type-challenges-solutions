---
id: 296
title: Permutation
lang: ko
level: medium
tags: union
---

## 챌린지

주어지는 유니온 타입을 유니온 타입의 순열로 이루어진 배열로 변경하는 타입을 구현해보세요.

```typescript
type perm = Permutation<"A" | "B" | "C">;
// expected ['A', 'B', 'C'] | ['A', 'C', 'B'] | ['B', 'A', 'C'] | ['B', 'C', 'A'] | ['C', 'A', 'B'] | ['C', 'B', 'A']
```

## 해답

가장 좋아하는 챌린지 중 하나입니다.
처음 봤을 때엔 꽤 복잡해보이는 챌린지이지만 그렇지 않습니다.

풀이를 이해하기 위해서 ["분할정복"](https://en.wikipedia.org/wiki/Divide-and-conquer_algorithm)을 먼저 알아야 합니다.
필요한 작업에 대한 풀이를 찾을 수 없다면, 작업의 일부에 대한 풀이를 찾는 것을 시도해야 합니다.
모든 원소들의 순열을 찾는 것을 시도하는 대신 하나씩 시작해봅시다.

`T`에 `never`가 들어오는 경우엔 빈 배열을 반환합니다.
원소가 없다면 순열도 없기 때문에 빈 배열이어야 합니다.
그렇지 않고 `T`에 하나의 원소가 있다면 순열은 그 원소만으로 만들어 질 것입니다.
조건부 타입을 통해 이를 구현합니다:

```typescript
type Permutation<T> = T extends never ? [] : [T];
```

이 풀이로도 하나의 테스트를 통과할 수 있습니다. 하나의 원소로 이루어진 유니온이 올바른 순열을 이루는지 검사하는 테스트입니다.
여기까지는 계획한대로 정확합니다.

두 개 이상의 원소로 이루어지는 순열은 어떻게 찾을까요?
다시 "분할정복"입니다.
`Permutation<‘A’ | ‘B’>`를 찾고 싶은 경우 어떻게 해야할까요?
첫 원소인 `A`와 나머지 유니온으로 이루어진 순열을 찾습니다. 이 경우 `Permutation<‘B’>`입니다.
두 번째 원소인 `B`도 같게 진행합니다.
원소 `B`와 `Permutation<‘A’>`를 찾습니다.
이 단계는 이미 어떻게 해결해야 할지 알고 있습니다!

구체적으로 시각화 해보겠습니다:

```text
Permutation<‘A’ | ‘B’> -> [‘A’, ...Permutation<‘B’>] + [‘B’, ...Permutation<‘A’>] -> [‘A’, ‘B’] + [‘B’, ‘A’]
```

재귀적으로 얼마나 깊게 반복하는지 상관없이 언젠가는 재귀의 종료조건에서 멈출 것입니다.
종료조건은 하나의 원소에서 순열을 찾는 경우입니다.
이 경우에 대한 타입은 미리 정의해두었습니다.

이제 타입 시스템에서 이걸 어떻게 구현할 수 있을까요?
타입스크립트에서 조건부 타입은 유니온에 대해 분산됩니다.
따라서 `T`가 유니온일 때 `T extends Some<T>`로 사용하면 타입스크립트는 유니온의 각 원소에 대해 조건을 적용합니다.
이 방법을 통해 유니온을 순회하며 `T extends infer U ? U : never`에서 원소를 얻을 수 있습니다.
이 과정에서 재귀 호출에서 빠져야 할 원소들을 제외할 수 있습니다.

유니온의 원소들과 재귀에서 제외할 원소를 알 수 있다면 "분할정복"을 구현할 수 있습니다.
`[T]`를 구상한 알고리즘으로 변경 해보겠습니다:

```typescript
type Permutation<T> = T extends never
  ? []
  : T extends infer U
  ? [U, ...Permutation<Exclude<T, U>>]
  : [];
```

풀이에 거의 도착했습니다.
이론상 작동해야 하지만 아직 답이 나오지 않습니다.
무엇이 문제일까요?
순열 대신 `never`를 얻습니다.
여러 시도 끝에 `T`를 배열로 감싸야 하는 것을 알게 됐습니다:

```typescript
type Permutation<T> = [T] extends [never]
  ? []
  : T extends infer U
  ? [U, ...Permutation<Exclude<T, U>>]
  : [];
```

아직 직관과 다르게 동작하고 이해되지 않는 부분이 있습니다.
`T extends infer U`를 사용할 때 기대한대로 동작하지 않습니다.
놀랍게도 타입 매개변수 `T`를 다른 변수에 복사하여 사용할 경우에 이 이슈를 해결할 수 있었습니다:

```typescript
type Permutation<T, C = T> = [T] extends [never]
  ? []
  : C extends infer U
  ? [U, ...Permutation<Exclude<T, U>>]
  : [];
```

## 참고

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Type inference in conditional types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Recursive Conditional Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
- [Variadic Tuple Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
