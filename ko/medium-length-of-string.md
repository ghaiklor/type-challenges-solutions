---
id: 298
title: Length of String
lang: ko
level: medium
tags: template-literal
---

## 챌린지

`String#length`처럼 동작하도록 문자열의 길이를 계산해보세요.

예시:

```typescript
type length = LengthOfString<"Hello, World">; // expected to be 12
```

## 해답

처음 이 문제를 봤을 때 간단한 풀이를 시도해볼 수도 있습니다. 인덱스 타입을 통해
`length` 프로퍼티에 접근하는 방식입니다. 타입스크립트가 아직 값을 얻어낼만큼 똑
똑하지는 않습니다:

```typescript
type LengthOfString<S extends string> = S["length"];
```

아쉽지만 원하는 답이 아닙니다. 계산된 타입은 숫자 리터럴이 아닌 `number` 타입입
니다. 따라서 다른 풀이를 고민해야 합니다.

남은 문자가 없을 때까지 첫 문자와 나머지 문자열을 재귀적으로 추론해오는 방식은어
떨까요? 이 방식에서 재귀를 통해 카운터를 만들 수 있을 것입니다. 먼저 첫 문자와그
나머지를 추론하는 타입부터 작성하겠습니다:

```typescript
type LengthOfString<S extends string> = S extends `${infer C}${infer T}`
  ? never
  : never;
```

타입 매개변수 `C`는 첫 문자이고 `T`는 문자열의 나머지입니다. 나머지에 대해 타입
을 재귀적으로 호출하면 추론할 문자열이 남지 않는 경우까지 진행될 것입니다:

```typescript
type LengthOfString<S extends string> = S extends `${infer C}${infer T}`
  ? LengthOfString<T>
  : never;
```

아직 카운터를 어디에 저장할 지 결정하지 못했습니다. 카운트를 올리는 타입 매개변
수를 추가하는 방법이 있겠지만 타입스크립트는 타입 시스템 내에서 수를 조작하는 옵
션을 제공하지 않습니다. 타입 매개변수를 추가하여 값을 증가시킬 수 있었다면 좋았
을 것입니다.

위 방법 대신 문자로 구성된 튜플을 타입 매개변수로 만들고 각 재귀 호출에서 추론된
첫 문자를 튜플에 채우는 방법이 있습니다:

```typescript
type LengthOfString<
  S extends string,
  A extends string[],
> = S extends `${infer C}${infer T}` ? LengthOfString<T, [C, ...A]> : never;
```

문자열 리터럴을 문자들로 쪼개진 튜플로 변환하고 새로운 타입 매개변수에 저장했습
니다. 문자가 남지 않은 케이스(재귀의 종료 조건)에 도착하면 튜플의 길이를 반환합
니다:

```typescript
type LengthOfString<
  S extends string,
  A extends string[],
> = S extends `${infer C}${infer T}`
  ? LengthOfString<T, [C, ...A]>
  : A["length"];
```

새로운 타입 매개변수를 도입하면 테스트를 통과할 수 없습니다. 지금의 타입은 한 개
가 아닌 두 개의 타입 매개변수를 요구하기 때문입니다. 타입 매개변수가 빈 튜플을기
본값으로 가지도록 수정합니다:

```typescript
type LengthOfString<
  S extends string,
  A extends string[] = [],
> = S extends `${infer C}${infer T}`
  ? LengthOfString<T, [C, ...A]>
  : A["length"];
```

## 참고

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Type inference in conditional types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Recursive Conditional Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
- [Template Literal Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types)
- [Variadic Tuple Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
- [Index Types](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)
