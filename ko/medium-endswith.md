---
id: 2693
title: EndsWith
lang: ko
level: medium
tags: template-literal
---

## 챌린지

문자열 `T`와 `U`를 받아 `T`가 `U`로 끝나는지 반환하는 제네릭 `EndsWith<T, U>`을 구현해 보세요:

```typescript
type R0 = EndsWith<"abc", "bc">; // true
type R1 = EndsWith<"abc", "abc">; // true
type R2 = EndsWith<"abc", "d">; // false
```

## 해답

이 챌린지는 보통 단계로 분류되어 있지만 그 정도 난이도는 아니라고 생각합니다.
단계를 직접 정할 수는 없지만 보통보다는 쉬움 단계가 맞는 것 같습니다.

주어지는 문자열이 특정 문자열로 끝나는지 검사해야 합니다.
이 경우에는 템플릿 리터럴 타입이 유용하게 쓰일 수 있습니다.

먼저 어떤 문자열이든지 받을 수 있는 템플릿 리터럴 타입을 만들겠습니다.
이 시점에 문자열의 내용은 신경 쓰지 않기 때문에 `any` 타입을 넣습니다:

```typescript
type EndsWith<T extends string, U extends string> = T extends `${any}`
  ? never
  : never;
```

위의 타입은 컴파일러에게 "문자열 리터럴 타입 `T`가 `any` 타입을 확장하고 있는지 검사해줘."라고 물어보는 것과 같습니다.
그리고 질문의 답은 참입니다.

이제 실제로 검사할 문자열을 추가합니다.
검사할 문자열은 타입 매개변수 `U`를 통해 전달되고 그것이 기존 문자열의 끝부분과 일치하는지 확인합니다.

다음과 같습니다:

```typescript
type EndsWith<T extends string, U extends string> = T extends `${any}${U}`
  ? never
  : never;
```

위의 구조를 통해 문자열이 어떤 문자열이든 확장할 수 있지만 끝부분이 `U`인지를 검사할 수 있습니다.
결과에 따라 불린 타입을 반환해주면 완성입니다:

```typescript
type EndsWith<T extends string, U extends string> = T extends `${any}${U}`
  ? true
  : false;
```

## 참고

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Template Literal Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types)
