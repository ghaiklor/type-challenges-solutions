---
id: 12
title: Chainable Options
lang: ko
level: medium
tags: application
---

## 챌린지

메서드 체이닝은 자바스크립트에서 흔하게 사용됩니다. 타입스크립트에서 체이닝을 적
절하게 타입으로 정의해 줄 수 있을까요?

이번 챌린지에서는 클래스나 객체 중 선호하는 방식을 통해 `option(key, value)`와
`get()` 메서드를 제공하는 타입을 만들어야 합니다. `option(key, value)` 함수는 주
어지는 키와 값을 이용해 config 타입을 확장합니다. 최종적인 결과는 `get()` 메서드
를 이용하여 접근할 것입니다.

예시:

```ts
declare const config: Chainable;

const result = config
  .option("foo", 123)
  .option("name", "type-challenges")
  .option("bar", { value: "Hello World" })
  .get();

// expect the type of result to be:
interface Result {
  foo: number;
  name: string;
  bar: {
    value: string;
  };
}
```

이 문제를 해결하기 위해 어떠한 JS/TS 로직도 작성할 필요가 없습니다. 타입 수준에
서만 해결하면 됩니다.

`key`는 `string`만을 받고 `value`는 어떤 타입이든 될 수 있다고 가정합니다. 같은
`key`는 두 번 이상 전달되지 않습니다.

## 해답

실용적인 쓰임새가 있는 흥미로운 챌린지입니다. 개인적으로 필자는 여러 빌더
(Builder) 패턴들을 구현할 때에 이와 같은 방법을 많이 사용했습니다.

출제자는 어떤 것을 요구하고 있나요? `option(key, value)`와 `get()` 메서드를 구현
하는 작업입니다. `option(key, value)` 메서드를 호출한 뒤에는 `key`와 `value`에대
한 타입 정보가 저장 되어야만 합니다. 위 작업은 `get()` 메서드 호출 이전까지 이어
집니다. `get()` 메서드는 호출 시에 저장된 타입 정보를 오브젝트 타입으로 반환합니
다.

출제자가 제공한 인터페이스에서부터 시작해 봅시다:

```ts
type Chainable = {
  option(key: string, value: any): any;
  get(): any;
};
```

타입 정보를 저장하는 것을 시작하기 전에, 미리 작업해 둘 것이 있습니다. `key`의
`string`과 `value`의 `any`를 타입 매개변수로 교체하여 타입스크립트가 매개변수들
의 타입을 추론하여 할당할 수 있게 합니다:

```ts
type Chainable = {
  option<K, V>(key: K, value: V): any;
  get(): any;
};
```

좋습니다! 이제 `key`와 `value`에 대한 타입 정보를 가지게 되었습니다. 타입스크립
트는 `key`를 문자열 리터럴 타입으로, `value`를 주어지는 타입으로 추론할 것입니다
. 예시로 `option('foo', 123)`을 호출하면 결과로 가지는 타입은 `key = 'foo'`와
`value = number`일 것입니다.

가진 정보를 어디에 저장해야 할까요? 메서드가 여러 번 호출되더라도 상태를 유지할
수 있는 곳이어야 합니다. 여기서 적합한 장소는 `Chainable` 타입 그 자신입니다!

새로운 타입 매개변수 `O`를 `Chainable` 타입에 추가합니다. 기본적으로 이 타입 매
개변수는 빈 객체입니다:

```ts
type Chainable<O = {}> = {
  option<K, V>(key: K, value: V): any;
  get(): any;
};
```

이제 가장 흥미로운 부분이니 집중해서 읽어주셔야 합니다! `option(key, value)`는 (
메서드 체이닝을 가능하게 하기 위해서) 호출한 주체인 `Chainable` 타입을 다시 반환
해야 하는데 타입 매개변수를 통해 전달되는 타입 정보들도 함께 저장되어야 합니다.
기존 정보에 새로운 타입을 추가하기 위해
[교차 타입](https://www.typescriptlang.org/docs/handbook/2/objects.html#intersection-types)을
사용합니다:

```ts
type Chainable<O = {}> = {
  option<K, V>(key: K, value: V): Chainable<O & { [P in K]: V }>;
  get(): any;
};
```

마지막으로 사소한 부분만 처리해주면 됩니다. 지금은 “Type ‘K’ is not assignable
to type ‘string | number | symbol’.“이라는 컴파일 에러가 발생합니다. 타입 매개변
수 `K`가 `string`이어야 한다는 제약을 걸어주지 않았기 때문입니다:

```ts
type Chainable<O = {}> = {
  option<K extends string, V>(key: K, value: V): Chainable<O & { [P in K]: V }>;
  get(): any;
};
```

모든 준비가 끝났습니다! 이제 `get()` 메서드를 호출하면 이전
`option(key, values)` 메서드 호출들을 통해 쌓인 타입 정보가 있는 타입 매개변수
`O`가 반환될 것입니다:

```ts
type Chainable<O = {}> = {
  option<K extends string, V>(key: K, value: V): Chainable<O & { [P in K]: V }>;
  get(): O;
};
```

## 참고

- [Intersection Types](https://www.typescriptlang.org/docs/handbook/2/objects.html#intersection-types)
- [Mapped Types](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
- [Generics](https://www.typescriptlang.org/docs/handbook/2/generics.html)
