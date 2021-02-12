---
title: Capitalize
lang: en
level: medium
tags: template-literal
---

## Challenge

Implement `Capitalize<T>` which converts the first letter of a string to uppercase and leave the rest as-is.

For example:

```ts
type capitalized = Capitalize<'hello world'> // expected to be 'Hello world'
```

## Solution

At first, I didn’t get the challenge.
We can’t implement the generic solution for capitalizing characters in string literal type.
So, if using the built-in type `Capitalize`, it’s pretty straightforward:

```ts
type MyCapitalize<S extends string> = Capitalize<S>
```

That was not the intent, I believe.
We can’t use built-in `Capitalize` type, we can’t implement the generic solution.
How can we make characters capitalized without those?
By using a dictionary, of course!

To make a solution more simple I made a dictionary only for needed characters, that is `f`:

```ts
interface CapitalizedChars { 'f': 'F' };
```

We have a dictionary, now, let us infer the first character of the type.
We use the classic construct with a conditional type and inferring:

```ts
type Capitalize<S> = S extends `${infer C}${infer T}` ? C : S;
```

Type parameter `C` has the first character now.
We need to check if the character is present in our dictionary.
If so, we return the capitalized character from the dictionary, otherwise we return the first character without changes:

```ts
interface CapitalizedChars { 'f': 'F' };
type Capitalize<S> = S extends `${infer C}${infer T}` ? `${C extends keyof CapitalizedChars ? CapitalizedChars[C] : C}${T}` : S;
```

## References

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/advanced-types.html#conditional-types)
- [Type inference in conditional types](https://www.typescriptlang.org/docs/handbook/advanced-types.html#type-inference-in-conditional-types)
- [Template Literal Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types)
- [keyof and Lookup Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-1.html#keyof-and-lookup-types)
