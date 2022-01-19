---
id: 2070
title: Drop Char
lang: ko
level: medium
tags: template-literal infer
---

## 챌린지

문자열에서 제시된 문자를 제외해야 합니다.

예시:

```typescript
type Butterfly = DropChar<' b u t t e r f l y ! ', ' '> // 'butterfly!'
```

## 해답

이 챌린지를 해결하기 위해 템플릿 리터럴 타입에 대해 알아야 합니다.
타입스크립트 핸드북에서 [관련 정보](https://www.typescriptlang.org/docs/handbook/2/template-literal-types.html)를 더 읽어보실 수 있습니다.

템플릿 리터럴 타입을 사용하여 문자열에서 필요한 부분을 추론하고 그것이 기대한 결과와 같은지 확인할 수 있습니다.
가장 간단한 예시부터 시작하겠습니다. 문자열의 왼편과 오른편을 추론합니다.
두 부분 사이의 구분자가 기대하는 문자가 됩니다.

```typescript
type DropChar<S, C> = S extends `${infer L}${C}${infer R}`
  ? never
  : never;
```

위와 같이 표기했을 때엔 다음과 같은 컴파일 에러를 얻습니다. “Type ‘C’ is not assignable to type ‘string | number | bigint | boolean | null | undefined’.“.
제네릭에 제약을 주어 해결할 수 있습니다.

```typescript
type DropChar<S, C extends string> = S extends `${infer L}${C}${infer R}`
  ? never
  : never;
```

모든 부분과 그 사이의 문자 `C`를 얻을 수 있음을  확인했습니다.
`C`를 제외하는 것이 목표이기 때문에 `C`를 제외한 왼편과 오른편을 반환합니다.

```typescript
type DropChar<S, C extends string> = S extends `${infer L}${C}${infer R}`
  ? `${L}${R}`
  : never;
```

위 방식으로 문자열에서 문자 하나를 제외할 수 있습니다.
문자를 더 제외하기 위해 위의 타입을 재귀적으로 호출해야 합니다.

```typescript
type DropChar<S, C extends string> = S extends `${infer L}${C}${infer R}`
  ? DropChar<`${L}${R}`, C>
  : never;
```

찾는 패턴이 문자열에 존재하지 않는 경우까지 대응해주면 모든 경우를 처리할 수 있습니다.
그 경우엔 주어진 문자열을 그대로 반환해주면 됩니다.

```typescript
type DropChar<S, C extends string> = S extends `${infer L}${C}${infer R}`
  ? DropChar<`${L}${R}`, C>
  : S;
```

## 참고

- [Template Literal Types](https://www.typescriptlang.org/docs/handbook/2/template-literal-types.html)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Inferring within Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
