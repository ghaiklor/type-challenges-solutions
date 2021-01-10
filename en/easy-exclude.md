<h1>Exclude <img src="https://img.shields.io/badge/-easy-90bb12" alt="easy"/> <img src="https://img.shields.io/badge/-%23built--in-999" alt="#built-in"/></h1>

## Challenge

Implement the built-in Exclude<T, U>

> Exclude from T those types that are assignable to U

## Solution

The important detail here is a knowledge that conditional types in TypeScript are [distributive](https://www.typescriptlang.org/docs/handbook/advanced-types.html#distributive-conditional-types).

So that when you are writing the construct `T extends U` where T is the union, actually what is happening is TypeScript iterates over the union T and applies the condition to each element.

Therefore, the solution is pretty straightforward.
We check that T can be assigned to U and if so; we skip it:

```ts
type MyExclude<T, U> = T extends U ? never : T;
```
