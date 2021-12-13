---
id: 18
title: Length of Tuple
lang: ko
level: easy
tags: tuple
---

## Challenge

주어지는 튜플의 길이를 반환해주는 제네릭 `Length`를 만들어보세요.

예시:

```ts
type tesla = ['tesla', 'model 3', 'model X', 'model Y']
type spaceX = ['FALCON 9', 'FALCON HEAVY', 'DRAGON', 'STARSHIP', 'HUMAN SPACEFLIGHT']

type teslaLength = Length<tesla> // expected 4
type spaceXLength = Length<spaceX> // expected 5
```

## Solution

JavaScript에서는 `length` 프로퍼티를 사용하여 배열의 길이에 접근할 수 있습니다.
타입 내에서도 똑같이 사용할 수 있습니다:

```ts
type Length<T extends any> = T['length']
```

이렇게만 할 경우 “Type 'length' cannot be used to index type 'T'.”라는 컴파일 에러를 얻습니다.
따라서 TypeScript에게 입력으로 주어진 타입변수가 해당 프로퍼티를 가지고 있음을 알려주어야 합니다:

```ts
type Length<T extends { length: number }> = T['length']
```

## 참고

- [Indexed Types](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)
