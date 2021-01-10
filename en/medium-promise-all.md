<h1>Promise.all <img src="https://img.shields.io/badge/-medium-eaa648" alt="medium"/> <img src="https://img.shields.io/badge/-%23array-999" alt="#array"/> <img src="https://img.shields.io/badge/-%23built--in-999" alt="#built-in"/></h1>

## Challenge

Type the function `PromiseAll` that accepts an array of PromiseLike objects, the returning value should be `Promise<T>` where `T` is the resolved result array.

```ts
const promise1 = Promise.resolve(3);
const promise2 = 42;
const promise3 = new Promise<string>((resolve, reject) => {
  setTimeout(resolve, 100, 'foo');
});

// expected to be `Promise<[number, number, string]>`
const p = Promise.all([promise1, promise2, promise3] as const)
```

## Solution

Interesting challenge here, IMHO.
Let me explain it step by step.

We start with the simplest solution - the function that returns `Promise<T>`.
We need to return `Promise<T>` after all, where T is an array of types for resolved promises:

```ts
declare function PromiseAll<T>(values: T): Promise<T>
```

Now, let us think how to evaluate types for resolved promises.
We start with the fact that `values` is an array.
So let us show that in our types.
By using [variadic tuple types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types) we can split its types so it is easier to work with its elements:

```ts
declare function PromiseAll<T extends unknown[]>(values: [...T]): Promise<T>
```

Oops, getting the compilation error “Argument of type ‘readonly [1, 2, 3]’ is not assignable to parameter of type ‘[1, 2, 3]’.“.
That is because we do not expect to have a `readonly` modifier in our `values` parameter.
Let us fix that by adding the modifier to the parameter:

```ts
declare function PromiseAll<T extends unknown[]>(values: readonly [...T]): Promise<T>
```

We have a solution that even works on one of the test cases.
That is because the test case does not have promises inside.
We return `Promise<T>` where T is just an array with the same types as in `values` parameter.
But once we get Promise inside the `values` parameter, things going wild.

The reason is that we do not unwrap the type from Promise and just return it as is.
So let us replace the T with a conditional type to check if the element is actually a Promise.
If so, we return its inner type, otherwise - the type with no changes:

```ts
declare function PromiseAll<T extends unknown[]>(values: readonly [...T]): Promise<T extends Promise<infer R> ? R : T>
```

The solution still does not work, because the T is not a union but the tuple.
So we need to iterate over each element in the tuple and check if the value is a Promise or not:

```ts
declare function PromiseAll<T extends unknown[]>(values: readonly [...T]): Promise<{ [P in keyof T]: T[P] extends Promise<infer R> ? R : T[P] }>
```
