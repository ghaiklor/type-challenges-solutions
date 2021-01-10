<h1>Tuple to Object <img src="https://img.shields.io/badge/-easy-90bb12" alt="easy"/> </h1>

## Challenge

Given an array, transform to a object type and the key/value must in the given array.

For example

```ts
const tuple = ['tesla', 'model 3', 'model X', 'model Y'] as const

const result: TupleToObject<typeof tuple> // expected { tesla: 'tesla', 'model 3': 'model 3', 'model X': 'model X', 'model Y': 'model Y'}
```

## Solution

We need to take all the values from the array and make it as keys and values in our new object.

It is easy to do with lookup types.
We can get the values from an array by using `T[number]` construct.
With the help of mapped types, we can iterate over those values in `T[number]` and return a new type where the key and value is the type from `T[number]`:

```ts
type TupleToObject<T extends readonly any[]> = { [K in T[number]]: K }
```
