---
id: 110
title: Capitalize
lang: ko
level: medium
tags: template-literal
---

## 챌린지

문자열의 첫 글자를 대문자로 바꾸는 `Capitalize<T>` 타입을 구현해보세요.

예시:

```ts
type capitalized = Capitalize<"hello world">; // expected to be 'Hello world'
```

## 해답

처음엔 이 챌린지가 잘 와닿지 않을 수 있습니다. 문자열 리터럴 타입을 대문자화 하
는 제네릭을 구현할 수 없기 때문입니다. 내장 타입인 `Capitalize`를 이용한다면 쉽
게 해결할 수 있긴 합니다:

```ts
type MyCapitalize<S extends string> = Capitalize<S>;
```

하지만 이게 챌린지의 의도는 아닐 것입니다. 내장 타입 `Capitalize`를 사용할 수 없
다면, 제네릭으로 풀 수 없는 챌린지입니다. 위의 방법을 쓸 수 없다면 어떻게 대문자
화 할 수 있을까요? 딕셔너리를 이용할 수 있습니다!

풀이를 단순하게 만들기 위해 필요한 문자에 대해서만 딕셔너리를 만들었습니다. 지금
은 `f`를 사용하겠습니다:

```ts
interface CapitalizedChars {
  f: "F";
}
```

딕셔너리를 만든 후에 문자열 타입에서 첫 문자를 타입 추론합니다. 조건부 타입과 타
입 추론의 가장 일반적인 구조를 사용합시다:

```ts
type Capitalize<S> = S extends `${infer C}${infer T}` ? C : S;
```

타입 매개변수 `C`는 첫 문자를 의미합니다. 선택된 첫 문자가 딕셔너리에 존재하는지
확인해야 합니다. 존재할 경우 대문자화 된 문자를 딕셔너리에서 반환해 줄 것입니다.
반대의 경우에는 첫 문자를 아무 변화 없이 반환합니다:

```ts
interface CapitalizedChars {
  f: "F";
}
type Capitalize<S> = S extends `${infer C}${infer T}`
  ? `${C extends keyof CapitalizedChars ? CapitalizedChars[C] : C}${T}`
  : S;
```

## 참고

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Type inference in conditional types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Template Literal Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types)
- [keyof and Lookup Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-1.html#keyof-and-lookup-types)
