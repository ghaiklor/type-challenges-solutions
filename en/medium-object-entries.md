---
id: 2946
title: ObjectEntries
lang: en
level: medium
tags: object-keys
---

## Challenge

Implement the type version of `Object.entries`.
For example:

```ts
interface Model {
  name: string;
  age: number;
  locations: string[] | null;
}

type modelEntries = ObjectEntries<Model>;
// ['name', string] | ['age', number] | ['locations', string[] | null];
```

## Solution

Looking at the problem, the idea is to use [Mapped Types](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html) to iterate over each key in the object and generate `[key, typeof key]` for each key.

```ts
type ObjectEntries<T> = { [P in keyof T]: [P, T[P]] };
// { key: [key, typeof key], ... }
```

Finally, to convert the generated type as a union, we'll just append `keyof T` at the end.

```ts
type ObjectEntries<T> = { [P in keyof T]: [P, T[P]] }[keyof T];
// [key, typeof key] | ...
```

So how does appending `keyof T` generates union you ask? Well, say you had an object:

```ts
const obj = {
  foo: "bar",
};
```

In order to access the `foo` property, we could use a dot operator(`obj.foo`) or a square bracket syntax(`obj["foo"]`).

In our solution above, we are using the same trick.
Since `keyof T` can be any of the keys present in `T`, TypeScript generates all possible outcomes and turns them into a union type.

Coming back to our problem, notice how some of the test cases have passed.
Taking a closer look at the test cases which have failed, we find that:

- All of the optional keys have to be converted into required. We can do so by using "Mapping Modifier".
- Since the `Partial` type appends undefined to a type, we have to take care of that.

```ts
type HandleUndefined<F, S extends keyof F> = F[S] extends infer R | undefined
  ? R
  : F[S];
type ObjectEntries<T> = {
  [P in keyof T]-?: [P, HandleUndefined<T, P>];
}[keyof T];
```

## References

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Mapped Types](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
- [Mapping Modifiers](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html#mapping-modifiers)
