---
id: 191
title: Append Argument
lang: ko
level: medium
tags: arguments
---

## 챌린지

주어지는 함수 타입 `Fn`이 있고 any 타입 `A`(이 경우 any의 의미는 타입이 정해지지
않았고, 실제로 어떤 타입이든 상관없다는 의미입니다.)가 있습니다. 이 때 `Fn`을 첫
번째 매개변수로 받고, `A`를 두번째로 받아서 `Fn`의 마지막 매개변수로 `A`가 추가
된 형태의 함수 타입 `G`를 만드는 제네릭 타입을 만들어 보세요.

예시:

```ts
type Fn = (a: number, b: string) => number;

// expected be (a: number, b: string, x: boolean) => number
type Result = AppendArgument<Fn, boolean>;
```

## 해답

흥미로운 챌린지입니다. 타입 추론, 가변 인자 튜플 타입(variadic tuple), 조건부 타
입 등 흥미로운 요소들을 다뤄볼 수 있습니다.

먼저 함수의 매개변수와 반환 타입을 추론하는 것부터 시작하겠습니다. 이 경우 조건
부 타입이 유용하게 쓰입니다. 타입을 추론하고 나면, 지금 단계에서는 입력으로 주어
진 것을 복사한 형태의 함수 시그니처를 반환해 줍니다:

```ts
type AppendArgument<Fn, A> = Fn extends (args: infer P) => infer R
  ? (args: P) => R
  : never;
```

아직 해답은 전혀 충분하지 않습니다. `Fn`에 할당 가능한 함수는 매개변수로 `args`
하나만을 가지는 함수이기 때문입니다. 이건 의도와 맞지 않습니다. 매개변수가 없거
나 하나 이상인 경우도 고려될 수 있어야 합니다.

이 문제를 해결하기 위해 스프레드 연산자(spread operator)를 사용할 수 있습니다:

```ts
type AppendArgument<Fn, A> = Fn extends (...args: infer P) => infer R
  ? (args: P) => R
  : never;
```

이제 조건부 타입의 조건이 참으로 평가됩니다. 이 경우 참인 경우의 분기를 타기 때
문에 타입 매개변수 `P`(함수의 매개변수)와 타입 매개변수 `R`(반환 타입)을 사용할
수 있습니다. 여전히 남아있는 문제가 있긴 합니다. 타입 매개변수 `P`는 튜플의 형태
이지만 이 매개변수들을 각각 분리해서 다뤄주어야 할 필요가 있습니다.

가변 인자 튜플 타입(variadic tuple type)을 사용하여 튜플을 쪼갤 수 있습니다(역주
: 본 문단의 과정이 없어도 답을 구할 수 있습니다. 이후 과정에서 얻은 튜플을 변형
하여 사용하지 않을 것이기 때문입니다.):

```ts
type AppendArgument<Fn, A> = Fn extends (...args: [...infer P]) => infer R
  ? (args: P) => R
  : never;
```

타입 매개변수 `P`는 이제 우리가 원하는 형태입니다. 남은 것은 추론된 타입을 통해
새로운 함수 시그니처를 만드는 작업입니다:

```ts
type AppendArgument<Fn, A> = Fn extends (...args: [...infer P]) => infer R
  ? (...args: [...P]) => R
  : never;
```

이제 입력으로 주어진 함수를 받아서 타입을 추론한 뒤 새로운 함수를 반환해주는 타
입을 만들었습니다. 이 작업이 끝난 뒤 매개변수 `A`를 매개변수들의 배열에 넣어주기
만 하면 됩니다:

```ts
type AppendArgument<Fn, A> = Fn extends (...args: [...infer P]) => infer R
  ? (...args: [...P, A]) => R
  : never;
```

## 참고

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Type inference in conditional types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Variadic Tuple Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
- [Rest parameters in function type](https://www.typescriptlang.org/docs/handbook/2/functions.html#rest-parameters-and-arguments)
