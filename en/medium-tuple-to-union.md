<h1>Tuple to Union <img src="https://img.shields.io/badge/-medium-eaa648" alt="medium"/> <img src="https://img.shields.io/badge/-%23infer-999" alt="#infer"/> <img src="https://img.shields.io/badge/-%23tuple-999" alt="#tuple"/> <img src="https://img.shields.io/badge/-%23union-999" alt="#union"/></h1>

## Challenge

Implement a generic `TupleToUnion<T>` which covers the values of a tuple to its values union.

For example

```ts
type Arr = ['1', '2', '3']

const a: TupleToUnion<Arr> // expected to be '1' | '2' | '3'
```

## Solution

We need to take all the elements from an array and convert it to the union.
Luckily, TypeScript already has it in its type system - [lookup types](https://www.typescriptlang.org/docs/handbook/advanced-types.html#index-types).

We can use the construct `T[number]` to get the union of all elements of T:

```ts
type TupleToUnion<T> = T[number]
```

But, we will get an error “Type ‘number’ cannot be used to index type ‘T’“.
That is because we don’t have a constraint over T that is saying to the compiler it is an array that can be indexed.
Let us fix that by adding `extends unknown[]`:

```ts
type TupleToUnion<T extends unknown[]> = T[number]
```
