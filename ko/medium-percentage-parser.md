---
id: 1978
title: Percentage Parser
lang: ko
level: medium
tags: parser
---

## 챌린지

`PercentageParser<T extends string>`를 구현해보세요. 정규표현식
`/^(\+|\-)?(\d*)?(\%)?$/`를 `T`와 비교하여 일치하는 세 부분을 얻어야 합니다.

`[plus or minus, number, unit]`으로 이루어진 튜플을 반환해야 합니다. 일치하는 부
분이 없다면, 기본값으로 빈 문자열을 넣습니다.

예시:

```typescript
type PString1 = "";
type PString2 = "+85%";
type PString3 = "-85%";
type PString4 = "85%";
type PString5 = "85";

type R1 = PercentageParser<PString1>; // expected ['', '', '']
type R2 = PercentageParser<PString2>; // expected ["+", "85", "%"]
type R3 = PercentageParser<PString3>; // expected ["-", "85", "%"]
type R4 = PercentageParser<PString4>; // expected ["", "85", "%"]
type R5 = PercentageParser<PString5>; // expected ["", "85", ""]
```

## 해답

(개인적으로) 파싱이 필요한 작업은 꽤 흥미롭습니다. 다만 타입 시스템만 활용할 수
있기 때문에 다양한 작업이 가능하지는 않습니다. 따라서 정석으로 여겨지는 최고의풀
이를 만들기는 힘들지만 수준 있게 만들어보겠습니다.

주어지는 문자열을 세 부분으로 나누어야 합니다: 기호, 숫자, 퍼센트 기호입니다. 풀
이를 쉽게 만들기 위해 하나의 작업을 세 개의 타입으로 분리하겠습니다. 첫번째 타입
은 문자열에서 기호를 얻는 타입입니다. 두번째 타입은 숫자를 반환하고 세번째 타입
은 퍼센트 기호를 반환합니다.

기호부터 시작하겠습니다. 문자열의 기호가 플러스인지 마이너스인지 확인해야 합니다
. 이를 위해 첫번째 문자를 추론해야 합니다:

```typescript
type ParseSign<T extends string> = T extends `${infer S}${any}` ? never : never;
```

타입 매개변수의 첫 문자로 `S`를 가져와서 문자가 플러스나 마이너스인지 확인할 수
있습니다. 기호가 맞다면 추론해서 얻은 `S`를 그대로 반환합니다. 다른 경우엔 플러
스나 마이너스 기호가 아니기 때문에 빈 문자열을 반환합니다:

```typescript
type ParseSign<T extends string> = T extends `${infer S}${any}`
  ? S extends "+" | "-"
    ? S
    : ""
  : "";
```

위 방식으로 기호가 문자열에 있다면 기호를 반환하는 타입을 만들었습니다. 이제 같
은 방식으로 퍼센트 기호도 얻을 수 있습니다.

문자열의 마지막에 퍼센트 기호가 있는지 검사합니다:

```typescript
type ParsePercent<T extends string> = T extends `${any}%` ? never : never;
```

퍼센트 기호가 있다면 그대로 반환하고 아닌 경우엔 빈 문자열을 반환합니다. 간단합
니다.

```typescript
type ParsePercent<T extends string> = T extends `${any}%` ? "%" : "";
```

기호를 얻을 수 있는 두 가지 타입을 이용해 숫자를 얻어오는 방식도 생각해 볼 수 있
습니다. 문자열의 기호들 사이에 있는 부분을 추론하는 것입니다. 한 가지 문제는 기
호들이 항상 있는 것은 아니라는 점입니다.

기호가 존재하는지 확인하는 타입을 구현하기 위해 이전에 문자를 검사했던 논리를 그
대로 가져와서 사용할 수 있습니다. 어떻게 해야할까요? 기호를 제거하지 않는다면 문
자열에 숫자와 함께 남아있을 것입니다. 하지만 기호는 필요하지 않습니다기호가 존재
한다면 문자열에서 제거해야 합니다.

운좋게도 이전에 만든 파싱 타입에서 그 작업을 했습니다. 남은건 이 타입들을 활용하
여 숫자를 추론하는 것입니다:

```typescript
type ParseNumber<T extends string> =
  T extends `${ParseSign<T>}${infer N}${ParsePercent<T>}` ? never : never;
```

어떤 결과가 나오는지 보이시나요? 먼저 기호가 있다면 기호 문자를 가져와서 템플릿
리터럴 타입으로 넣습니다. 따라서 추론되는 부분에는 기호가 빠져있을 것입니다. 퍼
센트 기호에도 똑같이 적용합니다. 퍼센트 기호가 있다면 템플릿 리터럴 타입으로 넣
어 추론되는 부분에서 제외합니다.

이제 `infer` 키워드를 통해 추론된 결과에는 숫자만 남습니다. 반환해봅시다:

```typescript
type ParseNumber<T extends string> =
  T extends `${ParseSign<T>}${infer N}${ParsePercent<T>}` ? N : "";
```

이제 위의 방식들을 어떻게 조합해야 할지 이미 파악하셨을거라 생각합니다. 챌린지의
설명에 언급된 것처럼, 세 개의 원소로 구성된 튜플을 반환해야 합니다. 만들어 둔 타
입으로 튜플을 채워봅시다:

```typescript
type PercentageParser<A extends string> = [
  ParseSign<A>,
  ParseNumber<A>,
  ParsePercent<A>
];
```

축하합니다! 타입 시스템 내에서 구현한 간단한 파서를 만들었습니다.

## 참고

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Inferring within Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Template Literal Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types)
