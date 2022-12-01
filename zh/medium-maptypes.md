---
id: 5821
title: MapTypes
lang: zh
level: medium
tags: map object utils
---

## Challenge

Implement `MapTypes<T, R>` which will transform types in object `T` to different
types defined by type `R` which has the following structure:

```typescript
type StringToNumber = {
  mapFrom: string; // value of key which value is string
  mapTo: number; // will be transformed for number
};
```

For instance:

```typescript
type StringToNumber = { mapFrom: string; mapTo: number };
MapTypes<{ iWillBeANumberOneDay: string }, StringToNumber>; // gives { iWillBeANumberOneDay: number; }
```

Be aware that user can provide a union of types:

```typescript
type StringToNumber = { mapFrom: string; mapTo: number };
type StringToDate = { mapFrom: string; mapTo: Date };
MapTypes<{ iWillBeNumberOrDate: string }, StringToDate | StringToNumber>; // gives { iWillBeNumberOrDate: number | Date; }
```

If the type doesn't exist in our map, leave it as it was:

```typescript
type StringToNumber = { mapFrom: string; mapTo: number };
MapTypes<
  { iWillBeANumberOneDay: string; iWillStayTheSame: Function },
  StringToNumber
>; // // gives { iWillBeANumberOneDay: number, iWillStayTheSame: Function }
```

## Solution

Object types in the challenge, meaning mapped types comes to the rescue! We need
to enumerate the object and map the value types from one to another.

Let's start with the blank type we need to implement:

```typescript
type MapTypes<T, R> = any;
```

Type parameter `T` has an object type we need to map, and `R` has the mapping.
Let's define the mapping interface as a generic constraint over type parameter
`R`:

```typescript
type MapTypes<T, R extends { mapFrom: unknown; mapTo: unknown }> = any;
```

Before actually do some mapping, let's start with the simple mapped type that
copies the input type `T`:

```typescript
type MapTypes<T, R extends { mapFrom: unknown; mapTo: unknown }> = {
  [P in keyof T]: T[P];
};
```

Now, having the type that “copies” the object type, we can start adding some
mapping there. First, let's check if the value type matches the type from
`mapFrom`, according to challenge specification:

```typescript
type MapTypes<T, R extends { mapFrom: unknown; mapTo: unknown }> = {
  [P in keyof T]: T[P] extends R["mapFrom"] ? never : never;
};
```

In case, we have a match, it means we need to replace the value type with the
type from `mapTo`:

```typescript
type MapTypes<T, R extends { mapFrom: unknown; mapTo: unknown }> = {
  [P in keyof T]: T[P] extends R["mapFrom"] ? R["mapTo"] : never;
};
```

Otherwise, if there is no match, according to spec we need to return the value
type with no mapping:

```typescript
type MapTypes<T, R extends { mapFrom: unknown; mapTo: unknown }> = {
  [P in keyof T]: T[P] extends R["mapFrom"] ? R["mapTo"] : T[P];
};
```

At this point, we pass all the test-cases, but we miss the one that is related
to union. It stated in the challenge spec that there is a possibility to specify
mapping as a union of objects.

So that, we need to enumerate over the mappings itself too. To do so, we can
start by replacing `R['mapTo']` to conditional type. Conditional types in
TypeScript are distributive, meaning they will enumerate over each item in
union. However, it applies to the type that stands in the beginning of a
conditional type. So we start with type parameter `R` and check for match with
the value type:

```typescript
type MapTypes<T, R extends { mapFrom: unknown; mapTo: unknown }> = {
  [P in keyof T]: T[P] extends R["mapFrom"]
    ? R extends { mapFrom: T[P] }
      ? never
      : never
    : T[P];
};
```

Distributive conditional types will do the enumeration over `R` and if at some
point there will be a match with value type `T[P]`, we return the mapping:

```typescript
type MapTypes<T, R extends { mapFrom: unknown; mapTo: unknown }> = {
  [P in keyof T]: T[P] extends R["mapFrom"]
    ? R extends { mapFrom: T[P] }
      ? R["mapTo"]
      : never
    : T[P];
};
```

## References

- [Generics](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Generic Constraints](https://www.typescriptlang.org/docs/handbook/2/generics.html#generic-constraints)
- [Mapped Types](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
- [Indexed Access Types](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
