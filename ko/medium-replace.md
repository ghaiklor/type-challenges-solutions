---
id: 116
title: Replace
lang: ko
level: medium
tags: template-literal
---

## 챌린지

주어진 문자열 `S` 안에서 문자열 `From`을 `To`로 대체하는
`Replace<S, From, To>`를 구현해보세요.

예시:

```ts
type replaced = Replace<"types are fun!", "fun", "awesome">; // expected to be 'types are awesome!'
```

## 해답

입력 문자열 `S`에서 `From`과 일치하는 부분을 찾아 `To`로 교체해야 합니다. 문자열
을 세 부분으로 쪼개어 각 부분을 추론해보겠습니다.

`From`과 일치하는 문자열 전까지와, `From` 문자열, 그리고 남은 부분을 추론합니다:

```ts
type Replace<
  S,
  From extends string,
  To,
> = S extends `${infer L}${From}${infer R}` ? S : S;
```

추론에 성공했다면, `From`과 `From` 외의 문자열을 알고 있습니다. 따라서 일치하는
부분을 대체하는 새로운 템플릿 리터럴 타입을 반환할 수 있습니다:

```ts
type Replace<
  S,
  From extends string,
  To extends string,
> = S extends `${infer L}${From}${infer R}` ? `${L}${To}${R}` : S;
```

풀이는 `From`이 빈 문자열인 경우를 제외하면 잘 작동합니다. 빈 문자열일 경우엔 타
입스크립트가 추론할 수 없습니다. 빈 문자열인 엣지 케이스를 추가해야 합니다:

```ts
type Replace<
  S extends string,
  From extends string,
  To extends string,
> = From extends ""
  ? S
  : S extends `${infer L}${From}${infer R}`
  ? `${L}${To}${R}`
  : S;
```

## 참고

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Type inference in conditional types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Template Literal Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types)
