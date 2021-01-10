<h1>Deep Readonly <img src="https://img.shields.io/badge/-medium-eaa648" alt="medium"/> <img src="https://img.shields.io/badge/-%23readonly-999" alt="#readonly"/> <img src="https://img.shields.io/badge/-%23object--keys-999" alt="#object-keys"/> <img src="https://img.shields.io/badge/-%23deep-999" alt="#deep"/></h1>

## Challenge

Implement a generic `DeepReadonly<T>` which make every parameter of an object - and its sub-objects recursively - readonly.

You can assume that we are only dealing with Objects in this challenge. Arrays, Functions, Classes and so on are no need to take into consideration. However, you can still challenge your self by covering different cases as many as possbile.

For example

```ts
type X = { 
  x: { 
    a: 1
    b: 'hi'
  }
  y: 'hey'
}

type Expected = { 
  readonly x: { 
    readonly a: 1
    readonly b: 'hi'
  }
  readonly y: 'hey' 
}

const todo: DeepReadonly<X> // should be same as `Expected`
```

## Solution

In this challenge, we need to create the same Readonly<T> type.
The only difference is that we need to make it recursive.

Let us start from classic and implement the regular Readonly<T> type:

```ts
type DeepReadonly<T> = { readonly [P in keyof T]: T[P] }
```

But, as you already aware, this type will not make everything read-only, but only the fields that are not in depth.
The reason is that when our T[P] is not a primitive, but an object, it will just pass it as is, without making its properties read-only.

Therefore, we need to replace T[P] with a recursive usage of DeepReadonly<T>.
Do not forget about basic case when using recursions, though.

The algorithm is simple.
In case T[P] is an object, we are going deeper into DeepReadonly, otherwise - return T[P]:

```ts
type DeepReadonly<T> = { readonly [P in keyof T]: T[P] extends Record<string, unknown> ? DeepReadonly<T[P]> : T[P] }
```
