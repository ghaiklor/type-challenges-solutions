---
id: 2759
title: RequiredByKeys
lang: en
level: medium
tags: object-keys
---

## Challenge

Implement a generic `RequiredByKeys<T, K>` which takes two type arguments `T` and `K`.

`K` specifies the set of properties of `T` that should be set to required. When `K` is not provided, it should make all properties required just like the normal `Required<T>`.

## Solution

The challenge asks us to mark all the properties present in `K` to be required. So first let's extract all these properties.

```ts
type RequiredProperties<T, K> = {
  [P in keyof T as P extends K ? P : never]-?: T[P];
};
```

Notice how we've used `-?` in the expression above. This is what we call [Mapping Modifier](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html#mapping-modifiers). This tells TypeScript that we don't want any of the properties to have an optional modifier `?`.

Now that we have the **required** properties, let's extract all the properties that should be left untouched. These are the set of properties which are not present in `K`.

```ts
type MyOmit<F, S> = { [P in keyof F as P extends S ? never : P]: F[P] };

type EverythingFromTExceptK<T, K> = MyOmit<T, K>;
```

Since we have both parts of our solution, let's merge them into one singular type.

```ts
type MyMerge<T> = { [P in keyof T]: T[P] };

type RequiredByKeys<T, K = keyof T> = MyMerge<
  RequiredProperties<T, K> & EverythingFromTExceptK<T, K>
>;
```

## References

- [Mapped Types](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Mapping Modifier](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html#mapping-modifiers)
