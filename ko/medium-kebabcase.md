---
id: 612
title: KebabCase
lang: ko
level: medium
tags: template-literal
---

## 챌린지

문자열을 kebab-case로 변환해보세요.

예시:

```typescript
type kebabCase = KebabCase<"FooBarBaz">; // expected "foo-bar-baz"
```

## 해답

이번 챌린지는 ["CamelCase"](./medium-camelcase.md)와 비슷한 유형입니다.
타입 추론으로부터 시작할 것이고 문자열의 첫 문자와 그 뒷부분을 알아내야 합니다.

```typescript
type KebabCase<S> = S extends `${infer C}${infer T}` ? never : never;
```

문자와 뒷부분으로 이루어진 패턴을 찾을 수 없다면 남은 문자열이 없다는 의미이고 탐색을 종료합니다.
이 경우 입력으로 들어온 문자열을 그대로 반환해주면 됩니다.

```typescript
type KebabCase<S> = S extends `${infer C}${infer T}` ? never : S;
```

패턴이 있을 경우에는 두 가지 경우로 나누어서 다루어야 합니다.
첫번째 경우는 뒷부분의 첫 문자가 대문자가 아닌 경우입니다.
두번째 경우는 대문자일 경우입니다.
각 케이스를 확인하기 위해 `Uncapitalize` 타입을 사용할 수 있습니다.

```typescript
type KebabCase<S> = S extends `${infer C}${infer T}`
  ? T extends Uncapitalize<T>
    ? never
    : never
  : S;
```

뒷부분의 첫 문자가 이미 소문자였던 경우엔 무엇을 해야할까요?
예를 들면 문자열은 "Foo"이거나 "foo"일 수 있습니다.
이 경우 첫번째 문자를 소문자화하고 뒷부분은 수정 없이 그대로 사용합니다.
문자열에 대해 같은 과정을 반복하여 진행해 주는 것을 잊어선 안됩니다.

```typescript
type KebabCase<S> = S extends `${infer C}${infer T}`
  ? T extends Uncapitalize<T>
    ? `${Uncapitalize<C>}${KebabCase<T>}`
    : never
  : S;
```

이제 고려해야 할 마지막 경우는 뒷부분의 첫 문자가 대문자인 경우입니다. 예시로 "fooBar"가 있습니다.
이 경우엔 첫 문자를 소문자화하고, 하이픈을 추가한 뒤에 뒷부분에 대해 같은 작업을 반복합니다.
뒷부분의 첫 문자를 따로 소문자화 해줄 필요는 없습니다. 그 이유는 이후에 `Uncapitalize<C>`에서 그 문자가 소문자화 될 것이기 때문입니다.

```typescript
type KebabCase<S> = S extends `${infer C}${infer T}`
  ? T extends Uncapitalize<T>
    ? `${Uncapitalize<C>}${KebabCase<T>}`
    : `${Uncapitalize<C>}-${KebabCase<T>}`
  : S;
```

## 참고

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Type inference in conditional types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Recursive Conditional Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
- [Template Literal Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types)
