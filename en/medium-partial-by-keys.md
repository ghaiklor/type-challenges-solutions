---
id: 2757
title: PartialByKeys
lang: en
level: medium
tags: object-keys union
---

## Challenge

Implement a generic `PartialByKeys<T, K>` which takes two type arguments `T` and `K`.

`K` specifies the set of properties of `T` that should be set to optional.
When `K` is not provided, it should make all properties optional just like the normal `Partial<T>`.

## Solution

Okay, let's break down the challenge into three parts.

- Extract all the properties of `T` which are present in `K` and mark them optional.
- Extract all the properties of `T` which are not present in `K` and keep them as is.
- Merge both of the types mentioned above to get the answer.

Okay, how do we create a new type by picking all the properties from `T` except `K`?

That's right.
We can use the `Omit` type utility exposed by TypeScript or create our own Omit type helper.

```typescript
type MyOmit<F, S> = { [P in keyof F as P extends S ? never : P]: F[P] };
type EverythingFromTExceptK<T, K> = MyOmit<T, K>;
```

Now let's extract all the properties from `K` present in `T` and mark them optional.
We can do so by using [mapped types](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html).

```typescript
type OptionalProperties<T, K> = {
  [P in keyof T as P extends K ? P : never]?: T[P];
};
```

Pretty amazing right?
Now that we have both parts of our solution, let's merge them.

```typescript
type PartialByKeys<T, K = keyof T> = OptionalProperties<T, K> &
  EverythingFromTExceptK<T, K>;
```

Note that this still does not solve our problem.
Taking a closer look at the generated type, we can see `PartialByKeys` spits out `{...properties} & {...some other properties}`.
So to reach our final answer, we will have to merge both the types into one singular type.

```typescript
type MyMerge<T> = { [P in keyof T]: T[P] };
type PartialByKeys<T, K = keyof T> = MyMerge<
  OptionalProperties<T, K> & EverythingFromTExceptK<T, K>
>;
```

## References

- [Mapped Types](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
