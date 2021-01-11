<h1>Trim Left <img src="https://img.shields.io/badge/-medium-eaa648" alt="medium"/> <img src="https://img.shields.io/badge/-%23template--literal-999" alt="#template-literal"/></h1>

## Challenge

Implement `TrimLeft<T>` which takes an exact string type and returns a new string with the whitespace beginning removed.

For example

```ts
type trimed = TrimLeft<'  Hello World  '> // expected to be 'Hello World  '
```

## Solution

When you need to work with template strings in types, you need to use [template literal types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types).
It allows to model the strings in type system.

We have two cases here: the string with a white space on the left and the string without a white space.
In case we have a white space, we need to infer the other part of the string and check it for white space again.
Otherwise, we return the inferred part without changes.

Let us write a conditional type so we can use type inferring and combine it with a template literal type:

```ts
type TrimLeft<S> = S extends ` ${infer T}` ? TrimLeft<T> : S;
```

Turns out, that’s not a solution.
Some test cases are not passing.
That is because we do not handle the newline and tabs.
Let us fix that by replacing the white space with a union of those three:

```ts
type TrimLeft<S> = S extends `${' ' | '\n' | '\t'}${infer T}` ? TrimLeft<T> : S;
```
