<h1>Trim <img src="https://img.shields.io/badge/-medium-eaa648" alt="medium"/> <img src="https://img.shields.io/badge/-%23template--literal-999" alt="#template-literal"/></h1>

## Challenge

Implement `Trim<T>` which takes an exact string type and returns a new string with the whitespace from both ends removed.

For example

```ts
type trimed = Trim<'  Hello World  '> // expected to be 'Hello World'
```

## Solution

Same task as in `TrimLeft<T>` (almost).
We used [template literal types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types) there to model the string in type system.

There are three cases: white space on the left, white space on the right of the string, and the string without white spaces on both sides.

Let us start with modelling the case when there is a white space on the left.
By combining template literal type with a conditional type, we can infer the rest of the string without a white space.
When it is the case, we recursively continue trimming white spaces on the left, until there are none and we return the string without changes:

```ts
type Trim<S> = S extends ` ${infer R}` ? Trim<R> : S;
```

Once there are no white spaces on the left, we need to check if there are some on the right of the string and do the same:

```ts
type Trim<S> = S extends ` ${infer R}` ? Trim<R> : S extends `${infer L} ` ? Trim<L> : S;
```

That way, we split the white spaces on the left, then split on the right.
Until there are none white spaces and we just return the string itself.

But we are getting failing test cases now.
That is because we do not handle the newlines and tabs.

I don’t want to duplicate the union type, so I made a separate type and replaced white space with its type union:

```ts
type Whitespace = ' ' | '\n' | '\t';
type Trim<S> = S extends `${Whitespace}${infer R}` ? Trim<R> : S extends `${infer L}${Whitespace}` ? Trim<L> : S;
```
