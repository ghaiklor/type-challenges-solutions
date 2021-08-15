---
id: 1367
title: Remove Index Signature
lang: en
level: medium
tags: object-keys
---

## Challenge

Implement `RemoveIndexSignature<T>`, exclude the index signature from object types.
For example:

```typescript
type Foo = {
  [key: string]: any;
  foo(): void;
}

type A = RemoveIndexSignature<Foo> // expected { foo(): void }
```

## Solution

We are having a deal with the objects here.
I bet we will use mapped types later.
But for now, let us dive into the problem statement and figure out the requirement.

We have been asked to remove index signatures from the object types.
How do they look like?
By calling `keyof` operator we can take a peek into it.

E.g. having a type “Bar” and calling `keyof` on it results in:

```typescript
type Bar = { [key: number]: any; bar(): void; } // number | “bar”
```

Interesting, so it turns out that they represent any key on the object as a string type literal.
While the index signature has just a type like `number` or `string`.

It leads me to the idea that we need to filter out any keys that are not type literals.
But, how do we check if the type is a type literal or not?
We can use the nature of sets and check if some set is a subset or not.
For instance, the type literal “foo” extends from the string, but not otherwise, “foo” is too narrow to be a string.

```typescript
"foo" extends string // true
string extends "foo" // false
```

Let’s use it and create a type that will filter out strings and numbers, leaving only type literals.
First, we will check the case with the `string`:

```typescript
type TypeLiteralOnly<T> = string extends T ? never : never;
```

In case `T` is a `string`, the condition evaluates to `true`.
What do we do if we got a `string`?
We skip it by returning the `never` type.
Otherwise, let us check the same for the `number` type:

```typescript
type TypeLiteralOnly<T> = string extends T ? never : number extends T ? never : never;
```

What if `T` is neither a `string` nor `number`?
It means we got a type literal here, so we return it back to the caller:

```typescript
type TypeLiteralOnly<T> = string extends T ? never : number extends T ? never : T;
```

Now, we have a wrapper that can filter out index signature and return type literals only.
How do we apply it on each key?
By using mapped types!

At first, let us create a copy of the type:

```typescript
type RemoveIndexSignature<T> = { [P in keyof T]: T[P] }
```

While iterating on the keys, we can remap them by using our wrapper.
We call `TypeLiteralOnly` on each key:

```typescript
type RemoveIndexSignature<T> = { [P in keyof T as TypeLiteralOnly<P>]: T[P] }
```

That way, we have an iteration on the keys that filters out index signature, leaving type literals only.

```typescript
type TypeLiteralOnly<T> = string extends T ? never : number extends T ? never : T;
type RemoveIndexSignature<T> = { [P in keyof T as TypeLiteralOnly<P>]: T[P] }
```

## References

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Mapped Types](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
- [Key remapping via as](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html#key-remapping-via-as)
