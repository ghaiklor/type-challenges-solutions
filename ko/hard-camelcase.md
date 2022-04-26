---
id: 114
title: CamelCase
lang: ko
level: hard
tags: template-literal
---

## 챌린지

문자열을 CamelCase로 바꿔보세요.

예시:

```typescript
type camelCased = CamelCase<"foo-bar-baz">; // expected "fooBarBaz"
```

## 해답

하이픈(-)으로 연결된 문자열의 일부분을 추론할 때에 흔히 쓰이는 패턴이 있습니다.
하이픈 이전에 있는 것들을 묶어 head로 두고, 하이픈 뒤에 있는 것들을 묶어 tail이라고 하겠습니다.
이제 이 부분들을 추론해 보겠습니다.

```typescript
type CamelCase<S> = S extends `${infer H}-${infer T}` ? never : never;
```

패턴이 존재하지 않는다면 어떻게 해야할까요?
기존의 문자열을 그대로 반환해주면 됩니다.

```typescript
type CamelCase<S> = S extends `${infer H}-${infer T}` ? never : S;
```

패턴이 존재한다면 하이픈을 지우고 tail의 첫 문자를 대문자로 교체해주면 됩니다.
이 과정이 부분 문자열에서 반복적으로 수행되어야 할 수도 있습니다.
따라서 작업을 재귀적으로 만들어 줍니다.

```typescript
type CamelCase<S> = S extends `${infer H}-${infer T}`
  ? `${H}${CamelCase<Capitalize<T>>}`
  : S;
```

남은 문제는 tail이 이미 대문자화 되어 있는 경우를 고려해주지 않았다는 것입니다.
이 문제는 tail에 대문자화 된 tail이 할당 가능할지 검사하는 것으로 해결할 수 있습니다.

```typescript
type CamelCase<S> = S extends `${infer H}-${infer T}`
  ? T extends Capitalize<T>
    ? never
    : `${H}${CamelCase<Capitalize<T>>}`
  : S;
```

tail이 이미 대문자화 된 경우라면 어떻게 해야할까요?
하이픈을 남겨두고 그 단계를 건너뛰어야 합니다.
그리고 tail에서 다시 재귀적인 수행을 시작합니다.

```typescript
type CamelCase<S> = S extends `${infer H}-${infer T}`
  ? T extends Capitalize<T>
    ? `${H}-${CamelCase<T>}`
    : `${H}${CamelCase<Capitalize<T>>}`
  : S;
```

이제 teamplate literal type을 통해 "camelCase"화 하는 타입을 완성 했습니다!

## References

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Type inference in conditional types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Recursive Conditional Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
- [Template Literal Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types)
