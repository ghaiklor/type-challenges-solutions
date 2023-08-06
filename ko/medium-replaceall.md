---
id: 119
title: ReplaceAll
lang: ko
level: medium
tags: template-literal
---

## 챌린지

주어지는 입력 문자열 `S`에서 문자열 `From`을 `To`로 대체하는
`ReplaceAll<S, From, To>`를 구현해보세요.

예시:

```ts
type replaced = ReplaceAll<"t y p e s", " ", "">; // expected to be 'types'
```

## 해답

이 풀이는 [`Replace`] 타입의 풀이에 기반하여 설명하겠습니다.

문자열 `S`를 세 부분으로 쪼개야합니다. `From` 이전 부분과, `From`, `From` 이후부
분으로 나눌 수 있습니다. 조건부 타입과 추론을 이용하면 구할 수 있습니다.

문자열이 추론되면, 각 부분과 `To`를 이용하여 새로운 템플릿 리터럴 타입을 반환할
수 있습니다:

```ts
type ReplaceAll<
  S extends string,
  From extends string,
  To extends string,
> = From extends ""
  ? S
  : S extends `${infer L}${From}${infer R}`
  ? `${L}${To}${R}`
  : S;
```

이 풀이는 일치하는 한 부분을 대체하지만 챌린지에서는 일치하는 모든 부분을 대체해
야 합니다. 타입에 대체된 새로운 문자열을 다시 넣어 (재귀적인 방법으로) 이를 쉽게
해결할 수 있습니다:

```ts
type ReplaceAll<
  S extends string,
  From extends string,
  To extends string,
> = From extends ""
  ? S
  : S extends `${infer L}${From}${infer R}`
  ? ReplaceAll<`${L}${To}${R}`, From, To>
  : S;
```

하지만 재귀적으로 호출할 때마다, 문자열이 예상하지 못하는 방식으로 변경될 수 있
습니다. 예시로, `ReplaceAll<"fooo", "fo", "f">`을 호출하면 `foo -> fo -> f`와 같
이 변경됩니다. 따라서 변경되기 전의 문자열을 알아야합니다:

```typescript
type ReplaceAll<
  S extends string,
  From extends string,
  To extends string,
  Before extends string = "",
> = From extends ""
  ? S
  : S extends `${Before}${infer L}${From}${infer R}`
  ? ReplaceAll<`${Before}${L}${To}${R}`, From, To, `${Before}${L}${To}`>
  : S;
```

## 참고

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Type inference in conditional types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Recursive Conditional Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
- [Template Literal Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types)
