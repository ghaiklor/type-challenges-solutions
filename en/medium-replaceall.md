<h1>ReplaceAll <img src="https://img.shields.io/badge/-medium-eaa648" alt="medium"/> <img src="https://img.shields.io/badge/-%23template--literal-999" alt="#template-literal"/></h1>

## Challenge

Implement `ReplaceAll<S, From, To>` which replace the all the substring `From` with `To` in the given string `S`

For example

```ts
type replaced = ReplaceAll<'t y p e s', ' ', ''> // expected to be 'types'
```

## Solution

We will base this solution on solution for Replace type.
For those who didn’t look there, I’ll repeat it here.

The input string S must be split into three parts.
The leftmost part before From, the From itself, the rightmost part after the From.
We can do that with conditional types and inferring.

Once the string is inferred and we know the parts, we can return a new template literal type which is constructed from those parts and our required To part:

```ts
type ReplaceAll<
  S extends string,
  From extends string,
  To extends string
> = From extends '' ? S : S extends `${infer L}${From}${infer R}` ? `${L}${To}${R}` : S;
```

This solution will replace a single match, but we need to replace all the matches.
It is easily achievable by providing our new string as a type parameter to the type itself (recursively):

```ts
type ReplaceAll<
  S extends string,
  From extends string,
  To extends string
> = From extends '' ? S : S extends `${infer L}${From}${infer R}` ? ReplaceAll<`${L}${To}${R}`, From, To> : S;
```
