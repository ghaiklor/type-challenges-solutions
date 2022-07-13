---
id: 529
title: Absolute
lang: en
level: medium
tags: math template-literal
---

## Challenge

Implement the `Absolute` type. A type that take `string`, `number` or `bigint`.
The output should be a positive number string.

For example:

```typescript
type Test = -100;
type Result = Absolute<Test>; // expected to be "100"
```

## Solution

The easiest way to make a number absolute is to convert it to string and remove
the “-” sign. I’m not joking, literally. Remove the “-” sign.

We can approach it by checking if the type has a “-” sign in its template
literal type, and if so, we infer the part without the “-” sign, otherwise
return the type itself:

```typescript
type Absolute<T extends number | string | bigint> = T extends `-${infer N}`
  ? N
  : T;
```

So, e.g. if we provide the type `T = “-50”`, it will match the `“-<N>”`, where
`N` will become just “50”. That’s how it works.

Now, we can see that some tests are still failing. That is because we do not
return strings every time. When providing a positive number, it will not match
the literal type and return the number, but we need to return a string.

Let us fix that by wrapping our `T` in template literal type:

```typescript
type Absolute<T extends number | string | bigint> = T extends `-${infer N}`
  ? N
  : `${T}`;
```

Still, some tests are failing. We do not handle the case when `T` is a negative
number. Number will not match the template literal type of condition, so it will
return the negative number as a string. To overcome this, we can convert the
number to string:

```typescript
type Absolute<T extends number | string | bigint> = `${T}` extends `-${infer N}`
  ? N
  : `${T}`;
```

As a result, we got a type that takes any `number`, `string`, `bigint` and
converts it to the string. Afterwards, infers the number without “-” sign and
returns it or just returns the string without changes.

## References

- [Template Literal Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Type inference in conditional types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
