---
id: 3326
title: BEM Style String
lang: ko
level: medium
tags: template-literal union tuple
---

## 챌린지

블록, 엘리먼트, 모디파이어 방법론(BEM)은 CSS에서 인기 있는 클래스 네이밍 방법 중
하나입니다.

예를 들어, 블록 컴포넌트는 `btn`으로 표현될 수 있고, 그 블록에 의존적인 엘리먼트
는 `btn__price`가 될 수 있습니다. 블록의 스타일을 변화시키는 모디파이어의 경우
`btn--big`이나 `btn__price--warning`으로 표현합니다.

세 개의 매개변수를 가지고 문자열 유니온을 만드는 `BEM<B, E, M>`을 구현해보세요.
`B`는 문자열이고, `E`와 `M`은 문자열 배열이거나 (빈 배열일 수) 있습니다.

## 해답

이번 챌린지에서는 주어진 조건에 따라 어떤 문자열을 만들어야 합니다. 따라야 하는
조건은 블록, 엘리먼트, 모디파이어 3가지 입니다. 풀이의 형태를 단순하게 하기 위해
세 개의 개별적인 타입으로 분리할 것을 제안하고 싶습니다.

첫 번째인 블록부터 시작하겠습니다:

```typescript
type Block<B extends string> = any;
```

이 타입은 입력으로 들어온 타입 매개변수를 포함하는 템플릿 리터럴 타입을 반환하기
만 하면 되어서 꽤 간단합니다:

```typescript
type Block<B extends string> = `${B}`;
```

다음은 엘리먼트입니다. 주어지는 엘리먼트 배열이 비었을 수도 있기 때문에 블록처럼
템플릿 리터럴 타입을 반환할 수 없습니다. 따라서 배열이 비어있는지 검사한 후에 문
자열을 구성해야 합니다. `T[number]`와 같이 접근할 때 빈 배열은 `never` 타입을 반
환하는 것을 이용하여 조건부 타입을 사용할 수 있습니다:

```typescript
type Element<E extends string[]> = E[number] extends never ? never : never;
```

엘리먼트 배열이 비어있다면 빈 문자열을 반환하면 됩니다(접두사로 `__`와 같이 붙일
필요가 없습니다):

```typescript
type Element<E extends string[]> = E[number] extends never ? `` : never;
```

배열이 비어있지 않은 것을 확인했다면 접두사 `__`를 엘리먼트와 연결하여 템플릿 리
터럴 타입으로 만듭니다:

```typescript
type Element<E extends string[]> = E[number] extends never
  ? ``
  : `__${E[number]}`;
```

같은 로직을 마지막 조건인 모디파이어에도 적용할 수 있습니다. 모디파이어 배열이비
어있을 경우에는 빈 문자열을 반환합니다. 그렇지 않은 경우에는 접두사가 붙은 모디
파이어의 유니온을 반환합니다:

```typescript
type Modifier<M extends string[]> = M[number] extends never
  ? ``
  : `--${M[number]}`;
```

남은 것은 세 타입을 처음 만든 타입에 합치는 것입니다:

```typescript
type BEM<
  B extends string,
  E extends string[],
  M extends string[]
> = `${Block<B>}${Element<E>}${Modifier<M>}`;
```

네 타입을 모두 합친 최종 풀이는 다음과 같습니다:

```typescript
type Block<B extends string> = `${B}`;
type Element<E extends string[]> = E[number] extends never
  ? ``
  : `__${E[number]}`;
type Modifier<M extends string[]> = M[number] extends never
  ? ``
  : `--${M[number]}`;
type BEM<
  B extends string,
  E extends string[],
  M extends string[]
> = `${Block<B>}${Element<E>}${Modifier<M>}`;
```

## 참고

- [Generics](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Generic Constraints](https://www.typescriptlang.org/docs/handbook/2/generics.html#generic-constraints)
- [Template Literal Types](https://www.typescriptlang.org/docs/handbook/2/template-literal-types.html)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
