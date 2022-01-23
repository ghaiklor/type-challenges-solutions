---
id: 1097
title: IsUnion
lang: en
level: medium
tags: union
---

## Challenge

Implement a type `IsUnion`, which takes an input type `T` and returns whether `T` resolves to a union type.
For example:

```typescript
type case1 = IsUnion<string>; // false
type case2 = IsUnion<string | number>; // true
type case3 = IsUnion<[string | number]>; // false
```

## Solution

When I’m seeing challenges like this one, I always get frustrated.
Because there is no general solution we could use for implementing such a type.
There are no built-in types or intrinsic that we could use.

So that we must be creative and use what we can.
Let us start by thinking about unions and what they represent.

When you specify a plain type, e.g. `string`, it never will be anything else but `string`.
Although, when you specify a union, e.g. `string | number`, you get a set of potential values from the `string` and the `number`.

Plain types do not represent a set of values collectively, while unions do.
There is no sense in distributive iteration on plain types, but it is for unions.

And that is the key difference, how can we detect if the type is union.
When iterating distributively over the type `T`, which is not a union, it changes nothing.
But it changes a lot if it is a union.

TypeScript has a wonderful type feature - distributive conditional types.
When you write the construct `T extends string ? true : false`, where `T` is a union, it will apply the condition distributively.
Roughly, it looks like different conditional types for each element from the union.

```typescript
type IsString<T> = T extends string ? true : false;

// For example, we provide type T = string | number
// It is the same as this
type IsStringDistributive = string extends string
  ? true
  : false | number extends string
  ? true
  : false;
```

You see where I’m heading with this?
If the type `T` is a union, by using distributive conditional types we can split the union and compare it against the input type `T`.
In case, they are the same - it is not a union.
But, when it is a union, they will not be the same, because `string` does not extend from `string | number` and `number` does not extend from `string | number`.

Let us start with implementation already!
At first, we will make a copy of input type `T`, so we can preserve the input type `T` with no further modifications.
We will compare them to each other later.

```typescript
type IsUnion<T, C = T> = never;
```

By applying the conditional type, we get the distributive semantics.
Inside the “true” branch of the conditional type, we will get each item from the union.

```typescript
type IsUnion<T, C = T> = T extends C ? never : never;
```

Now, the most important part - compare the item with the original input type `T`.
In case, these types are the same, it means no distributive iteration was applied - not a union, hence `false`.
Otherwise, distributive iteration was applied and we compare the single item from the union with the union itself, meaning it is a union, hence `true`.

```typescript
type IsUnion<T, C = T> = T extends C ? ([C] extends [T] ? false : true) : never;
```

Done!
To clarify things, let me show you what `[C]` and `[T]` hold in “true” branch of the distributive conditional type.

When we pass not a union, e.g. `string`, they hold the same types.
Meaning, it is not union; we return `false`.

```typescript
[T] = [string][C] = [string];
```

But, if we pass a union, e.g. `string | number`, they hold different types.
While our copy `C` holds a tuple with a union inside, our `T` holds a union of tuples, thanks to distributive conditional types, hence it is a union.

```typescript
[T] = [string] | [number]
[C] = [string | number]
```

## References

- [Union Types](https://www.typescriptlang.org/docs/handbook/2/everyday-types.html#union-types)
- [Generics](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Distributive Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html#distributive-conditional-types)
- [Tuple Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-1-3.html#tuple-types)
