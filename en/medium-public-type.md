---
id: 28333
title: PublicType
lang: en
level: medium
tags: template-literal mapped-type
---

## Challenge

Implement the Public Type challenge `PublicType<T extends object>` that requires removing the key starting with `_key` from the given type `T``.

## Solution

We need to return a new object type here, but without keys that include the `_key`. It is a hint that we need to use
[mapped types](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
here. We need to map each property in the object and check if it includes the `_key` we remove it.

Let us start with the basic block and construct the same object:

```ts
type PublicType<T extends object> = { [P in keyof T]: T[P] };
```

Here, we iterate over all the keys in `T`, map it to the type `P` and make it a
key in our new object type, while the value type is the type from `T[P]`.

That way, we iterate over all the keys, but we need to filter out those that we
are not interested in "that include the _ do you remember ?". To achieve that, we can
[remap the key type using “as” syntax](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#key-remapping-in-mapped-types) and test if the key includes the _ [check the key type using Template Literal syntax](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types):

```ts
type PublicType<T extends object> = {
  [P in keyof T as P extends `_${any}` ? never : P]: T[P];
};
```

We map all the properties from `T` and if the property is `_ + K`, we return the “never” type as its key, otherwise the key itself. That way, we filter
out the properties and got the required object type.

## References

- [Mapped Types](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
- [Index Types](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)
- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Key remapping in mapped types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#key-remapping-in-mapped-types)
- [Template Literal Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#template-literal-types)
