---
id: 1978
title: Percentage Parser
lang: en
level: medium
tags: parser
---

## Challenge

Implement `PercentageParser<T extends string>`. According to the
`/^(\+|\-)?(\d*)?(\%)?$/` regularity to match `T` and get three matches.

The structure should be: `[plus or minus, number, unit]`. If it is not captured,
the default is an empty string. For example:

```typescript
type PString1 = "";
type PString2 = "+85%";
type PString3 = "-85%";
type PString4 = "85%";
type PString5 = "85";

type R1 = PercentageParser<PString1>; // expected ['', '', '']
type R2 = PercentageParser<PString2>; // expected ["+", "85", "%"]
type R3 = PercentageParser<PString3>; // expected ["-", "85", "%"]
type R4 = PercentageParser<PString4>; // expected ["", "85", "%"]
type R5 = PercentageParser<PString5>; // expected ["", "85", ""]
```

## Solution

Parsing some stuff is a really interesting task (personally for me). Although,
we can’t do much here where all we have is only a type system. So that we can’t
make a brilliant solution for generations, but it will be decent enough.

We need to parse three components from the string: the sign, the number and the
percent sign. In order to simplify solution, let us break this task into three
separate types. The first type will parse the sign from the string. The second
one will return a number and the third type the percent sign.

Let us start with the sign first. We need to check if the first sign in the
string is the plus or minus. To do so, we need to infer the first character:

```typescript
type ParseSign<T extends string> = T extends `${infer S}${any}` ? never : never;
```

Having a first character in type parameter `S`, we can check if the character is
a plus or minus. And if so, we just return the `S`, return the inferred sign we
just got. In all other cases, we return an empty string, meaning there is no
plus or minus:

```typescript
type ParseSign<T extends string> = T extends `${infer S}${any}`
  ? S extends "+" | "-"
    ? S
    : ""
  : "";
```

That way, we got a type that returns a sign in case it is present in the string.
Now, we can do the same for a percent sign.

Let us check if the incoming string has a percent sign at the end of the string:

```typescript
type ParsePercent<T extends string> = T extends `${any}%` ? never : never;
```

In case there is a percent sign, well... we return a percent sign, otherwise an
empty string. Simple as that.

```typescript
type ParsePercent<T extends string> = T extends `${any}%` ? "%" : "";
```

Having two parsers responsible for getting signs, we can start thinking about
the number itself. We need to infer the part of the string that is between
signs. The problem is that these signs are optional.

To implement support for the optional character, we need to duplicate the same
logic of checking for a character we already had. Why? Because if we don’t get
rid of the signs, they will be present in our number. We don’t need it. We need
to get rid of the signs if they are present and not otherwise.

But we are lucky, we already did it in our parsers before. All we need to do is
combine them together and infer the number:

```typescript
type ParseNumber<T extends string> =
  T extends `${ParseSign<T>}${infer N}${ParsePercent<T>}` ? never : never;
```

You see what’s happening? First, we are parsing the sign and if it is present,
we will get a sign character that goes as part of template literal type. Hence,
leaving the inferring part without the sign. The same goes for the percent sign.
In case the percent sign is present, it will go as part of template literal
type, not the inferring part.

That leaves us with number only, that we are inferring via `infer` keyword.
Let’s return it now:

```typescript
type ParseNumber<T extends string> =
  T extends `${ParseSign<T>}${infer N}${ParsePercent<T>}` ? N : "";
```

I bet you already understand how can we combine these together now. As the
challenge description stated, we need to return a tuple with three elements. So
let’s do that and fill them with our types:

```typescript
type PercentageParser<A extends string> = [
  ParseSign<A>,
  ParseNumber<A>,
  ParsePercent<A>
];
```

Congratulations! We got a simple parser that is implemented in the type system.

## References

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Inferring within Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#inferring-within-conditional-types)
- [Template Literal Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types)
