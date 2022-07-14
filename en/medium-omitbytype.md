---
id: 2852
title: OmitByType
lang: en
level: medium
tags: object
---

## Challenge

From `T`, pick a set of properties whose type are not assignable to `U`. For
example:

```typescript
type OmitBoolean = OmitByType<
  {
    name: string;
    count: number;
    isReadonly: boolean;
    isEnable: boolean;
  },
  boolean
>; // { name: string; count: number }
```

## Solution

The example in this challenge already gives a hint that we need to work with
mapped types. Having one object type, we need to create another one which will
be a subset of the first one.

We will start with the blank type that needs to be implemented:

```typescript
type OmitByType<T, U> = any;
```

The goal here is to make a subset, so let's start with a copy of the entire
object. It is a classic implementation that uses mapped types:

```typescript
type OmitByType<T, U> = { [P in keyof T]: T[P] };
```

What is happening here is enumerating all the properties from type parameter `T`
which are going into a new object type we created. That way we have a copy.

Now, we need to filter some properties somehow. To do so, we can use remapping.
We need to check if the type of the value matches the one that have been
provided:

```typescript
type OmitByType<T, U> = {
  [P in keyof T as T[P] extends U ? never : never]: T[P];
};
```

If the value type matches the provided in type parameter `U`, we need to return
`never` type. That way, the property will not be included in the new object.
However, if the types are not matching, we need to return the property as is:

```typescript
type OmitByType<T, U> = { [P in keyof T as T[P] extends U ? never : P]: T[P] };
```

## References

- [Generics](https://www.typescriptlang.org/docs/handbook/2/generics.html)
- [Mapped Types](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
- [Key Remapping via as](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html#key-remapping-via-as)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
