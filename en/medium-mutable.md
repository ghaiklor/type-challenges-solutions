---
id: 2793
title: Mutable
lang: en
level: medium
tags: readonly object-keys
---

## Challenge

Implement the generic `Mutable<T>` which makes all properties in `T` mutable.
For example:

```typescript
interface Todo {
  readonly title: string;
  readonly description: string;
  readonly completed: boolean;
}

// { title: string; description: string; completed: boolean; }
type MutableTodo = Mutable<T>;
```

## Solution

Again, the challenge that is not supposed to be in medium category, IMHO.
I’ve solved it with no issues.
But, anyway, we are solving all of them, so why bothering about it.

We know that there is a type with read only modifiers on object’s properties.
The same modifiers we used some time ago to solve [Readonly challenge](./easy-readonly.md).
However, in this case, we have been asked to remove it from the type.

Let’s start with the simplest thing, just copy the type as it is, using mapped types:

```typescript
type Mutable<T> = { [P in keyof T]: T[P] };
```

Now it is a copy of `T` with the read only modifiers.
How can we get rid of them?
Well, remember that to add them, in the previous challenges, we just used the keyword `readonly` added to the mapped type:

```typescript
type Mutable<T> = { readonly [P in keyof T]: T[P] };
```

Implicitly, TypeScript has added a `+` to the `readonly` keyword, meaning that we want to add the modifier to the property.
But in our case, we want to discard it, so we can use `-` instead:

```typescript
type Mutable<T> = { -readonly [P in keyof T]: T[P] };
```

That way, we’ve implemented a type that discards the read only modifier from the properties.

## References

- [Mapped Types](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
- [Mapping Modifiers](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html#mapping-modifiers)
