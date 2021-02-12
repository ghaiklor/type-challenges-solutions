---
title: String to Union
lang: en
level: medium
tags: union string
---

## Challenge

Implement the String to Union type.
Type take string argument.
The output should be a union of input letters.

For example:

```typescript
type Test = '123';
type Result = StringToUnion<Test>; // expected to be "1" | "2" | "3"
```

## Solution

In this challenge, we need to iterate over each character and add it to the union.
It is easy to iterate over the characters, let us start with that.
All we need to do is just infer two parts of the string: the first character and the tail:

```typescript
type StringToUnion<T extends string> = T extends `${infer C}${infer T}` ? never : never
```

Here, we will get two type parameters `C` and `T` (character and tail appropriately).
To continue iterating over the characters, we need to call our type recursively and provide the tail to it:

```typescript
type StringToUnion<T extends string> = T extends `${infer C}${infer T}` ? StringToUnion<T> : never
```

The only thing left is the union itself.
We need to add the first character to the union and since in the base case `StringToUnion` returns a `C | never`, we can just add union with `C`:

```typescript
type StringToUnion<T extends string> = T extends `${infer C}${infer T}` ? C | StringToUnion<T> : never
```

## References

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/advanced-types.html#conditional-types)
- [Type inference in conditional types](https://www.typescriptlang.org/docs/handbook/advanced-types.html#type-inference-in-conditional-types)
- [Recursive Conditional Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
- [Template Literal Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types)
- [Union Types](https://www.typescriptlang.org/docs/handbook/unions-and-intersections.html#union-types)
