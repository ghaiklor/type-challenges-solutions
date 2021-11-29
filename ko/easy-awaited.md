---
id: 189
title: Awaited
lang: ko
level: easy
tags: promise
---

## 챌린지

만약 `Promise` 등을 통해 래핑된 타입이 있다면, 그 안에 있는 타입을 어떻게 얻을 수 있을까요?
예를 들어 `Promise<ExampleType>`과 같은 타입이 있다면 `ExampleType`을 어떻게 얻을 수 있을까요?

## 해답

Typescript의 잘 알려지지 않은 기능들 중 하나를 사용할 것을 요구하는 꽤 흥미로운 챌린지입니다.

그 기능이 무엇인지 설명하기 전에, 챌린지에 대해 분석해보겠습니다.
출제자는 타입을 언래핑하는 것에 대해 묻고 있습니다.
언래핑이란 무엇일까요?
언래핑은 하나의 타입 내부에 있는 타입을 얻어내는 것입니다.

예시와 함께 설명해보겠습니다.
`Promise<string>`과 같은 타입이 있을 때, `Promise` 타입을 언래핑하여 `string` 타입을 얻을 수 있습니다.
우리는 감싸고 있는 타입의 내부에 있는 타입을 얻어왔습니다.

타입을 재귀적으로 언래핑할 필요가 있다는 것도 기억해두세요.
예를 들어, 만약 `Promise<Promise<string>>`과 같은 타입이 있다면, `string` 타입을 반환해주어야 합니다.

이제 챌린지로 돌아와보겠습니다.
가장 쉬운 예시부터 시작해보겠습니다.
만약 우리의 `Awaited` 타입이 `Promise<string>`을 받는다면, 우리는 `string` 타입을 반환해주어야 합니다. Promise가 아니라면 `T` 타입을 반환합니다.

```ts
type Awaited<T> = T extends Promise<string> ? string : T;
```

하지만 한가지 문제가 남았습니다.
이렇게 사용할 경우, 우리는 원래의 목적과 다르게 `Promise` 내부에 문자열이 있는 경우만을 다룰 수 있습니다.
이럴 경우 어떻게 해야할까요?
`Promise` 내부에 어떤 타입이 있는지 모를 때 그 타입을 어떻게 얻어올 수 있을까요?

이런 경우를 위해, Typescript는 조건부 타입에 대한 타입 추론을 제공합니다!
우리는 컴파일러에게 이렇게 부탁할 수 있습니다.
"그 타입이 무엇인지 안다면, 우리의 타입 매개변수에 할당해 줄 수 있을까요."
조건부 타입의 타입추론에 대해서는 [여기서 더 읽어보실 수 있습니다](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-8.html#type-inference-in-conditional-types).

타입 추론에 대해서 알았다면, 우리의 해답을 더 다듬어 볼 수 있습니다.
조건부 타입에서 `Promise<string>`에 대해 확인하는 대신, `string`을 `infer R`로 대체합니다. 왜냐하면 우리는 Promise 안에 무엇이 있는지 알 수 없기 때문입니다.
우리가 유일하게 알고있는 것은 `Promise<T>`의 내부에 어떤 타입이 존재한다는 사실뿐입니다.

Typescript가 `Promise` 안에 어떤 타입이 있는지 알아낸다면, 우리의 타입 매개변수 `R`에 할당해줄 것이고, 이 타입은 "true" 분기 내에서 사용할 수 있습니다.
우리는 이 타입을 반환해주면 됩니다.

```ts
type Awaited<T> = T extends Promise<infer R> ? R : T;
```

이제 거의 다 왔습니다.
`Promise<Promise<string>>`이 있을 경우 `Promise<string>` 타입을 반환해주는 것만 해결해보겠습니다.
이를 위해서는 `Awaited` 타입을 이용해 타입을 얻는 절차를 재귀적으로 반복해주면 됩니다.

```ts
type Awaited<T> = T extends Promise<infer R> ? Awaited<R> : T;
```

## 참고

- [조건부 타입](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [조건부 타입 내에서의 타입 추론](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)