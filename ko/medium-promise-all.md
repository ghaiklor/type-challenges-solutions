---
id: 20
title: Promise.all
lang: ko
level: medium
tags: array built-in
---

## 챌린지

`PromiseLIke` 객체 배열을 받는 함수 `PromiseAll`을 만들어보세요. 반환되는 값은
`Promise<T>`이고 `T`는 성공된 결과가 담긴 배열입니다.

```ts
const promise1 = Promise.resolve(3);
const promise2 = 42;
const promise3 = new Promise<string>((resolve, reject) => {
  setTimeout(resolve, 100, "foo");
});

// expected to be `Promise<[number, number, string]>`
const p = Promise.all([promise1, promise2, promise3] as const);
```

## 해답

흥미로운 챌린지입니다. 처음부터 한 단계씩 설명해보겠습니다.

`Promise<T>`를 반환하는 함수부터 풀이를 시작하겠습니다. 마지막 반환값으로
`Promise<T>`를 반환해야 하는데 `T`는 성공된 프로미스의 타입이 담긴 배열입니다:

```ts
declare function PromiseAll<T>(values: T): Promise<T>;
```

이제 성공된 프로미스의 타입을 어떻게 가져올지 고민해 볼 차례입니다. `values`가배
열이라는 사실에 주목해주세요. 이것을 타입에 명시해 주겠습니다.
[가변 인자 튜플 타입](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)을
사용하면 타입을 쪼갤 수 있기 때문에 그 원소들에 대해 작업하는 것이 용이해집니다:

```ts
declare function PromiseAll<T extends unknown[]>(values: [...T]): Promise<T>;
```

“Argument of type ‘readonly [1, 2, 3]’ is not assignable to parameter of type
‘[1, 2, 3]’.“ 같은 컴파일 에러를 얻을 수 있습니다. `values` 매개변수에
`readonly` 수정자가 있는 것을 예상하지 못했기 때문입니다. 매개변수에 수정자를 붙
여 이 에러를 해결합니다:

```ts
declare function PromiseAll<T extends unknown[]>(
  values: readonly [...T],
): Promise<T>;
```

이제 테스트 케이스 중 하나를 통과하는 풀이를 만들었습니다. 그 테스트 케이스엔 프
로미스가 포함되어 있지 않기 때문에 통과가 가능합니다. `T`가 `values` 매개변수에
주어진 타입과 같게 하여 `Promise<T>`를 반환하고 있습니다. `values` 매개변수에
`Promise`가 포함되어 있다면 풀이가 조금 어려워집니다.

그 이유는 `Promise`로 감싸진 타입을 꺼내서 반환해야 하기 때문입니다. 따라서
`T`에 조건부 타입을 적용하여 원소가 `Promise`인지 검사합니다. 맞다면 내부의 타입
을 꺼내서 반환하고 아닌 경우엔 타입을 그대로 반환합니다:

```ts
declare function PromiseAll<T extends unknown[]>(
  values: readonly [...T],
): Promise<T extends Promise<infer R> ? R : T>;
```

풀이가 여전히 통과되지 않습니다. 그 이유는 `T`가 유니온이 아니라 튜플이기 때문입
니다. 따라서 튜플의 각 원소를 순회하면서 값이 `Promise`인지 검사해야 합니다:

```ts
declare function PromiseAll<T extends unknown[]>(
  values: readonly [...T],
): Promise<{ [P in keyof T]: T[P] extends Promise<infer R> ? R : T[P] }>;
```

## 참고

- [Variadic Tuple Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
- [Mapped Types](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
- [Index Types](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Type inference in conditional types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
