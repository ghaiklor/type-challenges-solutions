---
id: 4179
title: Flip
lang: en
level: medium
tags: object-keys
---

## Challenge

Implement the type of `just-flip-object`. Examples:

```ts
Flip<{ a: "x", b: "y", c: "z" }>; // {x: 'a', y: 'b', z: 'c'}
Flip<{ a: 1, b: 2, c: 3 }>; // {1: 'a', 2: 'b', 3: 'c'}
Flip<{ a: false, b: true }>; // {false: 'a', true: 'b'}
```

No need to support nested objects and values which cannot be object keys such as arrays.

## Solution

Let us start with the basic block and construct the same object but instead of returning the value, we'll return the key itself.

```ts
type Flip<T> = {[P in keyof T]: P}
// {key: key, ...}
```

Now let's remap the keys of our generated type with their values by using the [“as” syntax](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#key-remapping-in-mapped-types):

```ts
type Flip<T> = {[P in keyof T as T[P] extends AllowedTypes ? T[P] : never]: P}
// {value: key, ...}
```

Our type helper `AllowedType` should contain all the types which can be used as a key in an object. Looking at the test cases, we see that string, number and boolean can be used as keys.

```ts
type AllowedTypes = string | number | boolean
```

Notice, this still doesn't pass all the test cases. The reason is because the keys of an object can only be of the type string. So we need to stringify our keys.

```ts
type Flip<T> = {[P in keyof T as T[P] extends AllowedTypes ? `${T[P]}` : never]: P}
```

## References

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Key remapping in mapped types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#key-remapping-in-mapped-types)
- [Mapped Types](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
