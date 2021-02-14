---
title: Permutation
lang: en
level: medium
tags: union
challenge_url: https://tsch.js.org/296
---

## Challenge

Implement permutation type that transforms union types into the array that includes permutations of unions.

```typescript
type perm = Permutation<'A' | 'B' | 'C'>;
// expected ['A', 'B', 'C'] | ['A', 'C', 'B'] | ['B', 'A', 'C'] | ['B', 'C', 'A'] | ['C', 'A', 'B'] | ['C', 'B', 'A']
```

## Solution

One of the favorite challenges.
It looks like a really complex challenge at first glance, but it’s not.

To understand the solution, I’ll tell you about [“divide and conquer” algorithm](https://en.wikipedia.org/wiki/Divide-and-conquer_algorithm).
If you can’t find a solution to the task, try to find a solution for a subset of a task.
Instead of trying to find the permutations for all the elements, let us start with 0\1 elements.

In case `T` receives `never`, we just return the empty array.
It means that there are no elements, therefore no permutations - an empty array.
Otherwise, `T` holds a single element and as we know, the permutation of a single element is the element itself.
Let us model it in conditional types:

```typescript
type Permutation<T> = T extends never ? [] : [T]
```

With the solution above, we even pass one test already, the test that validates a proper permutation over a union with one element in it.
Exactly as planned.

But how can we find a permutation over two elements?
Still “divide and conquer”.
E.g. we want to find a `Permutation<‘A’ | ‘B’>`, what should we do?
We need to take the first element `A` and find the permutation over the rest of the union, in our case, `Permutation<‘B’>`.
The same with the second element `B`.
We take element `B` and are looking for `Permutation<‘A’>`.
That is exactly what we already know how to do!

Let me try to visualize it:

```text
Permutation<‘A’ | ‘B’> -> [‘A’, ...Permutation<‘B’>] + [‘B’, ...Permutation<‘A’>] -> [‘A’, ‘B’] + [‘B’, ‘A’]
```

So no matter how deep we can go recursively, sometimes we will stop on the base case of recursion.
The base case when we need to find the permutation over a single element.
The case when the answer is already known.

Now, how can we model it in a type system?
Conditional types in TypeScript are distributive over unions.
So when we write `T extends Some<T>` where `T` is a union, what TypeScript does is actually take each element from the union `T` and apply condition to it.
We can use it to iterate over the union and get the element from there by using the construct `T extends infer U ? U : never`.
That way we could exclude the elements from our recursion calls.

Knowing about union elements and knowing what we need to exclude from the recursion, we can implement our “divide and conquer”.
Let us replace the case `[T]` with our algorithm:

```typescript
type Permutation<T> = T extends never ? [] : T extends infer U ? [U, ...Permutation<Exclude<T, U>>] : []
```

We are close to the solution.
Hell, in theory, it even supposed to work, but not.
What went wrong?
We get `never` instead of permutations.
After some digging, I’ve found that we need to wrap our `T` into arrays:

```typescript
type Permutation<T> = [T] extends [never] ? [] : T extends infer U ? [U, ...Permutation<Exclude<T, U>>] : []
```

The most counterintuitive thing left and I still not getting what happened there, honestly.
When working with the construct `T extends infer U`, in our case, it does not work as I was expecting to work.
I was utterly shocked, when just copying the type parameter `T` into another one solves the issue:

```typescript
type Permutation<T, C = T> = [T] extends [never] ? [] : C extends infer U ? [U, ...Permutation<Exclude<T, U>>] : []
```

## References

- [Conditional Types](https://www.typescriptlang.org/docs/handbook/advanced-types.html#conditional-types)
- [Type inference in conditional types](https://www.typescriptlang.org/docs/handbook/advanced-types.html#type-inference-in-conditional-types)
- [Recursive Conditional Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-1.html#recursive-conditional-types)
- [Variadic Tuple Types](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html#variadic-tuple-types)
