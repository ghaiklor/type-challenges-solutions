# Replace

![medium](https://img.shields.io/badge/-medium-d9901a)
![#template-literal](https://img.shields.io/badge/-%23template--literal-999)

## Challenge

Implement `Replace<S, From, To>` which replace the string `From` with `To` once in the given string `S`.

For example:

```ts
type replaced = Replace<'types are fun!', 'fun', 'awesome'> // expected to be 'types are awesome!'
```

## Solution

We have an input string `S` where we need to find a match for `From` and replace it with `To`.
It means that we need to split our string in three parts and infer each of them.

Let us start with it.
We infer the left part of the string until `From` is found, the `From` itself and everything after it as a right part:

```ts
type Replace<S, From extends string, To> = S extends `${infer L}${From}${infer R}` ? S : S;
```

Once the inferring successful, `From` is found and we have parts of the surrounding string.
So we can return a new template literal type by constructing its parts and replacing the match:

```ts
type Replace<S, From extends string, To extends string> = S extends `${infer L}${From}${infer R}` ? `${L}${To}${R}` : S;
```

Solution works with no issues, except the case when the `From` is an empty string.
Here, TypeScript will not infer the parts.
We fix it by adding an edge case for an empty string:

```ts
type Replace<
  S extends string,
  From extends string,
  To extends string
> = From extends '' ? S : S extends `${infer L}${From}${infer R}` ? `${L}${To}${R}` : S;
```

## References

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/advanced-types.html#conditional-types)
- [Type inference in conditional types](https://www.typescriptlang.org/docs/handbook/advanced-types.html#type-inference-in-conditional-types)
- [Template Literal Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types)
