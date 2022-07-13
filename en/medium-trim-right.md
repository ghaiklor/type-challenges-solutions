---
id: 4803
title: Trim Right
lang: en
level: medium
tags: template-literal
---

## Challenge

Implement `TrimRight<T>` which takes an exact string type and returns a new
string with the whitespace ending removed. For example:

```typescript
type Trimmed = TrimRight<"   Hello World    ">; // expected to be '   Hello World'
```

## Solution

This challenge is really the same as in other ones, [Trim](./medium-trim.md) and
[Trim Left](./medium-trimleft.md). But this time, we need to remove the white
spaces on the right.

We start as usual with the blank type we need to implement:

```typescript
type TrimRight<S extends string> = any;
```

Now, how to check if the string ends with the whitespace? We can use conditional
type for that by taking the input string literal type and adding a whitespace in
the end:

```typescript
type TrimRight<S extends string> = S extends `${infer T} ` ? never : never;
```

Pay attention to the `infer T` part there. If the string really ends with a
whitespace, we need to take a part of it without the whitespace. Hence, we infer
the part of the string without it into type parameter `T`.

Having a part of the string without the whitespace on the right, we can return
it:

```typescript
type TrimRight<S extends string> = S extends `${infer T} ` ? T : never;
```

However, in such case, it will solve the problem only for a single whitespace.
What about the cases when there are more of them? To cover them, we need to
continue getting rid of them until there are none left. It is easily achieved by
calling the same type recursively:

```typescript
type TrimRight<S extends string> = S extends `${infer T} `
  ? TrimRight<T>
  : never;
```

Now, our type will be recursively removing the whitespace one by one, until
there is no whitespace at all. In such case, our conditional type does not match
and will go into false branch. There, since we do not have a whitespace at this
step, we can return the input string without any modifications:

```typescript
type TrimRight<S extends string> = S extends `${infer T} ` ? TrimRight<T> : S;
```

I thought that this is it, the solution. But we can see in the test cases that
there are some failing. The reason is that we do not handle the tab and newline
characters. So let's move them into a separate type called `Whitespace` where we
make a list of characters to handle:

```typescript
type Whitespace = " " | "\n" | "\t";
```

And now, simply replace our inline character with the type:

```typescript
type TrimRight<S extends string> = S extends `${infer T}${Whitespace}`
  ? TrimRight<T>
  : S;
```

The whole solution with both types is:

```typescript
type Whitespace = " " | "\n" | "\t";
type TrimRight<S extends string> = S extends `${infer T}${Whitespace}`
  ? TrimRight<T>
  : S;
```

## References

- [Union Types](https://www.typescriptlang.org/docs/handbook/2/everyday-types.html#union-types)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Type inference in conditional types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Recursive conditional types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
- [Template Literal Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types)
