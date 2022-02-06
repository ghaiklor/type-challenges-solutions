---
id: 527
title: Append to Object
lang: zh
level: medium
tags: object-keys
---

## Challenge

Implement a type that adds a new field to the interface.
The type takes the three arguments.
The output should be an object with the new field.

For example:

```ts
type Test = { id: "1" };
type Result = AppendToObject<Test, "value", 4>; // expected to be { id: '1', value: 4 }
```

## Solution

When we try to change objects\interfaces in TypeScript, usually intersection types are helpful for that.
This challenge is not an exception.
I’ve tried to write a type that takes the whole `T` plus an object with a new property:

```typescript
type AppendToObject<T, U, V> = T & { [P in U]: V };
```

Unfortunately, this solution does not satisfy the tests.
They are expecting to have a flat type, not the intersection.
So we need to return an object type where all the properties plus our new property.
I’ll start by mapping the properties from `T`:

```typescript
type AppendToObject<T, U, V> = { [P in keyof T]: T[P] };
```

Now, we need to add to those properties of `T` our new property `U`.
Easy, here is the trick.
Nothing stops you from passing a union to `in` operator:

```typescript
type AppendToObject<T, U, V> = { [P in keyof T | U]: T[P] };
```

That way, we will get all the properties of `T` plus properties of `U`, exactly what we need here.
Let us fix minor errors now by adding a constraint to `U`:

```typescript
type AppendToObject<T, U extends string, V> = { [P in keyof T | U]: T[P] };
```

The only thing that TypeScript can’t handle now is the fact, that `P` can be absent in `T`, because `P` is a union of `T` and `U`.
We need to handle the case and check, if `P` is from the `T`, we get `T[P]`, otherwise we pass `V`:

```typescript
type AppendToObject<T, U extends string, V> = {
  [P in keyof T | U]: P extends keyof T ? T[P] : V;
};
```

## References

- [Mapped Types](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Union Types](https://www.typescriptlang.org/docs/handbook/2/everyday-types.html#union-types)
