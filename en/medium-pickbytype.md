---
id: 2595
title: PickByType
lang: en
level: medium
tags: object
---

## Challenge

From `T`, pick a set of properties whose type are assignable to `U`. For
example:

```typescript
type OnlyBoolean = PickByType<
  {
    name: string;
    count: number;
    isReadonly: boolean;
    isEnable: boolean;
  },
  boolean
>; // { isReadonly: boolean; isEnable: boolean; }
```

## Solution

In this challenge, we need to iterate over the object and filter out only those
fields that are assignable to `U`. It is obvious that we definitely need to
start from the mapped types.

So that we begin with creating an object that copies all the keys from the `T`:

```typescript
type PickByType<T, U> = { [P in keyof T]: T[P] };
```

First, we got all the keys from the `T` and applied an iteration to them. On
each iteration, TypeScript will assign the key to type `P`. Having a key, we get
the value type by using lookup types `T[P]`.

Now, applying a filter to the iteration will allow us to find only those that
are assignable to `U`. When I’m saying “filter”, I mean the key remapping in
this case. We can apply key remapping and check if the key is the key we need:

```typescript
type PickByType<T, U> = {
  [P in keyof T as T[P] extends U ? never : never]: T[P];
};
```

Notice the `as` keyword, it is the keyword that shows the start of key
remapping. After the keyword, we can write a conditional type to check the value
type. In case the value type is assignable to the type `U`, we will return the
key as is with no changes. However, in case the value type is not assignable to
`U`, we leave `never`:

```typescript
type PickByType<T, U> = { [P in keyof T as T[P] extends U ? P : never]: T[P] };
```

That way, we made a type that filters out the keys by its value type.

## References

- [Mapped Types](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
- [Key remapping via as](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html#key-remapping-via-as)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [keyof and Lookup Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-1.html#keyof-and-lookup-types)
