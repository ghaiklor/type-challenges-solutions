---
id: 645
title: Diff
lang: en
level: medium
tags: object
---

## Challenge

Get an `Object` that is the difference between `O` & `O1`.

For example:

```typescript
type Foo = {
  name: string;
  age: string;
};

type Bar = {
  name: string;
  age: string;
  gender: number;
};

type test0 = Diff<Foo, Bar>; // expected { gender: number }
```

## Solution

We see that this challenge requires us to do the manipulation with objects.
So highly possible, mapped types are for the rescue here.

Let us start with the mapped type where we iterate over the union of properties for both objects.
Before calculating the difference, we need to gather all the properties from both objects after all.

```typescript
type Diff<O, O1> = { [P in keyof O | keyof O1]: never };
```

When iterating over the properties, we need to check if the property exists on `O` or `O1`.
So we need to add a conditional type here to find out where from we need to get the value type.

```typescript
type Diff<O, O1> = {
  [P in keyof O | keyof O1]: P extends keyof O
    ? O[P]
    : P extends keyof O1
    ? O1[P]
    : never;
};
```

Great!
We have an object here, that is a union of all properties from both objects.
The last thing remains is to filter out those properties that are existing on both objects.

How can we get all the properties that are exist on both objects?
Intersection types!
We get the intersection type and exclude it from our mapped type `P`.

```typescript
type Diff<O, O1> = {
  [P in keyof O | keyof O1 as Exclude<P, keyof O & keyof O1>]: P extends keyof O
    ? O[P]
    : P extends keyof O1
    ? O1[P]
    : never;
};
```

## References

- [Mapped Types](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
- [Key remapping in Mapped Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#key-remapping-in-mapped-types)
- [Union Types](https://www.typescriptlang.org/docs/handbook/2/everyday-types.html#union-types)
- [Intersection Types](https://www.typescriptlang.org/docs/handbook/2/objects.html#intersection-types)
- [Index Types](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [keyof and Lookup Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-1.html#keyof-and-lookup-types)
