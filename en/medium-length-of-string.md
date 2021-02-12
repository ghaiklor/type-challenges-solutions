---
lang: en
level: medium
tags: template-literal
---

# Length of String

![medium](https://img.shields.io/badge/-medium-d9901a)
![#template-literal](https://img.shields.io/badge/-%23template--literal-999)

## Challenge

Compute the length of a string literal, which behaves like `String#length`.

For example:

```typescript
type length = LengthOfString<"Hello, World"> // expected to be 12
```

## Solution

At first, I tried to go with a trivial solution - access the property `length` via index type.
I thought, maybe TypeScript is smart enough to get the value:

```typescript
type LengthOfString<S extends string> = S['length']
```

Unfortunately, no.
The evaluated type will be a `number`, not the number literal type.
So we need to think about something else.

What if we infer the first character and the tail of the string recursively until there are none first characters?
That way, the recursion itself will be our counter.
Let us start by writing a type that will infer the first character and the tail of the string:

```typescript
type LengthOfString<S extends string> = S extends `${infer C}${infer T}` ? never : never;
```

Type parameter `C` gets the first character of the string and `T` gets the tail.
Calling the type itself recursively with a tail, we will stop sometimes on the case when there are no characters:

```typescript
type LengthOfString<S extends string> = S extends `${infer C}${infer T}` ? LengthOfString<T> : never;
```

The problem with it is that we don’t know where to store the counter.
Obviously, we can add another type parameter that will accumulate the count, but TypeScript does not provide options to manipulate with numbers in the type system.
It would be great to add another type parameter and just increment its value.

Instead, we can make the type parameter a tuple with characters and fill it in with the first character on each recursive call:

```typescript
type LengthOfString<S extends string, A extends string[]> = S extends `${infer C}${infer T}` ? LengthOfString<T, [C, ...A]> : never;
```

We “convert” the string literal type into a tuple with its characters that are stored inside our new type parameter.
Once we hit the case when there are no characters (the base case for a recursion) we just return the length of the tuple:

```typescript
type LengthOfString<S extends string, A extends string[]> = S extends `${infer C}${infer T}` ? LengthOfString<T, [C, ...A]> : A['length'];
```

By introducing another type parameter, we broke the tests.
Because our type now requires having two type parameters instead of one.
Let us fix this by making our type parameter an empty tuple by default:

```typescript
type LengthOfString<S extends string, A extends string[] = []> = S extends `${infer C}${infer T}` ? LengthOfString<T, [C, ...A]> : A['length'];
```

## References

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/advanced-types.html#conditional-types)
- [Type inference in conditional types](https://www.typescriptlang.org/docs/handbook/advanced-types.html#type-inference-in-conditional-types)
- [Recursive Conditional Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
- [Template Literal Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types)
- [Variadic Tuple Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
- [Index Types](https://www.typescriptlang.org/docs/handbook/advanced-types.html#index-types)
