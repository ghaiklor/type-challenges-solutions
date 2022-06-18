---
id: 8
title: Readonly 2
lang: en
level: medium
tags: readonly object-keys
---

## Challenge

Implement a generic `MyReadonly2<T, K>` which takes two type arguments `T` and `K`.

`K` specify the set of properties of `T` that should set to `readonly`.
When `K` is not provided, it should make all properties `readonly`, just like the normal `Readonly<T>`.
For example:

```ts
interface Todo {
  title: string;
  description: string;
  completed: boolean;
}

const todo: MyReadonly2<Todo, "title" | "description"> = {
  title: "Hey",
  description: "foobar",
  completed: false,
};

todo.title = "Hello"; // Error: cannot reassign a readonly property
todo.description = "barFoo"; // Error: cannot reassign a readonly property
todo.completed = true; // OK
```

## Solution

This challenge is a continuation of [`Readonly<T>`](./easy-readonly.md) challenge.
Everything is pretty the same, except that we need to add a new type parameter called `K` so we could specify the exact properties to be read-only.

We start with the simplest solution, the case when `K` is an empty set so that nothing need to be read-only.
We just return `T`:

```ts
type MyReadonly2<T, K> = T;
```

Now, we need to handle the case, when we provide the properties in `K`.
We can use `&` operator and make [intersection of both types](https://www.typescriptlang.org/docs/handbook/2/objects.html#intersection-types): the one is the `T` we had before and the second one is the type with read-only properties:

```ts
type MyReadonly2<T, K> = T & { readonly [P in K]: T[P] };
```

Looks like a solution, but we are getting a compilation error “Type ‘P’ cannot be used to index type ‘T’”.
And that is true, we do not set a constraint on `K`.
It should be “every key from `T`”:

```ts
type MyReadonly2<T, K extends keyof T> = T & { readonly [P in K]: T[P] };
```

Works now?
No!
We do not handle the case when `K` is not set at all.
That is the case when our type must behave as an usual `Readonly<T>` type.
To fix that, we are just specifying the default type parameter for `K` to be “all the keys from `T`”:

```ts
// solution-1
type MyReadonly2<T, K extends keyof T = keyof T> = T & {
  readonly [P in K]: T[P];
};
```

you maybe find that the solution-1 doesn't work in TypeScript 4.5+， because the original behavior is a bug in TypeScript, filed at [microsoft/TypeScript#45122](https://github.com/microsoft/TypeScript/issues/45122), fixed in [microsoft/TypeScript#45263](https://github.com/microsoft/TypeScript/pull/45263), which was released in TypeScript 4.5. Intersections conceptually mean "and", so `{readonly a: string} & {a: string}` should be equivalent to `{a: string}`,  i.e., the property `a ` is writable and readable.  

Before TypeScript 4.5, TypeScript had the opposite and incorrect behavior, where a final object property is `readonly` if it is `readonly` in some intersection members. This was wrong, and it was fixed. So this is the reason why the solution-1 doesn't work. To fix this, you can write like this:

```ts
//Solution-2
type MyReadonly2<T, K extends keyof T = keyof T> = Omit<T, K> & {
  readonly [P in K]: T[P]
}
//i.e.
type MyReadonly2<T, K extends keyof T = keyof T> = Omit<T, K> & Readonly<T>
```

The solution-2 can add `readonly` modifiers because none of the keys in `K` present in `keyof Omit<T, K>`.

## References

- [Intersection types](https://www.typescriptlang.org/docs/handbook/2/objects.html#intersection-types)
- [Mapped Types](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
- [Index Types](https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html)
- [Using type parameters in generic constraints](https://www.typescriptlang.org/docs/handbook/2/generics.html#using-type-parameters-in-generic-constraints)
