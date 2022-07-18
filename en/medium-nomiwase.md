---
id: 4260
title: AllCombinations
lang: en
level: medium
tags: union
---

## Challenge

Implement type `AllCombinations<S>` that return all combinations of strings
which use characters from `S` at most once. For example:

```typescript
type AllCombinations_ABC = AllCombinations<"ABC">;
// should be '' | 'A' | 'B' | 'C' | 'AB' | 'AC' | 'BA' | 'BC' | 'CA' | 'CB' | 'ABC' | 'ACB' | 'BAC' | 'BCA' | 'CAB' | 'CBA'
```

## Solution

It took me some time and some hints from people to solve this one. Turns out to
be pretty challenging at some points. I'll try to explain it as incrementally as
possible, but can't guarantee that everything will be well explained, sorry.
Feel free to discuss in the comments and offer your explanations and solutions,
thanks!

So we need to build combinations of the letters. What first comes to mind is to
use a union of characters, so we can enumerate those in mapped types. To get a
union of characters from the string, we can take a peek into the other solution
we have here - [StringToUnion](./medium-string-to-union.md). I'm not going to
dive into details here. In case there is something unclear, take a look into the
solution for [StringToUnion](./medium-string-to-union.md).

Ok, here is one to get a union of characters from the string:

```typescript
type StringToUnion<S> = S extends `${infer C}${infer R}`
  ? C | StringToUnion<R>
  : never;

type R0 = StringToUnion<"ABCD">;
// type R0 = "A" | "B" | "C" | "D"
```

In two words, we split the string into the first character and the rest of the
string. The first character goes as the item of the union, while the rest
recursively goes into the same type. Which gives us a union of characters,
exactly what we need.

Having a union of characters, it will be easier to enumerate those. Let's start
with the blank type we need to implement:

```typescript
type AllCombinations<S> = any;
```

Here, type parameter `S` holds the string we need to work with. Let's add
another type parameter to hold the union of characters and call it `U`:

```typescript
type AllCombinations<S, U = StringToUnion<S>> = any;
```

So when our type will be called with the string in `S`, the type parameter `U`
will be populated by the union of `S` characters. Let's see it in action:

```typescript
type R0 = AllCombinations<"ABCD">;
// type S = 'ABCD'
// type U = 'A' | 'B' | 'C' | 'D'
```

To create a combination, we need to take one character from the union and append
to it other combinations. It will continue unless there are no characters left.
So we will start with the conditional type that checks if the union is empty or
not. Remember, from the `StringToUnion` type, when there are no characters it
will return type `never`. So the check here is actually the check for `never`
type:

```typescript
type AllCombinations<S, U = StringToUnion<S>> = U extends never ? never : never;
```

In case the union is empty, it means to us that there are no characters left,
and we can return an empty string:

```typescript
type AllCombinations<S, U = StringToUnion<S>> = U extends never ? "" : never;
```

Otherwise, we need to take the character from the union and the rest of them. It
can be simply achieved by using distributed mapped types. But in order to not
overwhelm you, let's add a mapped type that simply returns the character for
now:

```typescript
type AllCombinations<S, U = StringToUnion<S>> = U extends never
  ? ""
  : { [C in U]: C };
```

With this type in place, we have a union of object types where the keys and the
values are the characters of the string. For instance:

```typescript
type R0 = AllCombinations<"ABCD">;
// type R0 = { A: "A"; } | { B: "B"; } | { C: "C"; } | { D: "D"; }
```

Getting a compiler complaining about “Type 'U' is not assignable to type 'string
| number | symbol'”. By adding a generic constraint over type parameter `U` we
can fix this:

```typescript
type AllCombinations<S, U extends string = StringToUnion<S>> = U extends never
  ? ""
  : { [C in U]: C };
```

Now, having objects for each character, we can start replacing the single
character with the combinations. So, instead of having `C` as a value, we need
to have a string that starts with `C` and other combinations:

```typescript
type AllCombinations<S, U extends string = StringToUnion<S>> = U extends never
  ? ""
  : { [C in U]: `${C}${AllCombinations<never, never>}` };
```

However, when calling the `AllCombinations` type recursively, I put two `never`
types as parameters. Let's think about what we need to put there instead.

The first type parameter `S` is being used as an input string, so we really
don't care about it at this step, because we have a union of its characters. The
second type parameter is used as characters we need to work with. Having one of
them already in place (`C`), we need to pass the rest of them without it. So we
exclude `C` from the union:

```typescript
type AllCombinations<S, U extends string = StringToUnion<S>> = U extends never
  ? ""
  : { [C in U]: `${C}${AllCombinations<never, Exclude<U, C>>}` };
```

Since `U` is a union, we need to ensure that conditional type will not apply
distribution to it when checking against `never` type. To do so, we wrap them in
square brackets. Otherwise, it will not check for type being `never`. There is
another solution, where you can read more about it -
[IsNever](./medium-isnever.md).

```typescript
type AllCombinations<S, U extends string = StringToUnion<S>> = [U] extends [
  never
]
  ? ""
  : { [C in U]: `${C}${AllCombinations<never, Exclude<U, C>>}` };
```

At this point, we have combinations of characters in the form of the objects. To
convert them back into union, we can use the indexed access type on the object
type and get anything that is in keys of `U`:

```typescript
type AllCombinations<S, U extends string = StringToUnion<S>> = [U] extends [
  never
]
  ? ""
  : { [C in U]: `${C}${AllCombinations<never, Exclude<U, C>>}` }[U];
```

This way, we got not the objects in key-value form, but the union of all values
of the object which are our combinations.

The last piece of the puzzle is the empty string added to our union:

```typescript
type AllCombinations<S, U extends string = StringToUnion<S>> = [U] extends [
  never
]
  ? ""
  : "" | { [C in U]: `${C}${AllCombinations<never, Exclude<U, C>>}` }[U];
```

The whole solution with two types being made here:

```typescript
type StringToUnion<S> = S extends `${infer C}${infer R}`
  ? C | StringToUnion<R>
  : never;

type AllCombinations<S, U extends string = StringToUnion<S>> = [U] extends [
  never
]
  ? ""
  : "" | { [C in U]: `${C}${AllCombinations<never, Exclude<U, C>>}` }[U];
```

## References

- [Generics](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Generic Constraints](https://www.typescriptlang.org/docs/handbook/2/generics.html#generic-constraints)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Inferring within Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Distributive Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#distributive-conditional-types)
- [Template Literal Types](https://www.typescriptlang.org/docs/handbook/2/template-literal-types.html)
- [Union Types](https://www.typescriptlang.org/docs/handbook/2/everyday-types.html#union-types)
- [Mapped Types](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
